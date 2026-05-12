import { motion } from 'framer-motion';
import { useMouseParallax } from '../../hooks';
import { Profile } from '../../types';
import { ChevronDown } from 'lucide-react';
import { useState, useEffect } from 'react';

export default function HeroSection({ profile }: { profile?: Profile }) {
  const parallax = useMouseParallax();
  const [typed, setTyped] = useState('');
  const tagline = profile?.tagline || '';
  const name = profile?.name || 'Portfolio';

  useEffect(() => {
    if (!tagline) return;
    let i = 0;
    setTyped('');
    const timer = setInterval(() => {
      setTyped(tagline.slice(0, i));
      i++;
      if (i > tagline.length) clearInterval(timer);
    }, 40);
    return () => clearInterval(timer);
  }, [tagline]);

  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden" id="hero">
      <div className="absolute inset-0 pointer-events-none opacity-10" style={{ transform: `translate(${parallax.x * 0.5}px, ${parallax.y * 0.5}px)` }}>
        <svg className="w-full h-full" viewBox="0 0 800 800" xmlns="http://www.w3.org/2000/svg">
          <g stroke="#C9A94B" strokeWidth="1" fill="none">
            <line x1="400" y1="700" x2="400" y2="400"/>
            <line x1="400" y1="400" x2="250" y2="250"/><line x1="400" y1="400" x2="550" y2="250"/>
            <line x1="250" y1="250" x2="150" y2="100"/><line x1="250" y1="250" x2="320" y2="100"/>
            <line x1="550" y1="250" x2="480" y2="100"/><line x1="550" y1="250" x2="650" y2="100"/>
            <circle cx="400" cy="700" r="4" fill="#C9A94B"/><circle cx="400" cy="400" r="4" fill="#C9A94B"/>
            <circle cx="250" cy="250" r="4" fill="#C9A94B"/><circle cx="550" cy="250" r="4" fill="#C9A94B"/>
          </g>
        </svg>
      </div>
      <div className="relative z-10 text-center px-6 max-w-4xl">
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.8 }}>
          {name.split(' ').map((word, i) => (
            <motion.span key={i} initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.15, duration: 0.6 }}
              className="inline-block font-playfair text-5xl md:text-7xl font-bold text-white mr-4">
              {word}
            </motion.span>
          ))}
        </motion.div>
        <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.8 }}
          className="mt-6 text-gold text-lg md:text-xl min-h-[2rem]">
          {typed}<span className="animate-pulse">|</span>
        </motion.p>
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.2 }} className="mt-10 flex gap-4 justify-center flex-wrap">
          {profile?.resumeUrl && (
            <a href={profile.resumeUrl} target="_blank" rel="noreferrer"
              className="px-8 py-3 bg-gold text-navy font-semibold rounded-lg hover:bg-gold-light transition-colors">
              View Resume
            </a>
          )}
          <button onClick={() => document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth' })}
            className="px-8 py-3 border border-gold text-gold rounded-lg hover:bg-gold/10 transition-colors">
            Contact Me
          </button>
        </motion.div>
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 1.5 }}
          className="absolute bottom-8 left-1/2 -translate-x-1/2">
          <ChevronDown size={32} className="text-gold animate-bounce" />
        </motion.div>
      </div>
    </section>
  );
}
