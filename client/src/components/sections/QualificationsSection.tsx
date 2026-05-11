import { useState } from 'react';
import ScrollReveal from '../ui/ScrollReveal';
import { School, Exam, Certification } from '../../types';
import { ExternalLink } from 'lucide-react';

type Props = { school?: School; exams?: Exam[]; certifications?: Certification[] };

export default function QualificationsSection({ school, exams, certifications }: Props) {
  const [tab, setTab] = useState<'school'|'exams'|'certifications'>('school');
  const tabs = ['school','exams','certifications'] as const;

  return (
    <section id="qualifications" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-8 text-center">Qualifications</h2></ScrollReveal>
      <div className="flex gap-4 justify-center mb-12">
        {tabs.map(t => (
          <button key={t} onClick={() => setTab(t)}
            className={`px-6 py-2 rounded-full capitalize text-sm transition-all ${tab===t ? 'bg-gold text-navy font-semibold' : 'border border-gold/30 text-gray-400 hover:text-gold hover:border-gold'}`}>
            {t}
          </button>
        ))}
      </div>
      {tab==='school' && school && (
        <ScrollReveal>
          <div className="max-w-md mx-auto bg-navy-light rounded-xl border border-gold/20 p-8 text-center">
            <h3 className="font-playfair text-2xl font-bold text-white mb-2">{school.name}</h3>
            <p className="text-gold">Grade: {school.grade}</p>
            <p className="text-gray-400">Graduating: {school.graduationYear}</p>
          </div>
        </ScrollReveal>
      )}
      {tab==='exams' && (
        <ScrollReveal>
          <div className="overflow-x-auto rounded-xl border border-white/5">
            <table className="w-full">
              <thead className="bg-navy-light"><tr>
                {['Exam','Score','Date','Status'].map(h=><th key={h} className="text-left px-6 py-4 text-gray-400 text-sm font-medium">{h}</th>)}
              </tr></thead>
              <tbody>{exams?.map(e=>(
                <tr key={e.id} className="border-t border-white/5 hover:bg-navy-light transition-colors">
                  <td className="px-6 py-4 text-white font-medium">{e.name}</td>
                  <td className="px-6 py-4 text-gold font-bold">{e.score}</td>
                  <td className="px-6 py-4 text-gray-400">{e.date}</td>
                  <td className="px-6 py-4">
                    <span className={`px-3 py-1 rounded-full text-xs ${e.status==='Completed' ? 'bg-green-500/20 text-green-400' : 'bg-yellow-500/20 text-yellow-400'}`}>{e.status}</span>
                  </td>
                </tr>
              ))}</tbody>
            </table>
          </div>
        </ScrollReveal>
      )}
      {tab==='certifications' && (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {certifications?.map((c,i)=>(
            <ScrollReveal key={c.id} delay={i*0.1}>
              <div className="bg-navy-light rounded-xl border border-white/5 p-6 hover:border-gold/40 transition-all">
                <h3 className="font-semibold text-white mb-1">{c.name}</h3>
                <p className="text-gold text-sm">{c.issuer}</p>
                <p className="text-gray-500 text-xs mb-3">{c.date}</p>
                <p className="text-gray-400 text-sm mb-4">{c.description}</p>
                {c.link && <a href={c.link} target="_blank" rel="noreferrer" className="flex items-center gap-1 text-gold text-sm hover:underline"><ExternalLink size={14}/>View</a>}
              </div>
            </ScrollReveal>
          ))}
        </div>
      )}
    </section>
  );
}
