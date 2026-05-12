import { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import { useProfile } from '../../hooks';

const links = ['About','Experience','Qualifications','Projects','Skills','Vision','Contact'];

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  const { data: profile } = useProfile();

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 80);
    window.addEventListener('scroll', handler);
    return () => window.removeEventListener('scroll', handler);
  }, []);

  const scrollTo = (id: string) => {
    document.getElementById(id.toLowerCase())?.scrollIntoView({ behavior: 'smooth' });
    setOpen(false);
  };

  const initials = profile?.name
    ? profile.name.split(' ').filter(Boolean).map((n: string) => n[0]).join('')
    : 'UP';

  return (
    <nav className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${scrolled ? 'backdrop-blur-md bg-navy/80 border-b border-gold/10' : ''}`}>
      <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <div className="w-10 h-10 rounded-full bg-gold flex items-center justify-center">
          <span className="text-navy font-playfair font-bold text-sm">{initials}</span>
        </div>
        <div className="hidden md:flex items-center gap-8">
          {links.map(l => (
            <button key={l} onClick={() => scrollTo(l.toLowerCase())}
              className="text-sm text-gray-400 hover:text-gold transition-colors">
              {l}
            </button>
          ))}
          {profile?.openToWork && (
            <span className="px-3 py-1 rounded-full bg-gold/20 text-gold text-xs border border-gold/30">
              Open to Work
            </span>
          )}
        </div>
        <button className="md:hidden text-gray-400" onClick={() => setOpen(!open)}>
          {open ? <X size={24} /> : <Menu size={24} />}
        </button>
      </div>
      {open && (
        <div className="md:hidden bg-navy/95 backdrop-blur border-t border-gold/10 px-6 py-4 flex flex-col gap-4">
          {links.map(l => (
            <button key={l} onClick={() => scrollTo(l.toLowerCase())} className="text-gray-300 hover:text-gold text-left">
              {l}
            </button>
          ))}
        </div>
      )}
    </nav>
  );
}
