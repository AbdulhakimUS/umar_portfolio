import { useEffect, useState } from 'react';
import Navbar from './Navbar';
import Footer from './Footer';
import { Profile } from '../../types';

export default function Layout({ children, profile }: { children: React.ReactNode; profile?: Profile }) {
  const [cursor, setCursor] = useState({ x: -100, y: -100, hovered: false });

  useEffect(() => {
    const move = (e: MouseEvent) => setCursor(c => ({ ...c, x: e.clientX, y: e.clientY }));
    const over = (e: MouseEvent) => {
      const t = e.target as HTMLElement;
      setCursor(c => ({ ...c, hovered: !!(t.closest('a,button,[role=button]')) }));
    };
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseover', over);
    return () => { window.removeEventListener('mousemove', move); window.removeEventListener('mouseover', over); };
  }, []);

  return (
    <div className="min-h-screen bg-navy font-inter">
      <div className="fixed pointer-events-none z-[9999] rounded-full bg-gold transition-all duration-100"
        style={{ left: cursor.x - (cursor.hovered ? 12 : 6), top: cursor.y - (cursor.hovered ? 12 : 6), width: cursor.hovered ? 24 : 12, height: cursor.hovered ? 24 : 12, opacity: 0.8 }} />
      <Navbar profile={profile} />
      <main>{children}</main>
      <Footer />
    </div>
  );
}
