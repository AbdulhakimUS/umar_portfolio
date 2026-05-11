import ScrollReveal from '../ui/ScrollReveal';
import { Vision } from '../../types';

export default function VisionSection({ vision }: { vision?: Vision }) {
  if (!vision) return null;
  const parts = vision.text.split(new RegExp(`(${vision.anchorWord})`, 'gi'));
  return (
    <section id="vision" className="py-24 px-6">
      <div className="section-divider mb-24" />
      <div className="max-w-4xl mx-auto text-center">
        <ScrollReveal>
          <div className="text-6xl text-gold/30 font-playfair leading-none mb-6">"</div>
          <p className="font-playfair text-2xl md:text-3xl text-gray-200 leading-relaxed">
            {parts.map((p, i) =>
              p.toLowerCase() === vision.anchorWord.toLowerCase()
                ? <span key={i} className="text-gold animate-pulse">{p}</span>
                : p
            )}
          </p>
          <div className="text-6xl text-gold/30 font-playfair leading-none mt-6 rotate-180 inline-block">"</div>
        </ScrollReveal>
      </div>
    </section>
  );
}
