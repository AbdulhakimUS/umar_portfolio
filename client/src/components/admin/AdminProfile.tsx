import { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getProfile, updateProfile } from '../../api/profile';
import { Profile } from '../../types';

export default function AdminProfile() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['profile'], queryFn: getProfile });
  const { register, handleSubmit, reset } = useForm<Partial<Profile>>();
  const mutation = useMutation({ mutationFn: updateProfile, onSuccess: () => { qc.invalidateQueries({ queryKey: ['profile'] }); toast.success('Saved!'); } });

  useEffect(() => { if (data) reset(data); }, [data, reset]);

  return (
    <div className="max-w-xl">
      <h2 className="font-playfair text-2xl font-bold text-white mb-8">Profile</h2>
      <form onSubmit={handleSubmit(d => mutation.mutate(d))} className="flex flex-col gap-4">
        {(['name','tagline'] as const).map(f => (
          <input key={f} {...register(f)} placeholder={f.charAt(0).toUpperCase()+f.slice(1)}
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none" />
        ))}
        <textarea {...register('about')} rows={4} placeholder="About"
          className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none resize-none" />
        <label className="flex items-center gap-3 text-gray-300">
          <input type="checkbox" {...register('openToWork')} className="w-4 h-4 accent-gold" />
          Open to Work
        </label>
        <button type="submit" disabled={mutation.isPending}
          className="px-6 py-3 bg-gold text-navy font-semibold rounded-lg hover:bg-gold-light transition-colors disabled:opacity-50">
          {mutation.isPending ? 'Saving...' : 'Save Changes'}
        </button>
      </form>
    </div>
  );
}
