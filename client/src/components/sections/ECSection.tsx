import { useState } from 'react';
import ScrollReveal from '../ui/ScrollReveal';
import { ECActivity } from '../../types';

const CATEGORIES = ['All', 'Leadership', 'Academic', 'Community', 'Arts', 'Athletics'];

export default function ECSection({ activities }: { activities?: ECActivity[] }) {
  const [cat, setCat] = useState('All');
  const list = Array.isArray(activities) ? activities : [];
  const filtered = list.filter(a => cat === 'All' || a.category === cat);

  return (
    <section id="experience" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-8 text-center">ECs & Leadership</h2></ScrollReveal>
      <ScrollReveal delay={0.1}>
        <div className="flex flex-wrap gap-3 justify-center mb-12">
          {CATEGORIES.map(c => (
            <button key={c} onClick={() => setCat(c)}
              className={`px-4 py-2 rounded-full text-sm transition-all ${cat === c ? 'bg-gold text-navy font-semibold' : 'border border-gold/30 text-gray-400 hover:border-gold hover:text-gold'}`}>
              {c}
            </button>
          ))}
        </div>
      </ScrollReveal>
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filtered.map((a, i) => (
          <ScrollReveal key={a.id} delay={i * 0.1}>
            <div className="bg-navy-light rounded-xl border border-white/5 p-6 hover:border-gold/40 hover:-translate-y-1 transition-all duration-300">
              <span className="px-2 py-1 rounded text-xs bg-gold/20 text-gold border border-gold/20">{a.category}</span>
              <h3 className="font-playfair text-xl font-bold text-white mt-3 mb-1">{a.title}</h3>
              <p className="text-gold text-sm mb-1">{a.role}</p>
              <p className="text-gray-500 text-xs mb-3">{a.dateRange}</p>
              <p className="text-gray-400 text-sm">{a.description}</p>
            </div>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}
