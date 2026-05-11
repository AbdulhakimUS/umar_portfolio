import ScrollReveal from '../ui/ScrollReveal';
import { ContactLink } from '../../types';

const ICONS: Record<string, string> = {
  telegram: '✈️', instagram: '📸', email: '✉️', linkedin: '💼', whatsapp: '📱',
};

export default function ContactSection({ contacts }: { contacts?: ContactLink[] }) {
  return (
    <section id="contact" className="py-24 px-6 max-w-4xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-12 text-center">Get In Touch</h2></ScrollReveal>
      <div className="grid grid-cols-2 md:grid-cols-3 gap-6">
        {contacts?.map((c, i) => (
          <ScrollReveal key={c.id} delay={i*0.1}>
            <a href={c.url} target="_blank" rel="noreferrer"
              className="flex flex-col items-center gap-3 p-6 bg-navy-light rounded-xl border border-white/5 hover:border-gold hover:-translate-y-1 transition-all duration-300 group">
              <span className="text-3xl">{ICONS[c.icon] || '🔗'}</span>
              <span className="font-medium text-white">{c.platform}</span>
              <span className="text-gray-500 text-sm text-center">{c.handle}</span>
            </a>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}
