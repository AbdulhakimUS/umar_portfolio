import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  await prisma.profile.deleteMany();
  await prisma.eCActivity.deleteMany();
  await prisma.school.deleteMany();
  await prisma.exam.deleteMany();
  await prisma.certification.deleteMany();
  await prisma.project.deleteMany();
  await prisma.hardSkill.deleteMany();
  await prisma.softSkill.deleteMany();
  await prisma.vision.deleteMany();
  await prisma.contactLink.deleteMany();
  await prisma.adminUser.deleteMany();

  await prisma.profile.create({
    data: {
      name: 'Umar Toshmatov',
      tagline: 'Aspiring Commercial Lawyer | Nature Advocate',
      about: 'A passionate and driven individual with a strong interest in commercial law and environmental advocacy. Dedicated to making a meaningful impact through legal expertise and community leadership.',
      openToWork: true,
    },
  });

  await prisma.eCActivity.createMany({
    data: [
      { title: 'Model UN', role: 'Secretary General', dateRange: '2022 - Present', description: 'Led committee sessions and managed international delegations.', category: 'Leadership', order: 0 },
      { title: 'Chess Club', role: 'Team Captain', dateRange: '2021 - Present', description: 'Organized tournaments and coached junior members.', category: 'Academic', order: 1 },
      { title: 'Environmental Society', role: 'Founder', dateRange: '2023 - Present', description: 'Founded and grew a 50-member environmental awareness club.', category: 'Community', order: 2 },
    ],
  });

  await prisma.school.create({
    data: { name: 'Westminster International University', grade: 'A', graduationYear: '2026' },
  });

  await prisma.exam.createMany({
    data: [
      { name: 'IELTS', score: '8.0', date: '2023-06-01', status: 'Completed' },
      { name: 'SAT', score: '1480', date: '2023-03-01', status: 'Completed' },
      { name: 'LSAT', score: 'TBD', date: '2025-06-01', status: 'Upcoming' },
    ],
  });

  await prisma.certification.createMany({
    data: [
      { name: 'Contract Law Fundamentals', issuer: 'Coursera', date: '2024-01-01', description: 'Comprehensive course on contract law principles.' },
      { name: 'Legal English', issuer: 'Cambridge', date: '2023-09-01', description: 'Advanced legal English for professionals.' },
      { name: 'Negotiation Skills', issuer: 'Harvard Online', date: '2024-03-01', description: 'Strategic negotiation techniques and frameworks.' },
    ],
  });

  await prisma.project.createMany({
    data: [
      { title: 'Legal Research Platform', description: 'A web platform that streamlines legal research and case management.', impact: 'Reduced research time by 40%', tags: ['React', 'Node.js', 'PostgreSQL'], githubUrl: 'https://github.com', order: 0 },
      { title: 'Nature Conservation App', description: 'Mobile app connecting volunteers with conservation projects.', impact: '500+ volunteers onboarded', tags: ['React Native', 'Firebase'], githubUrl: 'https://github.com', order: 1 },
    ],
  });

  await prisma.hardSkill.createMany({
    data: [
      { name: 'Legal Research', category: 'Law', level: 5 },
      { name: 'Contract Drafting', category: 'Law', level: 4 },
      { name: 'English', category: 'Language', level: 5 },
      { name: 'Microsoft Word', category: 'Tools', level: 4 },
      { name: 'Data Analysis', category: 'Analytics', level: 3 },
    ],
  });

  await prisma.softSkill.createMany({
    data: [
      { name: 'Leadership', icon: 'Trophy', description: 'Proven ability to lead teams and inspire others.' },
      { name: 'Communication', icon: 'MessageSquare', description: 'Excellent verbal and written communication skills.' },
      { name: 'Problem Solving', icon: 'Lightbulb', description: 'Creative approach to complex challenges.' },
      { name: 'Critical Thinking', icon: 'Brain', description: 'Analytical mindset with attention to detail.' },
    ],
  });

  await prisma.vision.create({
    data: { text: 'I aspire to become a leading commercial lawyer who bridges the gap between business innovation and legal integrity. My vision is rooted in justice — building a future where legal systems empower communities and protect the environment.', anchorWord: 'justice' },
  });

  await prisma.contactLink.createMany({
    data: [
      { platform: 'Telegram', icon: 'telegram', handle: '@umartoshmatov', url: 'https://t.me/umartoshmatov', order: 0 },
      { platform: 'Instagram', icon: 'instagram', handle: '@umar.toshmatov', url: 'https://instagram.com/umar.toshmatov', order: 1 },
      { platform: 'Email', icon: 'email', handle: 'umar@example.com', url: 'mailto:umar@example.com', order: 2 },
    ],
  });

  const passwordHash = await bcrypt.hash('portfolio2024', 12);
  await prisma.adminUser.create({
    data: { username: 'admin', passwordHash },
  });

  console.log('✅ Seed data inserted!');
}

main().catch(console.error).finally(() => prisma.$disconnect());
