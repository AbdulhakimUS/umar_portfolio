import { useQuery } from '@tanstack/react-query';
import { getProfile } from '../api/profile';
import { getActivities } from '../api/activities';
import { getQualifications } from '../api/qualifications';
import { getProjects } from '../api/projects';
import { getSkills } from '../api/skills';
import { getVision } from '../api/vision';
import { getResume } from '../api/resume';
import { getContact } from '../api/contact';
import { useEffect, useState, useRef } from 'react';

export const useProfile = () => useQuery({ queryKey: ['profile'], queryFn: getProfile });
export const useActivities = () => useQuery({ queryKey: ['activities'], queryFn: getActivities });
export const useQualifications = () => useQuery({ queryKey: ['qualifications'], queryFn: getQualifications });
export const useProjects = () => useQuery({ queryKey: ['projects'], queryFn: getProjects });
export const useSkills = () => useQuery({ queryKey: ['skills'], queryFn: getSkills });
export const useVision = () => useQuery({ queryKey: ['vision'], queryFn: getVision });
export const useResume = () => useQuery({ queryKey: ['resume'], queryFn: getResume });
export const useContact = () => useQuery({ queryKey: ['contact'], queryFn: getContact });

export const useMouseParallax = () => {
  const [pos, setPos] = useState({ x: 0, y: 0 });
  useEffect(() => {
    const handler = (e: MouseEvent) => setPos({ x: (e.clientX / window.innerWidth - 0.5) * 20, y: (e.clientY / window.innerHeight - 0.5) * 20 });
    window.addEventListener('mousemove', handler);
    return () => window.removeEventListener('mousemove', handler);
  }, []);
  return pos;
};

export const useScrollReveal = () => {
  const ref = useRef<HTMLDivElement>(null);
  const [isVisible, setIsVisible] = useState(false);
  useEffect(() => {
    const observer = new IntersectionObserver(([e]) => { if (e.isIntersecting) setIsVisible(true); }, { threshold: 0.1 });
    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, []);
  return { ref, isVisible };
};

export const useReducedMotion = () => {
  const [reduced, setReduced] = useState(false);
  useEffect(() => {
    const mq = window.matchMedia('(prefers-reduced-motion: reduce)');
    setReduced(mq.matches);
    mq.addEventListener('change', (e) => setReduced(e.matches));
  }, []);
  return reduced;
};
