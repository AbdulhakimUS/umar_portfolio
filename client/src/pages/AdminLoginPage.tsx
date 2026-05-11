import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import { login } from '../api/auth';
import { useAuthStore } from '../store/authStore';

const schema = z.object({ username: z.string().min(1), password: z.string().min(6) });
type Form = z.infer<typeof schema>;

export default function AdminLoginPage() {
  const navigate = useNavigate();
  const setAccessToken = useAuthStore(s => s.setAccessToken);
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<Form>({ resolver: zodResolver(schema) });

  const onSubmit = async (data: Form) => {
    try {
      const res = await login(data.username, data.password);
      setAccessToken(res.accessToken);
      navigate('/admin');
    } catch {
      toast.error('Invalid credentials');
    }
  };

  return (
    <div className="min-h-screen bg-navy flex items-center justify-center px-4">
      <div className="w-full max-w-sm bg-navy-light rounded-2xl border border-white/10 p-8">
        <h1 className="font-playfair text-2xl font-bold text-white text-center mb-8">Admin Panel</h1>
        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4">
          <div>
            <input {...register('username')} placeholder="Username" autoComplete="username"
              className="w-full bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none" />
            {errors.username && <p className="text-red-400 text-xs mt-1">{errors.username.message}</p>}
          </div>
          <div>
            <input {...register('password')} type="password" placeholder="Password" autoComplete="current-password"
              className="w-full bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none" />
            {errors.password && <p className="text-red-400 text-xs mt-1">{errors.password.message}</p>}
          </div>
          <button type="submit" disabled={isSubmitting}
            className="w-full py-3 bg-gold text-navy font-semibold rounded-lg hover:bg-gold-light transition-colors disabled:opacity-50">
            {isSubmitting ? 'Logging in...' : 'Login'}
          </button>
        </form>
        <p className="text-gray-600 text-xs text-center mt-6">Ctrl+Shift+A to access admin</p>
      </div>
    </div>
  );
}
