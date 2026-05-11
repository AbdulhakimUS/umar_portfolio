import { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getVision, updateVision } from '../../api/vision';
import { Vision } from '../../types';

export default function AdminVision() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['vision'], queryFn: getVision });
  const { register, handleSubmit, reset } = useForm<Partial<Vision>>();
  const mutation = useMutation({ mutationFn: updateVision, onSuccess: () => { qc.invalidateQueries({ queryKey: ['vision'] }); toast.success('Saved!'); } });
  useEffect(() => { if (data) reset(data); }, [data, reset]);
  return (
    <div className="max-w-xl">
      <h2 className="font-playfair text-2xl font-bold text-white mb-8">Vision</h2>
      <form onSubmit={handleSubmit(d => mutation.mutate(d))} className="flex flex-col gap-4">
        <textarea {...register('text')} rows={5} placeholder="Your vision statement..."
          className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none resize-none"/>
        <input {...register('anchorWord')} placeholder="Anchor word (highlighted in gold)"
          className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none"/>
        <button type="submit" disabled={mutation.isPending} className="px-6 py-3 bg-gold text-navy font-semibold rounded-lg hover:bg-gold-light transition-colors disabled:opacity-50">
          {mutation.isPending ? 'Saving...' : 'Save Vision'}
        </button>
      </form>
    </div>
  );
}
