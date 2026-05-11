import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getActivities, createActivity, updateActivity, deleteActivity } from '../../api/activities';
import { ECActivity } from '../../types';
import { Pencil, Trash2, Plus, X } from 'lucide-react';

const empty = { title: '', role: '', dateRange: '', description: '', category: 'Leadership' };

export default function AdminECs() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['activities'], queryFn: getActivities });
  const [form, setForm] = useState<Partial<ECActivity>>(empty);
  const [editing, setEditing] = useState<string|null>(null);
  const [showForm, setShowForm] = useState(false);

  const save = useMutation({
    mutationFn: () => editing ? updateActivity(editing, form) : createActivity(form),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['activities'] }); toast.success('Saved!'); setShowForm(false); setForm(empty); setEditing(null); }
  });
  const del = useMutation({
    mutationFn: deleteActivity,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['activities'] }); toast.success('Deleted'); }
  });

  const edit = (a: ECActivity) => { setForm(a); setEditing(a.id); setShowForm(true); };

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h2 className="font-playfair text-2xl font-bold text-white">ECs & Leadership</h2>
        <button onClick={() => { setForm(empty); setEditing(null); setShowForm(true); }}
          className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold"><Plus size={16}/>Add New</button>
      </div>
      {showForm && (
        <div className="bg-navy-light rounded-xl border border-white/10 p-6 mb-6">
          <div className="flex justify-between mb-4"><h3 className="text-white font-semibold">{editing ? 'Edit' : 'New'} Activity</h3>
            <button onClick={() => setShowForm(false)}><X size={20} className="text-gray-400"/></button></div>
          <div className="grid grid-cols-2 gap-4">
            {(['title','role','dateRange','category'] as const).map(f => (
              <input key={f} value={form[f] || ''} onChange={e => setForm(p => ({...p,[f]:e.target.value}))} placeholder={f}
                className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none" />
            ))}
            <textarea value={form.description || ''} onChange={e => setForm(p => ({...p,description:e.target.value}))} placeholder="Description" rows={3}
              className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none resize-none" />
          </div>
          <button onClick={() => save.mutate()} disabled={save.isPending}
            className="mt-4 px-6 py-2 bg-gold text-navy rounded-lg font-semibold text-sm">{save.isPending ? 'Saving...' : 'Save'}</button>
        </div>
      )}
      <div className="flex flex-col gap-3">
        {data?.map(a => (
          <div key={a.id} className="flex items-center justify-between bg-navy-light rounded-xl border border-white/5 px-6 py-4">
            <div><p className="text-white font-medium">{a.title}</p><p className="text-gray-500 text-sm">{a.role} · {a.category}</p></div>
            <div className="flex gap-2">
              <button onClick={() => edit(a)} className="p-2 text-gray-400 hover:text-gold"><Pencil size={16}/></button>
              <button onClick={() => del.mutate(a.id)} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
