import { useState, useEffect } from 'react';
import Layout from '../components/layout/Layout';
import HeroSection from '../components/sections/HeroSection';
import AboutSection from '../components/sections/AboutSection';
import ECSection from '../components/sections/ECSection';
import QualificationsSection from '../components/sections/QualificationsSection';
import ProjectsSection from '../components/sections/ProjectsSection';
import SkillsSection from '../components/sections/SkillsSection';
import VisionSection from '../components/sections/VisionSection';
import ResumeSection from '../components/sections/ResumeSection';
import ContactSection from '../components/sections/ContactSection';
import { useProfile, useActivities, useQualifications, useProjects, useSkills, useVision, useResume, useContact } from '../hooks';

export default function PortfolioPage() {
  const { data: profile, isLoading: p1 } = useProfile();
  const { data: activitiesRaw, isLoading: p2 } = useActivities();
  const { data: quals, isLoading: p3 } = useQualifications();
  const { data: projectsRaw, isLoading: p4 } = useProjects();
  const { data: skillsRaw, isLoading: p5 } = useSkills();
  const { data: vision, isLoading: p6 } = useVision();
  const { data: resume } = useResume();
  const { data: contactsRaw, isLoading: p7 } = useContact();

  const [dots, setDots] = useState('');
  const isLoading = p1 || p2 || p3 || p4 || p5 || p6 || p7;

  useEffect(() => {
    const t = setInterval(() => setDots(d => d.length >= 3 ? '' : d + '.'), 500);
    return () => clearInterval(t);
  }, []);

  if (isLoading) {
    return (
      <div className="min-h-screen bg-navy flex flex-col items-center justify-center">
        <div className="w-16 h-16 border-2 border-gold border-t-transparent rounded-full animate-spin mb-6" />
        <p className="text-gold font-playfair text-xl">Loading{dots}</p>
        <p className="text-gray-600 text-sm mt-2">Server may take up to 50 seconds to wake up</p>
      </div>
    );
  }

  const activities = Array.isArray(activitiesRaw) ? activitiesRaw : [];
  const projects = Array.isArray(projectsRaw) ? projectsRaw : [];
  const contacts = Array.isArray(contactsRaw) ? contactsRaw : [];
  const hardSkills = Array.isArray(skillsRaw?.hard) ? skillsRaw.hard : [];
  const softSkills = Array.isArray(skillsRaw?.soft) ? skillsRaw.soft : [];

  return (
    <Layout>
      <HeroSection profile={profile} />
      <AboutSection profile={profile} />
      <ECSection activities={activities} />
      <QualificationsSection
        school={quals?.school}
        exams={Array.isArray(quals?.exams) ? quals.exams : []}
        certifications={Array.isArray(quals?.certifications) ? quals.certifications : []}
      />
      <ProjectsSection projects={projects} />
      <SkillsSection hard={hardSkills} soft={softSkills} />
      <VisionSection vision={vision} />
      <ResumeSection resumeUrl={resume?.resumeUrl} />
      <ContactSection contacts={contacts} />
    </Layout>
  );
}
