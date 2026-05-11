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
  const { data: profile } = useProfile();
  const { data: activities } = useActivities();
  const { data: quals } = useQualifications();
  const { data: projects } = useProjects();
  const { data: skills } = useSkills();
  const { data: vision } = useVision();
  const { data: resume } = useResume();
  const { data: contacts } = useContact();

  return (
    <Layout>
      <HeroSection profile={profile} />
      <AboutSection profile={profile} />
      <ECSection activities={activities} />
      <QualificationsSection school={quals?.school} exams={quals?.exams} certifications={quals?.certifications} />
      <ProjectsSection projects={projects} />
      <SkillsSection hard={skills?.hard} soft={skills?.soft} />
      <VisionSection vision={vision} />
      <ResumeSection resumeUrl={resume?.resumeUrl} />
      <ContactSection contacts={contacts} />
    </Layout>
  );
}
