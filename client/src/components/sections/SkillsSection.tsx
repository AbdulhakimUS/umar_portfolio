import ScrollReveal from '../ui/ScrollReveal';
import { HardSkill, SoftSkill } from '../../types';

export default function SkillsSection({ hard, soft }: { hard?: HardSkill[]; soft?: SoftSkill[] }) {
  const grouped = hard?.reduce((acc, s) => { (acc[s.category] = acc[s.category] || []).push(s); return acc; }, {} as Record<string, HardSkill[]>) || {};

  return (
    <section id="skills" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-16 text-center">Superpowers</h2></ScrollReveal>
      <div className="grid md:grid-cols-2 gap-16">
        <div>
          <ScrollReveal><h3 className="text-xl font-semibold text-white mb-8">Hard Skills</h3></ScrollReveal>
          {Object.entries(grouped).map(([cat, skills]) => (
            <div key={cat} className="mb-8">
              <p className="text-gold text-sm mb-4 uppercase tracking-wider">{cat}</p>
              {skills.map((s, i) => (
                <ScrollReveal key={s.id} delay={i*0.05}>
                  <div className="mb-4">
                    <div className="flex justify-between mb-1">
                      <span className="text-gray-300 text-sm">{s.name}</span>
                      <span className="text-gold text-sm">{s.level}/5</span>
                    </div>
                    <div className="h-2 bg-navy-light rounded-full overflow-hidden">
                      <div className="h-full bg-gradient-to-r from-gold to-gold-light rounded-full transition-all duration-1000" style={{ width: `${(s.level/5)*100}%` }} />
                    </div>
                  </div>
                </ScrollReveal>
              ))}
            </div>
          ))}
        </div>
        <div>
          <ScrollReveal><h3 className="text-xl font-semibold text-white mb-8">Soft Skills</h3></ScrollReveal>
          <div className="grid grid-cols-2 gap-4">
            {soft?.map((s, i) => (
              <ScrollReveal key={s.id} delay={i*0.1}>
                <div className="bg-navy-light rounded-xl border border-white/5 p-4 hover:border-gold/40 transition-all group">
                  <p className="font-semibold text-white mb-1">{s.name}</p>
                  <p className="text-gray-500 text-xs">{s.description}</p>
                </div>
              </ScrollReveal>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
