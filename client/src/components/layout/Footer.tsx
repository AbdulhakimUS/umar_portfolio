import { useProfile } from '../../hooks';
export default function Footer() {
  const { data: profile } = useProfile();
  return (
    <footer className="py-8 text-center text-gray-600 text-sm border-t border-white/5">
      © {new Date().getFullYear()} {profile?.name || 'Portfolio'}. All rights reserved.
    </footer>
  );
}
