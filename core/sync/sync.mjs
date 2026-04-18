// 🔗 core/sync/sync.mjs
// @name: yoga-sync
// @desc: Firebase Firestore sync client for Yoga 3.0
// @usage: node core/sync/sync.mjs <push|pull>
// @author: Yoga 3.0 Lôro Barizon Edition 🦜

import { readFileSync, writeFileSync, existsSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

const YOGA_HOME = process.env.YOGA_HOME || join(process.env.HOME, ".yoga");
const STATE_DB = join(YOGA_HOME, "state.db");
const CREDENTIALS_PATH = join(YOGA_HOME, ".firebase-credentials.json");
const SYNC_CONFIG_PATH = join(YOGA_HOME, ".yoga-sync.json");

function loadCredentials() {
  if (!existsSync(CREDENTIALS_PATH)) {
    console.error("❌ Firebase credentials not found at:", CREDENTIALS_PATH);
    console.error("   Run: yoga sync setup");
    process.exit(1);
  }

  try {
    const creds = JSON.parse(readFileSync(CREDENTIALS_PATH, "utf-8"));
    if (!creds.projectId || !creds.clientEmail || !creds.privateKey) {
      console.error("❌ Invalid Firebase credentials format");
      console.error("   Expected: projectId, clientEmail, privateKey");
      process.exit(1);
    }
    return creds;
  } catch (err) {
    console.error("❌ Failed to parse Firebase credentials:", err.message);
    process.exit(1);
  }
}

function loadSyncConfig() {
  if (!existsSync(SYNC_CONFIG_PATH)) {
    return { mode: "local", lastSync: "never" };
  }
  try {
    return JSON.parse(readFileSync(SYNC_CONFIG_PATH, "utf-8"));
  } catch {
    return { mode: "local", lastSync: "never" };
  }
}

function getUserId(config) {
  return config.userId || "unknown";
}

async function initFirebase(creds) {
  try {
    const { initializeApp } = await import("firebase-admin/app");
    const cert = {
      projectId: creds.projectId,
      clientEmail: creds.clientEmail,
      privateKey: creds.privateKey,
    };

    const app = initializeApp({
      credential: await import("firebase-admin/app").then((m) =>
        m.cert(cert)
      ),
    });

    const { getFirestore } = await import("firebase-admin/firestore");
    return getFirestore(app);
  } catch (err) {
    if (err.code === "MODULE_NOT_FOUND") {
      console.error("❌ firebase-admin not installed!");
      console.error("   Run: cd core/sync && npm install");
      process.exit(1);
    }
    throw err;
  }
}

async function pushData(db, userId) {
  const { readFileSync } = await import("fs");
  const { execSync } = await import("child_process");

  const collections = ["workspaces", "commands", "ai_context", "config"];

  for (const collection of collections) {
    try {
      const data = execSync(
        `sqlite3 "${STATE_DB}" "SELECT * FROM ${collection};"`,
        { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }
      );

      const rows = data
        .trim()
        .split("\n")
        .filter((r) => r.length > 0)
        .map((row) => {
          const fields = row.split("|");
          return { id: fields[0], data: fields.slice(1).join("|") };
        });

      const batch = db.batch();
      for (const row of rows) {
        const ref = db
          .collection("users")
          .doc(userId)
          .collection(collection)
          .doc(row.id);
        batch.set(ref, { data: row.data, updatedAt: new Date() });
      }
      await batch.commit();
      console.log(`✅ Pushed ${rows.length} ${collection}`);
    } catch (err) {
      if (err.status === 1) {
        console.log(`⏭️  Skipped ${collection} (table may not exist)`);
      } else {
        console.error(`❌ Failed to push ${collection}:`, err.message);
      }
    }
  }
}

async function pullData(db, userId) {
  const collections = ["workspaces", "commands", "ai_context", "config"];

  for (const collection of collections) {
    try {
      const snapshot = await db
        .collection("users")
        .doc(userId)
        .collection(collection)
        .get();

      if (snapshot.empty) {
        console.log(`⏭️  No ${collection} to pull`);
        continue;
      }

      console.log(`✅ Pulled ${snapshot.size} ${collection}`);
    } catch (err) {
      console.error(`❌ Failed to pull ${collection}:`, err.message);
    }
  }
}

async function main() {
  const action = process.argv[2];

  if (!action || !["push", "pull"].includes(action)) {
    console.error("Usage: node sync.mjs <push|pull>");
    process.exit(1);
  }

  const creds = loadCredentials();
  const config = loadSyncConfig();
  const userId = getUserId(config);

  console.log(`🔗 Yoga Sync - ${action.toUpperCase()}`);
  console.log(`👤 User: ${userId}`);

  const db = await initFirebase(creds);

  if (action === "push") {
    await pushData(db, userId);
  } else {
    await pullData(db, userId);
  }
}

main().catch((err) => {
  console.error("❌ Sync failed:", err.message);
  process.exit(1);
});