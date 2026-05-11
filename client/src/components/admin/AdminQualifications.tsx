import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getQualifications, updateSchool, createExam, deleteExam, createCertification, deleteCertification } from '../../api/qualifications';
import { Trash2, Plus } from 'lucide-react';

export default function AdminQualifications() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['qualifications'], queryFn: getQualifications });
  const [exam, setExam] = useState({ name: '', score: '', date: '', status: 'Completed' });
  const [cert, setCert] = useState({ name: '', issuer: '', date: '', description: '', link: '' });

  const saveSchool = useMutation({ mutationFn: updateSchool, onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('School saved!'); } });
  const addExam = useMutation({ mutationFn: () => createExam(exam), onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Exam added!'); } });
  const delExam = useMutation({ mutationFn: deleteExam, onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Deleted'); } });
  const addCert = useMutation({ mutationFn: () => createCertification(cert), onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Certification added!'); } });
  const delCert = useMutation({ mutationFn: deleteCertification, onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Deleted'); } });

  return (
    <div className="flex flex-col gap-10">
      <h2 className="font-playfair text-2xl font-bold text-white">Qualifications</h2>
      <section>
        <h3 className="text-white font-semibold mb-4">School</h3>
        <div className="grid grid-cols-3 gap-4 mb-4">
          {['name','grade','graduationYear'].map(f => (
            <input key={f} defaultValue={data?.school?.[f as keyof typeof data.school] || ''} placeholder={f}
              id={`school-${f}`} className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none" />
          ))}
        </div>
        <button onClick={() => saveSchool.mutate({ name: (document.getElementById('school-name') as HTMLInputElement)?.value, grade: (document.getElementById('school-grade') as HTMLInputElement)?.value, graduationYear: (document.getElementById('school-graduationYear') as HTMLInputElement)?.value })}
          className="px-6 py-2 bg-gold text-navy rounded-lg font-semibold text-sm">Save School</button>
      </section>
      <section>
        <h3 className="text-white font-semibold mb-4">Exams</h3>
        <div className="grid grid-cols-4 gap-3 mb-4">
          {(['name','score','date'] as const).map(f => (
            <input key={f} value={exam[f]} onChange={e => setExam(p => ({...p,[f]:e.target.value}))} placeholder={f}
              className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none" />
          ))}
          <select value={exam.status} onChange={e => setExam(p => ({...p,status:e.target.value}))}
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none">
            <option>Completed</option><option>Upcoming</option>
          </select>
        </div>
        <button onClick={() => addExam.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.exams?.map((e: { id: string; name: string; score: string; status: string }) => (
          <div key={e.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{e.name} — {e.score} <span className="text-gray-500">({e.status})</span></span>
            <button onClick={() => delExam.mutate(e.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </section>
      <section>
        <h3 className="text-white font-semibold mb-4">Certifications</h3>
        <div className="grid grid-cols-2 gap-3 mb-4">
          {(['name','issuer','date','link'] as const).map(f => (
            <input key={f} value={cert[f]} onChange={e => setCert(p => ({...p,[f]:e.target.value}))} placeholder={f}
              className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none" />
          ))}
          <textarea value={cert.description} onChange={e => setCert(p => ({...p,description:e.target.value}))} placeholder="Description" rows={2}
            className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none resize-none" />
        </div>
        <button onClick={() => addCert.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.certifications?.map((c: { id: string; name: string; issuer: string }) => (
          <div key={c.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{c.name} <span className="text-gray-500">— {c.issuer}</span></span>
            <button onClick={() => delCert.mutate(c.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </section>
    </div>
  );
}
