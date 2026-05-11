import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getSkills, createHardSkill, deleteHardSkill, createSoftSkill, deleteSoftSkill } from '../../api/skills';
import { Trash2, Plus } from 'lucide-react';

export default function AdminSkills() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['skills'], queryFn: getSkills });
  const [hard, setHard] = useState({ name: '', category: '', level: 3 });
  const [soft, setSoft] = useState({ name: '', icon: 'Star', description: '' });

  const addHard = useMutation({ mutationFn: () => createHardSkill(hard), onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Added!'); } });
  const delHard = useMutation({ mutationFn: deleteHardSkill, onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Deleted'); } });
  const addSoft = useMutation({ mutationFn: () => createSoftSkill(soft), onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Added!'); } });
  const delSoft = useMutation({ mutationFn: deleteSoftSkill, onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Deleted'); } });

  return (
    <div className="flex flex-col gap-10">
      <h2 className="font-playfair text-2xl font-bold text-white">Skills</h2>
      <section>
        <h3 className="text-white font-semibold mb-4">Hard Skills</h3>
        <div className="grid grid-cols-3 gap-3 mb-3">
          <input value={hard.name} onChange={e=>setHard(p=>({...p,name:e.target.value}))} placeholder="Skill name"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <input value={hard.category} onChange={e=>setHard(p=>({...p,category:e.target.value}))} placeholder="Category"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <div className="flex items-center gap-3 bg-navy border border-white/10 rounded-lg px-4 py-3">
            <span className="text-gray-400 text-sm">Level:</span>
            <input type="range" min={1} max={5} value={hard.level} onChange={e=>setHard(p=>({...p,level:+e.target.value}))} className="flex-1 accent-gold"/>
            <span className="text-gold font-bold">{hard.level}</span>
          </div>
        </div>
        <button onClick={() => addHard.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.hard?.map((s: { id: string; name: string; category: string; level: number }) => (
          <div key={s.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{s.name} <span className="text-gray-500">({s.category})</span></span>
            <div className="flex items-center gap-4"><span className="text-gold">{s.level}/5</span>
              <button onClick={() => delHard.mutate(s.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button></div>
          </div>
        ))}
      </section>
      <section>
        <h3 className="text-white font-semibold mb-4">Soft Skills</h3>
        <div className="grid grid-cols-3 gap-3 mb-3">
          <input value={soft.name} onChange={e=>setSoft(p=>({...p,name:e.target.value}))} placeholder="Skill name"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <input value={soft.icon} onChange={e=>setSoft(p=>({...p,icon:e.target.value}))} placeholder="Icon name"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <input value={soft.description} onChange={e=>setSoft(p=>({...p,description:e.target.value}))} placeholder="Description"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
        </div>
        <button onClick={() => addSoft.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.soft?.map((s: { id: string; name: string; description: string }) => (
          <div key={s.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{s.name} <span className="text-gray-500">— {s.description}</span></span>
            <button onClick={() => delSoft.mutate(s.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </section>
    </div>
  );
}
