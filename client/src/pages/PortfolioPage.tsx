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
  const { data: activitiesRaw } = useActivities();
  const { data: quals } = useQualifications();
  const { data: projectsRaw } = useProjects();
  const { data: skillsRaw } = useSkills();
  const { data: vision } = useVision();
  const { data: resume } = useResume();
  const { data: contactsRaw } = useContact();

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
