import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getResume, deleteResume } from '../../api/resume';
import { FileText, Trash2 } from 'lucide-react';

export default function AdminResume() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['resume'], queryFn: getResume });
  const del = useMutation({ mutationFn: deleteResume, onSuccess: () => { qc.invalidateQueries({ queryKey: ['resume'] }); toast.success('Deleted'); } });

  return (
    <div className="max-w-xl">
      <h2 className="font-playfair text-2xl font-bold text-white mb-8">Resume</h2>
      {data?.resumeUrl ? (
        <div className="bg-navy-light rounded-xl border border-white/10 p-6 flex items-center justify-between">
          <div className="flex items-center gap-3"><FileText className="text-gold" size={24}/>
            <a href={data.resumeUrl} target="_blank" rel="noreferrer" className="text-white hover:text-gold transition-colors">View Current Resume</a>
          </div>
          <button onClick={() => del.mutate()} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={18}/></button>
        </div>
      ) : (
        <div className="bg-navy-light rounded-xl border border-white/10 p-8 text-center">
          <FileText className="text-gray-600 mx-auto mb-3" size={40}/>
          <p className="text-gray-500 mb-4">No resume uploaded yet.</p>
          <p className="text-gray-600 text-sm">Upload via the API or contact your developer to enable file uploads.</p>
        </div>
      )}
    </div>
  );
}
