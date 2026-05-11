import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getContact, createContact, deleteContact } from '../../api/contact';
import { ContactLink } from '../../types';
import { Trash2, Plus } from 'lucide-react';

const empty = { platform: '', icon: 'email', handle: '', url: '' };

export default function AdminContact() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['contact'], queryFn: getContact });
  const [form, setForm] = useState<Partial<ContactLink>>(empty);

  const add = useMutation({ mutationFn: () => createContact(form), onSuccess: () => { qc.invalidateQueries({ queryKey: ['contact'] }); toast.success('Added!'); setForm(empty); } });
  const del = useMutation({ mutationFn: deleteContact, onSuccess: () => { qc.invalidateQueries({ queryKey: ['contact'] }); toast.success('Deleted'); } });

  return (
    <div>
      <h2 className="font-playfair text-2xl font-bold text-white mb-8">Contact Links</h2>
      <div className="grid grid-cols-2 gap-3 mb-3">
        {(['platform','icon','handle','url'] as const).map(f => (
          <input key={f} value={form[f]||''} onChange={e=>setForm(p=>({...p,[f]:e.target.value}))} placeholder={f}
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
        ))}
      </div>
      <button onClick={() => add.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-6"><Plus size={14}/>Add Link</button>
      <div className="flex flex-col gap-3">
        {data?.map(c => (
          <div key={c.id} className="flex items-center justify-between bg-navy-light rounded-xl border border-white/5 px-6 py-4">
            <div><p className="text-white font-medium">{c.platform}</p><p className="text-gray-500 text-sm">{c.handle}</p></div>
            <button onClick={() => del.mutate(c.id)} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </div>
    </div>
  );
}
