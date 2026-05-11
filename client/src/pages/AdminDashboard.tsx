import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import { logout } from '../api/auth';
import { useAuthStore } from '../store/authStore';
import { User, Trophy, GraduationCap, FolderKanban, Zap, Eye, FileText, Contact, LogOut } from 'lucide-react';
import AdminProfile from '../components/admin/AdminProfile';
import AdminECs from '../components/admin/AdminECs';
import AdminQualifications from '../components/admin/AdminQualifications';
import AdminProjects from '../components/admin/AdminProjects';
import AdminSkills from '../components/admin/AdminSkills';
import AdminVision from '../components/admin/AdminVision';
import AdminResume from '../components/admin/AdminResume';
import AdminContact from '../components/admin/AdminContact';

const TABS = [
  { id: 'profile', label: 'Profile', Icon: User, Component: AdminProfile },
  { id: 'ecs', label: 'ECs', Icon: Trophy, Component: AdminECs },
  { id: 'qualifications', label: 'Qualifications', Icon: GraduationCap, Component: AdminQualifications },
  { id: 'projects', label: 'Projects', Icon: FolderKanban, Component: AdminProjects },
  { id: 'skills', label: 'Skills', Icon: Zap, Component: AdminSkills },
  { id: 'vision', label: 'Vision', Icon: Eye, Component: AdminVision },
  { id: 'resume', label: 'Resume', Icon: FileText, Component: AdminResume },
  { id: 'contact', label: 'Contact', Icon: Contact, Component: AdminContact },
];

export default function AdminDashboard() {
  const [active, setActive] = useState('profile');
  const navigate = useNavigate();
  const clearAuth = useAuthStore(s => s.clearAuth);
  const ActiveComponent = TABS.find(t => t.id === active)?.Component || AdminProfile;

  const handleLogout = async () => {
    await logout();
    clearAuth();
    toast.success('Logged out');
    navigate('/admin/login');
  };

  return (
    <div className="min-h-screen bg-navy flex">
      <aside className="hidden md:flex w-56 bg-navy-light border-r border-white/5 flex-col py-8">
        <div className="px-6 mb-8"><span className="font-playfair text-gold font-bold text-lg">Admin</span></div>
        <nav className="flex-1 flex flex-col gap-1 px-3">
          {TABS.map(({ id, label, Icon }) => (
            <button key={id} onClick={() => setActive(id)}
              className={`flex items-center gap-3 px-4 py-3 rounded-lg text-sm transition-all ${active===id ? 'bg-gold/10 text-gold border-l-2 border-gold' : 'text-gray-400 hover:text-white hover:bg-white/5'}`}>
              <Icon size={18} />{label}
            </button>
          ))}
        </nav>
        <div className="px-3">
          <button onClick={handleLogout} className="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-400 hover:text-red-400 hover:bg-red-400/10 transition-all w-full text-sm">
            <LogOut size={18} />Logout
          </button>
        </div>
      </aside>
      <main className="flex-1 p-8 overflow-y-auto">
        <ActiveComponent />
      </main>
      <div className="fixed bottom-0 left-0 right-0 md:hidden bg-navy-light border-t border-white/5 flex">
        {TABS.map(({ id, label, Icon }) => (
          <button key={id} onClick={() => setActive(id)} className={`flex-1 py-3 flex flex-col items-center gap-1 text-xs transition-all ${active===id ? 'text-gold' : 'text-gray-600'}`}>
            <Icon size={18} /><span className="hidden sm:block">{label}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
