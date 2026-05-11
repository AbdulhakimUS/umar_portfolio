import ScrollReveal from '../ui/ScrollReveal';
import { Profile } from '../../types';

export default function AboutSection({ profile }: { profile?: Profile }) {
  return (
    <section id="about" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal>
        <h2 className="font-playfair text-4xl font-bold text-white mb-12 text-center">About Me</h2>
      </ScrollReveal>
      <div className="grid md:grid-cols-2 gap-12 items-center">
        <ScrollReveal delay={0.1}>
          <div className="aspect-square max-w-sm mx-auto rounded-2xl border-2 border-gold overflow-hidden bg-navy-light">
            {profile?.photoUrl ? (
              <img src={profile.photoUrl} alt={profile.name} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center">
                <span className="font-playfair text-6xl text-gold">{profile?.name?.[0] || 'U'}</span>
              </div>
            )}
          </div>
        </ScrollReveal>
        <ScrollReveal delay={0.2}>
          <p className="text-gray-300 text-lg leading-relaxed">{profile?.about}</p>
        </ScrollReveal>
      </div>
    </section>
  );
}
