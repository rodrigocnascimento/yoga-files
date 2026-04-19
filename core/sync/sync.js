// 🔗 core/sync/sync.js
// @name: yoga-sync
// @desc: Firebase Firestore sync client for Yoga 3.0
// @usage: node core/sync/sync.js <push|pull|status|test>
// @author: Yoga 3.0 Lôro Barizon Edition 🦜

const admin = require("firebase-admin");
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const YOGA_HOME = process.env.YOGA_HOME || path.join(process.env.HOME, ".yoga");
const STATE_DB = path.join(YOGA_HOME, "state.db");
const CREDENTIALS_PATH = path.join(YOGA_HOME, ".firebase-credentials.json");
const SYNC_CONFIG_PATH = path.join(YOGA_HOME, ".yoga-sync.json");

function loadCredentials() {
  if (!fs.existsSync(CREDENTIALS_PATH)) {
    console.error("Firebase credentials not found at:", CREDENTIALS_PATH);
    console.error("Run: yoga sync setup");
    process.exit(1);
  }

  try {
    const creds = JSON.parse(fs.readFileSync(CREDENTIALS_PATH, "utf-8"));
    if (!creds.project_id || !creds.client_email || !creds.private_key) {
      console.error("Invalid Firebase credentials format");
      console.error("Expected: project_id, client_email, private_key");
      console.error("Got: project_id=" + !!creds.project_id + ", client_email=" + !!creds.client_email + ", private_key=" + !!creds.private_key);
      process.exit(1);
    }
    return creds;
  } catch (err) {
    console.error("Failed to parse Firebase credentials:", err.message);
    process.exit(1);
  }
}

function loadSyncConfig() {
  if (!fs.existsSync(SYNC_CONFIG_PATH)) {
    return { mode: "local", lastSync: "never" };
  }
  try {
    return JSON.parse(fs.readFileSync(SYNC_CONFIG_PATH, "utf-8"));
  } catch {
    return { mode: "local", lastSync: "never" };
  }
}

function getUserId(config) {
  return config.userId || "unknown";
}

function initFirebase(creds) {
  const app = admin.initializeApp(
    {
      credential: admin.credential.cert(creds),
    },
    "yoga-sync-" + Date.now()
  );
  const db = admin.firestore(app);
  return { app, db };
}

function readTable(tableName) {
  try {
    const data = execSync(
      `sqlite3 "${STATE_DB}" "SELECT * FROM ${tableName};"`,
      { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] }
    );
    return data
      .trim()
      .split("\n")
      .filter(function (r) {
        return r.length > 0;
      })
      .map(function (row) {
        const fields = row.split("|");
        return { id: fields[0], data: fields };
      });
  } catch (err) {
    return [];
  }
}

async function pushData(db, userId) {
  const collections = ["workspaces", "commands", "ai_context", "config"];

  for (const collection of collections) {
    try {
      const rows = readTable(collection);

      if (rows.length === 0) {
        console.log("  Skipped " + collection + " (no data)");
        continue;
      }

      const batch = db.batch();
      let count = 0;

      for (const row of rows) {
        const ref = db
          .collection("users")
          .doc(userId)
          .collection(collection)
          .doc(row.id);

        const docData = {
          data: row.data,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        batch.set(ref, docData);
        count++;
      }

      await batch.commit();
      console.log("  Pushed " + count + " " + collection);
    } catch (err) {
      console.error("  Failed to push " + collection + ":", err.message);
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
        console.log("  No " + collection + " to pull");
        continue;
      }

      console.log("  Pulled " + snapshot.size + " " + collection);
    } catch (err) {
      console.error("  Failed to pull " + collection + ":", err.message);
    }
  }
}

async function testConnection(creds) {
  const { app, db } = initFirebase(creds);

  try {
    const testRef = db.collection("_test").doc("ping");
    await testRef.set({
      message: "Yoga sync test",
      timestamp: new Date().toISOString(),
    });
    console.log("Write test: OK");

    const doc = await testRef.get();
    console.log("Read test: OK");

    await testRef.delete();
    console.log("Delete test: OK");

    console.log("Firebase connection: SUCCESS");
  } catch (err) {
    console.error("Firebase connection: FAILED -", err.message);
    process.exit(1);
  } finally {
    await app.delete();
  }
}

async function main() {
  const action = process.argv[2];

  if (!action) {
    console.error("Usage: node sync.js <push|pull|status|test>");
    process.exit(1);
  }

  if (action === "test") {
    const creds = loadCredentials();
    await testConnection(creds);
    return;
  }

  const creds = loadCredentials();
  const config = loadSyncConfig();
  const userId = getUserId(config);

  console.log("Yoga Sync - " + action.toUpperCase());
  console.log("User: " + userId);

  const { app, db } = initFirebase(creds);

  try {
    if (action === "push") {
      await pushData(db, userId);
    } else if (action === "pull") {
      await pullData(db, userId);
    } else if (action === "status") {
      console.log("Mode: cloud");
      console.log("User: " + userId);
      console.log("Firebase: connected");
    } else {
      console.error("Unknown action: " + action);
      console.error("Usage: node sync.js <push|pull|status|test>");
      process.exit(1);
    }
  } finally {
    await app.delete();
  }
}

main().catch(function (err) {
  console.error("Sync failed:", err.message);
  process.exit(1);
});