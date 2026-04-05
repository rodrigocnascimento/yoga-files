---
id: landing-page-backup
title: 🚑 Backup Landing Page
sidebar_position: 4
---

# Backup da Landing Page

Durante uma troca de contexto, a branch que continha a Landing Page (`feat/feture-006-landing-page`) se perdeu localmente no Host. No entanto, a IA manteve os componentes essenciais em memória.

Aqui está o código recuperado para que possamos reconstruir a página a qualquer momento.

## `src/app.tsx`
```tsx
import {
  CTA, Comparison, FAQ, Features, Footer, Hero,
  HowItWorks, Navbar, SocialProof, TechStack, TerminalDemo,
} from './components/sections';

export function App() {
  return (
    <div className="min-h-screen bg-zen-bg text-zen-text overflow-x-hidden">
      <Navbar />
      <main>
        <Hero />
        <SocialProof />
        <Features />
        <Comparison />
        <HowItWorks />
        <TerminalDemo />
        <TechStack />
        <FAQ />
        <CTA />
      </main>
      <Footer />
    </div>
  );
}
```

## `src/index.css` (Com correção do Tailwind v4)
```css
/* Tailwind sempre no topo */
@import "tailwindcss";

/* Zen fonts */
@import url("https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Quicksand:wght@400;500;600;700&display=swap");

@theme {
  --color-sage: #a8c9a5;
  --color-sage-dark: #7fa377;
  --color-lavender: #c5b9cd;
  --color-lavender-dark: #9f8ba6;
  --color-sky: #b8d4e3;
  --color-sky-dark: #8ab4c9;
  
  --color-zen-bg: #f7f5f0;
  --color-zen-surface: #fffbf5;
  --color-zen-card: #f5f2eb;
  --color-zen-border: #e8e4da;
  
  --color-zen-text: #4a4a48;
  --color-zen-text-secondary: #7a7a77;
  --color-zen-text-muted: #a5a5a2;
}

body {
  margin: 0;
  background-color: var(--color-zen-bg);
  color: var(--color-zen-text);
}
```

## `src/components/ui/mouse-glow-card.tsx`
```tsx
import { type ReactNode, useRef, useState } from 'react';

interface MouseGlowCardProps {
  children: ReactNode;
  className?: string;
  glowColor?: string;
}

export function MouseGlowCard({
  children,
  className = '',
  glowColor = 'rgba(168, 201, 165, 0.2)',
}: MouseGlowCardProps) {
  const cardRef = useRef<HTMLDivElement>(null);
  const [glowPosition, setGlowPosition] = useState({ x: 0, y: 0 });
  const [isHovered, setIsHovered] = useState(false);

  const handleMouseMove = (event: React.MouseEvent<HTMLDivElement>) => {
    const card = cardRef.current;
    if (!card) return;
    const rect = card.getBoundingClientRect();
    setGlowPosition({
      x: event.clientX - rect.left,
      y: event.clientY - rect.top,
    });
  };

  return (
    <div
      ref={cardRef}
      className={`relative overflow-hidden rounded-xl border border-zen-border bg-zen-card transition-all duration-300 ${className}`}
      onMouseMove={handleMouseMove}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      {isHovered && (
        <div
          className="absolute pointer-events-none transition-opacity duration-300"
          style={{
            left: glowPosition.x - 150,
            top: glowPosition.y - 150,
            width: 300,
            height: 300,
            background: `radial-gradient(circle, ${glowColor} 0%, transparent 70%)`,
            opacity: isHovered ? 1 : 0,
          }}
          aria-hidden="true"
        />
      )}
      <div className="relative z-10">{children}</div>
    </div>
  );
}
```
