import ScrollReveal from '../ui/ScrollReveal';
import { Project } from '../../types';
import { Github, ExternalLink } from 'lucide-react';

export default function ProjectsSection({ projects }: { projects?: Project[] }) {
  return (
    <section id="projects" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-16 text-center">Projects</h2></ScrollReveal>
      <div className="flex flex-col gap-16">
        {projects?.map((p, i) => (
          <ScrollReveal key={p.id} delay={0.1}>
            <div className={`grid md:grid-cols-2 gap-8 items-center ${i%2===1 ? 'md:[direction:rtl]' : ''}`}>
              <div className={i%2===1 ? '[direction:ltr]' : ''}>
                <div className="aspect-video rounded-xl bg-navy-light border border-white/5 overflow-hidden group hover:border-gold/40 transition-all hover:scale-[1.01]">
                  {p.imageUrl ? <img src={p.imageUrl} alt={p.title} className="w-full h-full object-cover" /> :
                    <div className="w-full h-full flex items-center justify-center text-gray-600 font-playfair text-2xl">{p.title[0]}</div>}
                </div>
              </div>
              <div className={i%2===1 ? '[direction:ltr]' : ''}>
                <h3 className="font-playfair text-2xl font-bold text-white mb-3">{p.title}</h3>
                <p className="text-gray-400 mb-4">{p.description}</p>
                {p.impact && <p className="text-gold text-sm mb-4 font-medium">📊 {p.impact}</p>}
                <div className="flex flex-wrap gap-2 mb-6">
                  {Array.isArray(p.tags) ? p.tags.map : [].map(t => <span key={t} className="px-3 py-1 bg-gold/10 text-gold text-xs rounded-full border border-gold/20">{t}</span>)}
                </div>
                <div className="flex gap-4">
                  {p.githubUrl && <a href={p.githubUrl} target="_blank" rel="noreferrer" className="flex items-center gap-2 text-gray-400 hover:text-white transition-colors"><Github size={18}/>GitHub</a>}
                  {p.liveUrl && <a href={p.liveUrl} target="_blank" rel="noreferrer" className="flex items-center gap-2 text-gold hover:text-gold-light transition-colors"><ExternalLink size={18}/>Live</a>}
                </div>
              </div>
            </div>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}
