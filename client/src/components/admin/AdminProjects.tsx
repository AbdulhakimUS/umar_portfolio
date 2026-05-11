import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getProjects, createProject, updateProject, deleteProject } from '../../api/projects';
import { Project } from '../../types';
import { Pencil, Trash2, Plus, X } from 'lucide-react';

const empty: Partial<Project> = { title: '', description: '', impact: '', tags: [], githubUrl: '', liveUrl: '' };

export default function AdminProjects() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['projects'], queryFn: getProjects });
  const [form, setForm] = useState<Partial<Project>>(empty);
  const [editing, setEditing] = useState<string|null>(null);
  const [showForm, setShowForm] = useState(false);
  const [tagsInput, setTagsInput] = useState('');

  const save = useMutation({
    mutationFn: () => editing ? updateProject(editing, { ...form, tags: tagsInput.split(',').map(t=>t.trim()).filter(Boolean) })
      : createProject({ ...form, tags: tagsInput.split(',').map(t=>t.trim()).filter(Boolean) }),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['projects'] }); toast.success('Saved!'); setShowForm(false); setForm(empty); setEditing(null); }
  });
  const del = useMutation({ mutationFn: deleteProject, onSuccess: () => { qc.invalidateQueries({ queryKey: ['projects'] }); toast.success('Deleted'); } });

  const edit = (p: Project) => { setForm(p); setEditing(p.id); setTagsInput(p.tags.join(', ')); setShowForm(true); };

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h2 className="font-playfair text-2xl font-bold text-white">Projects</h2>
        <button onClick={() => { setForm(empty); setEditing(null); setTagsInput(''); setShowForm(true); }}
          className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold"><Plus size={16}/>Add</button>
      </div>
      {showForm && (
        <div className="bg-navy-light rounded-xl border border-white/10 p-6 mb-6">
          <div className="flex justify-between mb-4"><h3 className="text-white font-semibold">{editing?'Edit':'New'} Project</h3>
            <button onClick={() => setShowForm(false)}><X size={20} className="text-gray-400"/></button></div>
          <div className="grid grid-cols-2 gap-4">
            {(['title','impact','githubUrl','liveUrl'] as const).map(f => (
              <input key={f} value={form[f] as string || ''} onChange={e => setForm(p=>({...p,[f]:e.target.value}))} placeholder={f}
                className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none" />
            ))}
            <textarea value={form.description||''} onChange={e=>setForm(p=>({...p,description:e.target.value}))} placeholder="Description" rows={3}
              className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none resize-none"/>
            <input value={tagsInput} onChange={e=>setTagsInput(e.target.value)} placeholder="Tags (comma separated)"
              className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none"/>
          </div>
          <button onClick={() => save.mutate()} disabled={save.isPending}
            className="mt-4 px-6 py-2 bg-gold text-navy rounded-lg font-semibold text-sm">{save.isPending?'Saving...':'Save'}</button>
        </div>
      )}
      <div className="flex flex-col gap-3">
        {data?.map(p => (
          <div key={p.id} className="flex items-center justify-between bg-navy-light rounded-xl border border-white/5 px-6 py-4">
            <div><p className="text-white font-medium">{p.title}</p><p className="text-gray-500 text-sm">{p.tags.join(', ')}</p></div>
            <div className="flex gap-2">
              <button onClick={() => edit(p)} className="p-2 text-gray-400 hover:text-gold"><Pencil size={16}/></button>
              <button onClick={() => del.mutate(p.id)} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
