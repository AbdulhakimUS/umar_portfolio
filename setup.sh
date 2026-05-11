#!/bin/bash
set -e

echo "🚀 Portfolio loyiha yaratilmoqda..."

# ─── ROOT ───────────────────────────────────────────────
cat > .gitignore << 'EOF'
node_modules/
dist/
.env
.DS_Store
*.log
.env.local
EOF

cat > README.md << 'EOF'
# Umar Portfolio
Full-stack portfolio website built with React + Node.js + PostgreSQL.
EOF

# ─── SERVER ─────────────────────────────────────────────
mkdir -p server/src/{controllers,middleware,routes,services,utils}
mkdir -p server/prisma

cat > server/package.json << 'EOF'
{
  "name": "portfolio-server",
  "version": "1.0.0",
  "scripts": {
    "dev": "nodemon --exec ts-node src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "db:generate": "prisma generate",
    "db:migrate": "prisma migrate dev",
    "db:seed": "ts-node prisma/seed.ts"
  },
  "dependencies": {
    "@prisma/client": "^5.22.0",
    "bcryptjs": "^2.4.3",
    "cloudinary": "^2.5.1",
    "cors": "^2.8.5",
    "dotenv": "^16.4.5",
    "express": "^4.21.1",
    "express-rate-limit": "^7.4.1",
    "helmet": "^8.0.0",
    "hpp": "^0.2.3",
    "jsonwebtoken": "^9.0.2",
    "multer": "^1.4.5-lts.1",
    "multer-storage-cloudinary": "^4.0.0",
    "zod": "^3.23.8"
  },
  "devDependencies": {
    "@types/bcryptjs": "^2.4.6",
    "@types/cors": "^2.8.17",
    "@types/express": "^5.0.0",
    "@types/hpp": "^0.2.6",
    "@types/jsonwebtoken": "^9.0.7",
    "@types/multer": "^1.4.12",
    "@types/node": "^22.9.0",
    "nodemon": "^3.1.7",
    "prisma": "^5.22.0",
    "ts-node": "^10.9.2",
    "typescript": "^5.6.3"
  }
}
EOF

cat > server/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

cat > server/.env.example << 'EOF'
NODE_ENV=development
PORT=5000
DATABASE_URL=postgresql://user:password@localhost:5432/portfolio_db
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
JWT_ACCESS_SECRET=your_access_secret_here
JWT_REFRESH_SECRET=your_refresh_secret_here
CLIENT_URL=http://localhost:3000
EOF

cat > server/prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model Profile {
  id         String   @id @default(uuid())
  name       String
  tagline    String
  about      String
  photoUrl   String?
  openToWork Boolean  @default(true)
  resumeUrl  String?
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
}

model ECActivity {
  id          String   @id @default(uuid())
  imageUrl    String?
  title       String
  role        String
  dateRange   String
  description String
  category    String
  order       Int      @default(0)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model School {
  id             String   @id @default(uuid())
  name           String
  grade          String
  graduationYear String
  logoUrl        String?
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
}

model Exam {
  id        String   @id @default(uuid())
  name      String
  score     String
  date      String
  status    String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Certification {
  id          String   @id @default(uuid())
  imageUrl    String?
  name        String
  issuer      String
  date        String
  description String
  link        String?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model Project {
  id          String   @id @default(uuid())
  imageUrl    String?
  videoUrl    String?
  title       String
  description String
  impact      String?
  tags        String[]
  githubUrl   String?
  liveUrl     String?
  order       Int      @default(0)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model HardSkill {
  id        String   @id @default(uuid())
  name      String
  category  String
  level     Int
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model SoftSkill {
  id          String   @id @default(uuid())
  name        String
  icon        String
  description String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model Vision {
  id         String   @id @default(uuid())
  text       String
  anchorWord String
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
}

model ContactLink {
  id        String   @id @default(uuid())
  platform  String
  icon      String
  handle    String
  url       String
  order     Int      @default(0)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model AdminUser {
  id           String   @id @default(uuid())
  username     String   @unique
  passwordHash String
  refreshToken String?
  createdAt    DateTime @default(now())
  updatedAt    DateTime @updatedAt
}
EOF

cat > server/prisma/seed.ts << 'EOF'
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
EOF

cat > server/src/utils/prisma.ts << 'EOF'
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };
export const prisma = globalForPrisma.prisma || new PrismaClient();
if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;
EOF

cat > server/src/utils/jwt.ts << 'EOF'
import jwt from 'jsonwebtoken';

export const generateAccessToken = (userId: string) =>
  jwt.sign({ userId }, process.env.JWT_ACCESS_SECRET!, { expiresIn: '15m' });

export const generateRefreshToken = (userId: string) =>
  jwt.sign({ userId }, process.env.JWT_REFRESH_SECRET!, { expiresIn: '7d' });

export const verifyAccessToken = (token: string) =>
  jwt.verify(token, process.env.JWT_ACCESS_SECRET!);

export const verifyRefreshToken = (token: string) =>
  jwt.verify(token, process.env.JWT_REFRESH_SECRET!);
EOF

cat > server/src/utils/cloudinary.ts << 'EOF'
import { v2 as cloudinary } from 'cloudinary';
import dotenv from 'dotenv';
dotenv.config();

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

export default cloudinary;
EOF

cat > server/src/middleware/errorHandler.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';

export const errorHandler = (err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ message: process.env.NODE_ENV === 'production' ? 'Internal server error' : err.message });
};
EOF

cat > server/src/middleware/authenticateToken.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken } from '../utils/jwt';

export interface AuthRequest extends Request {
  user?: { userId: string };
}

export const authenticateToken = (req: AuthRequest, res: Response, next: NextFunction): void => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) { res.status(401).json({ message: 'No token' }); return; }
  try {
    const payload = verifyAccessToken(token) as { userId: string };
    req.user = payload;
    next();
  } catch {
    res.status(403).json({ message: 'Invalid token' });
  }
};
EOF

cat > server/src/middleware/rateLimiter.ts << 'EOF'
import rateLimit from 'express-rate-limit';
export const authLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 5, message: 'Too many requests' });
EOF

cat > server/src/controllers/authController.ts << 'EOF'
import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import { prisma } from '../utils/prisma';
import { generateAccessToken, generateRefreshToken, verifyRefreshToken } from '../utils/jwt';

export const login = async (req: Request, res: Response): Promise<void> => {
  const { username, password } = req.body;
  const user = await prisma.adminUser.findUnique({ where: { username } });
  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    res.status(401).json({ message: 'Invalid credentials' }); return;
  }
  const accessToken = generateAccessToken(user.id);
  const refreshToken = generateRefreshToken(user.id);
  await prisma.adminUser.update({ where: { id: user.id }, data: { refreshToken } });
  res.cookie('refreshToken', refreshToken, { httpOnly: true, sameSite: 'strict', maxAge: 7 * 24 * 60 * 60 * 1000 });
  res.json({ accessToken });
};

export const refresh = async (req: Request, res: Response): Promise<void> => {
  const token = req.cookies?.refreshToken;
  if (!token) { res.status(401).json({ message: 'No refresh token' }); return; }
  try {
    const payload = verifyRefreshToken(token) as { userId: string };
    const accessToken = generateAccessToken(payload.userId);
    res.json({ accessToken });
  } catch {
    res.status(403).json({ message: 'Invalid refresh token' });
  }
};

export const logout = async (req: Request, res: Response): Promise<void> => {
  res.clearCookie('refreshToken');
  res.json({ message: 'Logged out' });
};
EOF

cat > server/src/controllers/profileController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';
import cloudinary from '../utils/cloudinary';

export const getProfile = async (_req: Request, res: Response): Promise<void> => {
  let profile = await prisma.profile.findFirst();
  if (!profile) profile = await prisma.profile.create({ data: { name: 'Your Name', tagline: 'Your Tagline', about: 'About you.' } });
  res.json(profile);
};

export const updateProfile = async (req: Request, res: Response): Promise<void> => {
  let profile = await prisma.profile.findFirst();
  if (!profile) { res.status(404).json({ message: 'Profile not found' }); return; }
  const updated = await prisma.profile.update({ where: { id: profile.id }, data: req.body });
  res.json(updated);
};

export const uploadPhoto = async (req: Request, res: Response): Promise<void> => {
  if (!req.file) { res.status(400).json({ message: 'No file' }); return; }
  const result = await cloudinary.uploader.upload(req.file.path, { folder: 'portfolio' });
  let profile = await prisma.profile.findFirst();
  if (!profile) { res.status(404).json({ message: 'Profile not found' }); return; }
  const updated = await prisma.profile.update({ where: { id: profile.id }, data: { photoUrl: result.secure_url } });
  res.json(updated);
};
EOF

cat > server/src/controllers/activitiesController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getActivities = async (_req: Request, res: Response): Promise<void> => {
  const activities = await prisma.eCActivity.findMany({ orderBy: { order: 'asc' } });
  res.json(activities);
};
export const createActivity = async (req: Request, res: Response): Promise<void> => {
  const activity = await prisma.eCActivity.create({ data: req.body });
  res.status(201).json(activity);
};
export const updateActivity = async (req: Request, res: Response): Promise<void> => {
  const activity = await prisma.eCActivity.update({ where: { id: req.params.id }, data: req.body });
  res.json(activity);
};
export const deleteActivity = async (req: Request, res: Response): Promise<void> => {
  await prisma.eCActivity.delete({ where: { id: req.params.id } });
  res.json({ message: 'Deleted' });
};
export const reorderActivities = async (req: Request, res: Response): Promise<void> => {
  const items: { id: string; order: number }[] = req.body;
  await Promise.all(items.map(i => prisma.eCActivity.update({ where: { id: i.id }, data: { order: i.order } })));
  res.json({ message: 'Reordered' });
};
EOF

cat > server/src/controllers/qualificationsController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getQualifications = async (_req: Request, res: Response): Promise<void> => {
  const [school, exams, certifications] = await Promise.all([
    prisma.school.findFirst(),
    prisma.exam.findMany({ orderBy: { createdAt: 'asc' } }),
    prisma.certification.findMany({ orderBy: { createdAt: 'asc' } }),
  ]);
  res.json({ school, exams, certifications });
};
export const updateSchool = async (req: Request, res: Response): Promise<void> => {
  let school = await prisma.school.findFirst();
  if (school) school = await prisma.school.update({ where: { id: school.id }, data: req.body });
  else school = await prisma.school.create({ data: req.body });
  res.json(school);
};
export const createExam = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.exam.create({ data: req.body })); };
export const updateExam = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.exam.update({ where: { id: req.params.id }, data: req.body })); };
export const deleteExam = async (req: Request, res: Response): Promise<void> => { await prisma.exam.delete({ where: { id: req.params.id } }); res.json({ message: 'Deleted' }); };
export const createCertification = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.certification.create({ data: req.body })); };
export const updateCertification = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.certification.update({ where: { id: req.params.id }, data: req.body })); };
export const deleteCertification = async (req: Request, res: Response): Promise<void> => { await prisma.certification.delete({ where: { id: req.params.id } }); res.json({ message: 'Deleted' }); };
EOF

cat > server/src/controllers/projectsController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getProjects = async (_req: Request, res: Response): Promise<void> => { res.json(await prisma.project.findMany({ orderBy: { order: 'asc' } })); };
export const createProject = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.project.create({ data: req.body })); };
export const updateProject = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.project.update({ where: { id: req.params.id }, data: req.body })); };
export const deleteProject = async (req: Request, res: Response): Promise<void> => { await prisma.project.delete({ where: { id: req.params.id } }); res.json({ message: 'Deleted' }); };
export const reorderProjects = async (req: Request, res: Response): Promise<void> => {
  const items: { id: string; order: number }[] = req.body;
  await Promise.all(items.map(i => prisma.project.update({ where: { id: i.id }, data: { order: i.order } })));
  res.json({ message: 'Reordered' });
};
EOF

cat > server/src/controllers/skillsController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getSkills = async (_req: Request, res: Response): Promise<void> => {
  const [hard, soft] = await Promise.all([prisma.hardSkill.findMany(), prisma.softSkill.findMany()]);
  res.json({ hard, soft });
};
export const createHard = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.hardSkill.create({ data: req.body })); };
export const updateHard = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.hardSkill.update({ where: { id: req.params.id }, data: req.body })); };
export const deleteHard = async (req: Request, res: Response): Promise<void> => { await prisma.hardSkill.delete({ where: { id: req.params.id } }); res.json({ message: 'Deleted' }); };
export const createSoft = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.softSkill.create({ data: req.body })); };
export const updateSoft = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.softSkill.update({ where: { id: req.params.id }, data: req.body })); };
export const deleteSoft = async (req: Request, res: Response): Promise<void> => { await prisma.softSkill.delete({ where: { id: req.params.id } }); res.json({ message: 'Deleted' }); };
EOF

cat > server/src/controllers/visionController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getVision = async (_req: Request, res: Response): Promise<void> => {
  let vision = await prisma.vision.findFirst();
  if (!vision) vision = await prisma.vision.create({ data: { text: 'Your vision here.', anchorWord: 'justice' } });
  res.json(vision);
};
export const updateVision = async (req: Request, res: Response): Promise<void> => {
  let vision = await prisma.vision.findFirst();
  if (!vision) { res.status(404).json({ message: 'Not found' }); return; }
  res.json(await prisma.vision.update({ where: { id: vision.id }, data: req.body }));
};
EOF

cat > server/src/controllers/resumeController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';
import cloudinary from '../utils/cloudinary';

export const getResume = async (_req: Request, res: Response): Promise<void> => {
  const profile = await prisma.profile.findFirst();
  res.json({ resumeUrl: profile?.resumeUrl || null });
};
export const uploadResume = async (req: Request, res: Response): Promise<void> => {
  if (!req.file) { res.status(400).json({ message: 'No file' }); return; }
  const result = await cloudinary.uploader.upload(req.file.path, { folder: 'portfolio/resumes', resource_type: 'raw' });
  const profile = await prisma.profile.findFirst();
  if (!profile) { res.status(404).json({ message: 'Profile not found' }); return; }
  const updated = await prisma.profile.update({ where: { id: profile.id }, data: { resumeUrl: result.secure_url } });
  res.json({ resumeUrl: updated.resumeUrl });
};
export const deleteResume = async (_req: Request, res: Response): Promise<void> => {
  const profile = await prisma.profile.findFirst();
  if (!profile) { res.status(404).json({ message: 'Profile not found' }); return; }
  await prisma.profile.update({ where: { id: profile.id }, data: { resumeUrl: null } });
  res.json({ message: 'Deleted' });
};
EOF

cat > server/src/controllers/contactController.ts << 'EOF'
import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getContact = async (_req: Request, res: Response): Promise<void> => { res.json(await prisma.contactLink.findMany({ orderBy: { order: 'asc' } })); };
export const createContact = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.contactLink.create({ data: req.body })); };
export const updateContact = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.contactLink.update({ where: { id: req.params.id }, data: req.body })); };
export const deleteContact = async (req: Request, res: Response): Promise<void> => { await prisma.contactLink.delete({ where: { id: req.params.id } }); res.json({ message: 'Deleted' }); };
export const reorderContact = async (req: Request, res: Response): Promise<void> => {
  const items: { id: string; order: number }[] = req.body;
  await Promise.all(items.map(i => prisma.contactLink.update({ where: { id: i.id }, data: { order: i.order } })));
  res.json({ message: 'Reordered' });
};
EOF

cat > server/src/routes/auth.ts << 'EOF'
import { Router } from 'express';
import { login, refresh, logout } from '../controllers/authController';
import { authLimiter } from '../middleware/rateLimiter';
const router = Router();
router.post('/login', authLimiter, login);
router.post('/refresh', refresh);
router.post('/logout', logout);
export default router;
EOF

cat > server/src/routes/profile.ts << 'EOF'
import { Router } from 'express';
import { getProfile, updateProfile, uploadPhoto } from '../controllers/profileController';
import { authenticateToken } from '../middleware/authenticateToken';
import multer from 'multer';
const upload = multer({ dest: 'uploads/' });
const router = Router();
router.get('/', getProfile);
router.put('/', authenticateToken, updateProfile);
router.post('/photo', authenticateToken, upload.single('photo'), uploadPhoto);
export default router;
EOF

cat > server/src/routes/activities.ts << 'EOF'
import { Router } from 'express';
import { getActivities, createActivity, updateActivity, deleteActivity, reorderActivities } from '../controllers/activitiesController';
import { authenticateToken } from '../middleware/authenticateToken';
const router = Router();
router.get('/', getActivities);
router.post('/', authenticateToken, createActivity);
router.put('/:id', authenticateToken, updateActivity);
router.delete('/:id', authenticateToken, deleteActivity);
router.patch('/reorder', authenticateToken, reorderActivities);
export default router;
EOF

cat > server/src/routes/qualifications.ts << 'EOF'
import { Router } from 'express';
import { getQualifications, updateSchool, createExam, updateExam, deleteExam, createCertification, updateCertification, deleteCertification } from '../controllers/qualificationsController';
import { authenticateToken } from '../middleware/authenticateToken';
const router = Router();
router.get('/', getQualifications);
router.put('/school', authenticateToken, updateSchool);
router.post('/exams', authenticateToken, createExam);
router.put('/exams/:id', authenticateToken, updateExam);
router.delete('/exams/:id', authenticateToken, deleteExam);
router.post('/certifications', authenticateToken, createCertification);
router.put('/certifications/:id', authenticateToken, updateCertification);
router.delete('/certifications/:id', authenticateToken, deleteCertification);
export default router;
EOF

cat > server/src/routes/projects.ts << 'EOF'
import { Router } from 'express';
import { getProjects, createProject, updateProject, deleteProject, reorderProjects } from '../controllers/projectsController';
import { authenticateToken } from '../middleware/authenticateToken';
const router = Router();
router.get('/', getProjects);
router.post('/', authenticateToken, createProject);
router.put('/:id', authenticateToken, updateProject);
router.delete('/:id', authenticateToken, deleteProject);
router.patch('/reorder', authenticateToken, reorderProjects);
export default router;
EOF

cat > server/src/routes/skills.ts << 'EOF'
import { Router } from 'express';
import { getSkills, createHard, updateHard, deleteHard, createSoft, updateSoft, deleteSoft } from '../controllers/skillsController';
import { authenticateToken } from '../middleware/authenticateToken';
const router = Router();
router.get('/', getSkills);
router.post('/hard', authenticateToken, createHard);
router.put('/hard/:id', authenticateToken, updateHard);
router.delete('/hard/:id', authenticateToken, deleteHard);
router.post('/soft', authenticateToken, createSoft);
router.put('/soft/:id', authenticateToken, updateSoft);
router.delete('/soft/:id', authenticateToken, deleteSoft);
export default router;
EOF

cat > server/src/routes/vision.ts << 'EOF'
import { Router } from 'express';
import { getVision, updateVision } from '../controllers/visionController';
import { authenticateToken } from '../middleware/authenticateToken';
const router = Router();
router.get('/', getVision);
router.put('/', authenticateToken, updateVision);
export default router;
EOF

cat > server/src/routes/resume.ts << 'EOF'
import { Router } from 'express';
import { getResume, uploadResume, deleteResume } from '../controllers/resumeController';
import { authenticateToken } from '../middleware/authenticateToken';
import multer from 'multer';
const upload = multer({ dest: 'uploads/' });
const router = Router();
router.get('/', getResume);
router.post('/', authenticateToken, upload.single('resume'), uploadResume);
router.delete('/', authenticateToken, deleteResume);
export default router;
EOF

cat > server/src/routes/contact.ts << 'EOF'
import { Router } from 'express';
import { getContact, createContact, updateContact, deleteContact, reorderContact } from '../controllers/contactController';
import { authenticateToken } from '../middleware/authenticateToken';
const router = Router();
router.get('/', getContact);
router.post('/', authenticateToken, createContact);
router.put('/:id', authenticateToken, updateContact);
router.delete('/:id', authenticateToken, deleteContact);
router.patch('/reorder', authenticateToken, reorderContact);
export default router;
EOF

cat > server/src/index.ts << 'EOF'
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import hpp from 'hpp';
import cookieParser from 'cookie-parser';
import dotenv from 'dotenv';
dotenv.config();

import authRoutes from './routes/auth';
import profileRoutes from './routes/profile';
import activitiesRoutes from './routes/activities';
import qualificationsRoutes from './routes/qualifications';
import projectsRoutes from './routes/projects';
import skillsRoutes from './routes/skills';
import visionRoutes from './routes/vision';
import resumeRoutes from './routes/resume';
import contactRoutes from './routes/contact';
import { errorHandler } from './middleware/errorHandler';

const app = express();
const PORT = process.env.PORT || 5000;

app.use(helmet());
app.use(cors({ origin: process.env.CLIENT_URL || 'http://localhost:3000', credentials: true }));
app.use(express.json({ limit: '10mb' }));
app.use(cookieParser());
app.use(hpp());

app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/activities', activitiesRoutes);
app.use('/api/qualifications', qualificationsRoutes);
app.use('/api/projects', projectsRoutes);
app.use('/api/skills', skillsRoutes);
app.use('/api/vision', visionRoutes);
app.use('/api/resume', resumeRoutes);
app.use('/api/contact', contactRoutes);

app.use(errorHandler);

app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
EOF

cat > server/render.yaml << 'EOF'
services:
  - type: web
    name: portfolio-api
    env: node
    region: oregon
    buildCommand: npm install && npx prisma generate && npm run build
    startCommand: npm start
    envVars:
      - key: NODE_ENV
        value: production
      - key: DATABASE_URL
        sync: false
      - key: JWT_ACCESS_SECRET
        sync: false
      - key: JWT_REFRESH_SECRET
        sync: false
      - key: CLOUDINARY_CLOUD_NAME
        sync: false
      - key: CLOUDINARY_API_KEY
        sync: false
      - key: CLOUDINARY_API_SECRET
        sync: false
      - key: CLIENT_URL
        sync: false
EOF

# ─── CLIENT ─────────────────────────────────────────────
mkdir -p client/src/{api,components/{ui,layout,sections,admin},hooks,pages,store,types,utils}
mkdir -p client/public

cat > client/package.json << 'EOF'
{
  "name": "portfolio-client",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "@dnd-kit/core": "^6.1.0",
    "@dnd-kit/sortable": "^8.0.0",
    "@dnd-kit/utilities": "^3.2.2",
    "@hookform/resolvers": "^3.9.1",
    "@tanstack/react-query": "^5.59.20",
    "axios": "^1.7.7",
    "framer-motion": "^11.11.11",
    "lucide-react": "^0.460.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-hook-form": "^7.53.2",
    "react-router-dom": "^6.28.0",
    "sonner": "^1.7.0",
    "zustand": "^5.0.1",
    "zod": "^3.23.8"
  },
  "devDependencies": {
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "@vitejs/plugin-react": "^4.3.3",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.49",
    "tailwindcss": "^3.4.15",
    "typescript": "^5.6.3",
    "vite": "^5.4.11"
  }
}
EOF

cat > client/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

cat > client/tsconfig.node.json << 'EOF'
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true,
    "strict": true
  },
  "include": ["vite.config.ts"]
}
EOF

cat > client/vite.config.ts << 'EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: { alias: { '@': path.resolve(__dirname, './src') } },
  server: { proxy: { '/api': { target: 'http://localhost:5000', changeOrigin: true } } },
});
EOF

cat > client/tailwind.config.ts << 'EOF'
import type { Config } from 'tailwindcss';
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        navy: { DEFAULT: '#0A0E1A', light: '#111827' },
        gold: { DEFAULT: '#C9A94B', light: '#E8C46A', dark: '#A07830' },
      },
      fontFamily: {
        inter: ['Inter', 'sans-serif'],
        playfair: ['"Playfair Display"', 'serif'],
      },
    },
  },
  plugins: [],
} satisfies Config;
EOF

cat > client/postcss.config.js << 'EOF'
export default { plugins: { tailwindcss: {}, autoprefixer: {} } };
EOF

cat > client/index.html << 'EOF'
<!doctype html>
<html lang="en" class="dark">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Portfolio</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet" />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

cat > client/src/main.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode><App /></React.StrictMode>
);
EOF

cat > client/src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

* { cursor: none; }
body { background-color: #0A0E1A; color: #F9FAFB; font-family: 'Inter', sans-serif; }
html { scroll-behavior: smooth; }

.section-divider {
  height: 1px;
  background: linear-gradient(to right, transparent, #C9A94B44, transparent);
}

::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: #0A0E1A; }
::-webkit-scrollbar-thumb { background: #C9A94B44; border-radius: 3px; }
EOF

cat > client/src/types/index.ts << 'EOF'
export interface Profile {
  id: string; name: string; tagline: string; about: string;
  photoUrl?: string; openToWork: boolean; resumeUrl?: string;
}
export interface ECActivity {
  id: string; imageUrl?: string; title: string; role: string;
  dateRange: string; description: string; category: string; order: number;
}
export interface School {
  id: string; name: string; grade: string; graduationYear: string; logoUrl?: string;
}
export interface Exam { id: string; name: string; score: string; date: string; status: string; }
export interface Certification {
  id: string; imageUrl?: string; name: string; issuer: string;
  date: string; description: string; link?: string;
}
export interface Project {
  id: string; imageUrl?: string; videoUrl?: string; title: string;
  description: string; impact?: string; tags: string[];
  githubUrl?: string; liveUrl?: string; order: number;
}
export interface HardSkill { id: string; name: string; category: string; level: number; }
export interface SoftSkill { id: string; name: string; icon: string; description: string; }
export interface Vision { id: string; text: string; anchorWord: string; }
export interface ContactLink { id: string; platform: string; icon: string; handle: string; url: string; order: number; }
EOF

cat > client/src/store/authStore.ts << 'EOF'
import { create } from 'zustand';

interface AuthState {
  accessToken: string | null;
  isAuthenticated: boolean;
  setAccessToken: (token: string) => void;
  clearAuth: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  accessToken: null,
  isAuthenticated: false,
  setAccessToken: (token) => set({ accessToken: token, isAuthenticated: true }),
  clearAuth: () => set({ accessToken: null, isAuthenticated: false }),
}));
EOF

cat > client/src/api/axios.ts << 'EOF'
import axios from 'axios';
import { useAuthStore } from '../store/authStore';

const api = axios.create({ baseURL: '/api', withCredentials: true });

api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().accessToken;
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(
  (res) => res,
  async (err) => {
    if (err.response?.status === 401) {
      try {
        const { data } = await axios.post('/api/auth/refresh', {}, { withCredentials: true });
        useAuthStore.getState().setAccessToken(data.accessToken);
        err.config.headers.Authorization = `Bearer ${data.accessToken}`;
        return api(err.config);
      } catch {
        useAuthStore.getState().clearAuth();
        window.location.href = '/admin/login';
      }
    }
    return Promise.reject(err);
  }
);

export default api;
EOF

cat > client/src/api/auth.ts << 'EOF'
import api from './axios';
export const login = (username: string, password: string) => api.post('/auth/login', { username, password }).then(r => r.data);
export const logout = () => api.post('/auth/logout');
EOF

cat > client/src/api/profile.ts << 'EOF'
import api from './axios';
import { Profile } from '../types';
export const getProfile = (): Promise<Profile> => api.get('/profile').then(r => r.data);
export const updateProfile = (data: Partial<Profile>) => api.put('/profile', data).then(r => r.data);
EOF

cat > client/src/api/activities.ts << 'EOF'
import api from './axios';
import { ECActivity } from '../types';
export const getActivities = (): Promise<ECActivity[]> => api.get('/activities').then(r => r.data);
export const createActivity = (data: Partial<ECActivity>) => api.post('/activities', data).then(r => r.data);
export const updateActivity = (id: string, data: Partial<ECActivity>) => api.put(`/activities/${id}`, data).then(r => r.data);
export const deleteActivity = (id: string) => api.delete(`/activities/${id}`);
export const reorderActivities = (items: { id: string; order: number }[]) => api.patch('/activities/reorder', items);
EOF

cat > client/src/api/qualifications.ts << 'EOF'
import api from './axios';
export const getQualifications = () => api.get('/qualifications').then(r => r.data);
export const updateSchool = (data: object) => api.put('/qualifications/school', data).then(r => r.data);
export const createExam = (data: object) => api.post('/qualifications/exams', data).then(r => r.data);
export const updateExam = (id: string, data: object) => api.put(`/qualifications/exams/${id}`, data).then(r => r.data);
export const deleteExam = (id: string) => api.delete(`/qualifications/exams/${id}`);
export const createCertification = (data: object) => api.post('/qualifications/certifications', data).then(r => r.data);
export const updateCertification = (id: string, data: object) => api.put(`/qualifications/certifications/${id}`, data).then(r => r.data);
export const deleteCertification = (id: string) => api.delete(`/qualifications/certifications/${id}`);
EOF

cat > client/src/api/projects.ts << 'EOF'
import api from './axios';
import { Project } from '../types';
export const getProjects = (): Promise<Project[]> => api.get('/projects').then(r => r.data);
export const createProject = (data: Partial<Project>) => api.post('/projects', data).then(r => r.data);
export const updateProject = (id: string, data: Partial<Project>) => api.put(`/projects/${id}`, data).then(r => r.data);
export const deleteProject = (id: string) => api.delete(`/projects/${id}`);
EOF

cat > client/src/api/skills.ts << 'EOF'
import api from './axios';
export const getSkills = () => api.get('/skills').then(r => r.data);
export const createHardSkill = (data: object) => api.post('/skills/hard', data).then(r => r.data);
export const updateHardSkill = (id: string, data: object) => api.put(`/skills/hard/${id}`, data).then(r => r.data);
export const deleteHardSkill = (id: string) => api.delete(`/skills/hard/${id}`);
export const createSoftSkill = (data: object) => api.post('/skills/soft', data).then(r => r.data);
export const updateSoftSkill = (id: string, data: object) => api.put(`/skills/soft/${id}`, data).then(r => r.data);
export const deleteSoftSkill = (id: string) => api.delete(`/skills/soft/${id}`);
EOF

cat > client/src/api/vision.ts << 'EOF'
import api from './axios';
import { Vision } from '../types';
export const getVision = (): Promise<Vision> => api.get('/vision').then(r => r.data);
export const updateVision = (data: Partial<Vision>) => api.put('/vision', data).then(r => r.data);
EOF

cat > client/src/api/resume.ts << 'EOF'
import api from './axios';
export const getResume = () => api.get('/resume').then(r => r.data);
export const deleteResume = () => api.delete('/resume');
EOF

cat > client/src/api/contact.ts << 'EOF'
import api from './axios';
import { ContactLink } from '../types';
export const getContact = (): Promise<ContactLink[]> => api.get('/contact').then(r => r.data);
export const createContact = (data: Partial<ContactLink>) => api.post('/contact', data).then(r => r.data);
export const updateContact = (id: string, data: Partial<ContactLink>) => api.put(`/contact/${id}`, data).then(r => r.data);
export const deleteContact = (id: string) => api.delete(`/contact/${id}`);
EOF

cat > client/src/hooks/index.ts << 'EOF'
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
EOF

cat > client/netlify.toml << 'EOF'
[build]
  command = "npm run build"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[build.environment]
  NODE_VERSION = "20"
EOF

echo "✅ Barcha fayllar yaratildi!"
echo ""
echo "📦 Keyin shu buyruqlarni bajaring:"
echo "   cd server && npm install"
echo "   cd ../client && npm install"
echo ""
echo "🎉 Tayyor!"

# ─── FRONTEND COMPONENTS ────────────────────────────────

cat > client/src/components/layout/Navbar.tsx << 'EOF'
import { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import { useProfile } from '../../hooks';

const links = ['About','Experience','Qualifications','Projects','Skills','Vision','Contact'];

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  const { data: profile } = useProfile();

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 80);
    window.addEventListener('scroll', handler);
    return () => window.removeEventListener('scroll', handler);
  }, []);

  const scrollTo = (id: string) => {
    document.getElementById(id.toLowerCase())?.scrollIntoView({ behavior: 'smooth' });
    setOpen(false);
  };

  return (
    <nav className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${scrolled ? 'backdrop-blur-md bg-navy/80 border-b border-gold/10' : ''}`}>
      <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <div className="w-10 h-10 rounded-full bg-gold flex items-center justify-center">
          <span className="text-navy font-playfair font-bold text-sm">
            {profile?.name?.split(' ').map(n => n[0]).join('') || 'UP'}
          </span>
        </div>
        <div className="hidden md:flex items-center gap-8">
          {links.map(l => (
            <button key={l} onClick={() => scrollTo(l.toLowerCase())}
              className="text-sm text-gray-400 hover:text-gold transition-colors">
              {l}
            </button>
          ))}
          {profile?.openToWork && (
            <span className="px-3 py-1 rounded-full bg-gold/20 text-gold text-xs border border-gold/30">
              Open to Work
            </span>
          )}
        </div>
        <button className="md:hidden text-gray-400" onClick={() => setOpen(!open)}>
          {open ? <X size={24} /> : <Menu size={24} />}
        </button>
      </div>
      {open && (
        <div className="md:hidden bg-navy/95 backdrop-blur border-t border-gold/10 px-6 py-4 flex flex-col gap-4">
          {links.map(l => (
            <button key={l} onClick={() => scrollTo(l.toLowerCase())} className="text-gray-300 hover:text-gold text-left">
              {l}
            </button>
          ))}
        </div>
      )}
    </nav>
  );
}
EOF

cat > client/src/components/layout/Footer.tsx << 'EOF'
import { useProfile } from '../../hooks';
export default function Footer() {
  const { data: profile } = useProfile();
  return (
    <footer className="py-8 text-center text-gray-600 text-sm border-t border-white/5">
      © {new Date().getFullYear()} {profile?.name || 'Portfolio'}. All rights reserved.
    </footer>
  );
}
EOF

cat > client/src/components/layout/Layout.tsx << 'EOF'
import { useEffect, useState } from 'react';
import Navbar from './Navbar';
import Footer from './Footer';

export default function Layout({ children }: { children: React.ReactNode }) {
  const [cursor, setCursor] = useState({ x: 0, y: 0, hovered: false });

  useEffect(() => {
    const move = (e: MouseEvent) => setCursor(c => ({ ...c, x: e.clientX, y: e.clientY }));
    const over = (e: MouseEvent) => {
      const t = e.target as HTMLElement;
      setCursor(c => ({ ...c, hovered: !!(t.closest('a,button,[role=button],.card') ) }));
    };
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseover', over);
    return () => { window.removeEventListener('mousemove', move); window.removeEventListener('mouseover', over); };
  }, []);

  return (
    <div className="min-h-screen bg-navy font-inter">
      <div
        className="fixed pointer-events-none z-[9999] rounded-full bg-gold transition-transform duration-100"
        style={{
          left: cursor.x - (cursor.hovered ? 12 : 6),
          top: cursor.y - (cursor.hovered ? 12 : 6),
          width: cursor.hovered ? 24 : 12,
          height: cursor.hovered ? 24 : 12,
          opacity: 0.8,
        }}
      />
      <Navbar />
      <main>{children}</main>
      <Footer />
    </div>
  );
}
EOF

cat > client/src/components/layout/ProtectedRoute.tsx << 'EOF'
import { Navigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
export default function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const isAuthenticated = useAuthStore(s => s.isAuthenticated);
  return isAuthenticated ? <>{children}</> : <Navigate to="/admin/login" replace />;
}
EOF

cat > client/src/components/ui/ScrollReveal.tsx << 'EOF'
import { motion } from 'framer-motion';
import { useReducedMotion } from '../../hooks';

export default function ScrollReveal({ children, delay = 0 }: { children: React.ReactNode; delay?: number }) {
  const reduced = useReducedMotion();
  return (
    <motion.div
      initial={reduced ? {} : { opacity: 0, y: 30 }}
      whileInView={reduced ? {} : { opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-50px' }}
      transition={{ duration: 0.6, delay, ease: [0.22, 1, 0.36, 1] }}
    >
      {children}
    </motion.div>
  );
}
EOF

cat > client/src/components/sections/HeroSection.tsx << 'EOF'
import { motion } from 'framer-motion';
import { useMouseParallax } from '../../hooks';
import { Profile } from '../../types';
import { ChevronDown } from 'lucide-react';
import { useState, useEffect } from 'react';

export default function HeroSection({ profile }: { profile?: Profile }) {
  const parallax = useMouseParallax();
  const [typed, setTyped] = useState('');
  const tagline = profile?.tagline || 'Aspiring Commercial Lawyer | Nature Advocate';

  useEffect(() => {
    let i = 0;
    setTyped('');
    const timer = setInterval(() => {
      setTyped(tagline.slice(0, i));
      i++;
      if (i > tagline.length) clearInterval(timer);
    }, 40);
    return () => clearInterval(timer);
  }, [tagline]);

  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden" id="hero">
      <div className="absolute inset-0 pointer-events-none" style={{ transform: `translate(${parallax.x * 0.5}px, ${parallax.y * 0.5}px)` }}>
        <svg className="w-full h-full opacity-10" viewBox="0 0 800 800" xmlns="http://www.w3.org/2000/svg">
          <g stroke="#C9A94B" strokeWidth="1" fill="none">
            <line x1="400" y1="700" x2="400" y2="400"/>
            <line x1="400" y1="400" x2="250" y2="250"/><line x1="400" y1="400" x2="550" y2="250"/>
            <line x1="250" y1="250" x2="150" y2="100"/><line x1="250" y1="250" x2="320" y2="100"/>
            <line x1="550" y1="250" x2="480" y2="100"/><line x1="550" y1="250" x2="650" y2="100"/>
            <circle cx="400" cy="700" r="4" fill="#C9A94B"/><circle cx="400" cy="400" r="4" fill="#C9A94B"/>
            <circle cx="250" cy="250" r="4" fill="#C9A94B"/><circle cx="550" cy="250" r="4" fill="#C9A94B"/>
          </g>
        </svg>
      </div>
      <div className="relative z-10 text-center px-6 max-w-4xl">
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.8 }}>
          {profile?.name?.split(' ').map((word, i) => (
            <motion.span key={i} initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.15, duration: 0.6 }}
              className="inline-block font-playfair text-5xl md:text-7xl font-bold text-white mr-4">
              {word}
            </motion.span>
          ))}
        </motion.div>
        <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.8 }}
          className="mt-6 text-gold text-lg md:text-xl min-h-[2rem]">
          {typed}<span className="animate-pulse">|</span>
        </motion.p>
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.2 }} className="mt-10 flex gap-4 justify-center flex-wrap">
          {profile?.resumeUrl && (
            <a href={profile.resumeUrl} target="_blank" rel="noreferrer"
              className="px-8 py-3 bg-gold text-navy font-semibold rounded-lg hover:bg-gold-light transition-colors">
              View Resume
            </a>
          )}
          <button onClick={() => document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth' })}
            className="px-8 py-3 border border-gold text-gold rounded-lg hover:bg-gold/10 transition-colors">
            Contact Me
          </button>
        </motion.div>
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 1.5 }}
          className="absolute bottom-8 left-1/2 -translate-x-1/2">
          <ChevronDown size={32} className="text-gold animate-bounce" />
        </motion.div>
      </div>
    </section>
  );
}
EOF

cat > client/src/components/sections/AboutSection.tsx << 'EOF'
import ScrollReveal from '../ui/ScrollReveal';
import { Profile } from '../../types';

export default function AboutSection({ profile }: { profile?: Profile }) {
  return (
    <section id="about" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal>
        <h2 className="font-playfair text-4xl font-bold text-white mb-12 text-center">About Me</h2>
      </ScrollReveal>
      <div className="grid md:grid-cols-2 gap-12 items-center">
        <ScrollReveal delay={0.1}>
          <div className="aspect-square max-w-sm mx-auto rounded-2xl border-2 border-gold overflow-hidden bg-navy-light">
            {profile?.photoUrl ? (
              <img src={profile.photoUrl} alt={profile.name} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center">
                <span className="font-playfair text-6xl text-gold">{profile?.name?.[0] || 'U'}</span>
              </div>
            )}
          </div>
        </ScrollReveal>
        <ScrollReveal delay={0.2}>
          <p className="text-gray-300 text-lg leading-relaxed">{profile?.about}</p>
        </ScrollReveal>
      </div>
    </section>
  );
}
EOF

cat > client/src/components/sections/ECSection.tsx << 'EOF'
import { useState } from 'react';
import ScrollReveal from '../ui/ScrollReveal';
import { ECActivity } from '../../types';

const CATEGORIES = ['All', 'Leadership', 'Academic', 'Community', 'Arts', 'Athletics'];

export default function ECSection({ activities }: { activities?: ECActivity[] }) {
  const [cat, setCat] = useState('All');
  const filtered = activities?.filter(a => cat === 'All' || a.category === cat) || [];

  return (
    <section id="experience" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-8 text-center">ECs & Leadership</h2></ScrollReveal>
      <ScrollReveal delay={0.1}>
        <div className="flex flex-wrap gap-3 justify-center mb-12">
          {CATEGORIES.map(c => (
            <button key={c} onClick={() => setCat(c)}
              className={`px-4 py-2 rounded-full text-sm transition-all ${cat === c ? 'bg-gold text-navy font-semibold' : 'border border-gold/30 text-gray-400 hover:border-gold hover:text-gold'}`}>
              {c}
            </button>
          ))}
        </div>
      </ScrollReveal>
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filtered.map((a, i) => (
          <ScrollReveal key={a.id} delay={i * 0.1}>
            <div className="bg-navy-light rounded-xl border border-white/5 p-6 hover:border-gold/40 hover:-translate-y-1 transition-all duration-300 group">
              <span className="px-2 py-1 rounded text-xs bg-gold/20 text-gold border border-gold/20">{a.category}</span>
              <h3 className="font-playfair text-xl font-bold text-white mt-3 mb-1">{a.title}</h3>
              <p className="text-gold text-sm mb-1">{a.role}</p>
              <p className="text-gray-500 text-xs mb-3">{a.dateRange}</p>
              <p className="text-gray-400 text-sm">{a.description}</p>
            </div>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}
EOF

cat > client/src/components/sections/QualificationsSection.tsx << 'EOF'
import { useState } from 'react';
import ScrollReveal from '../ui/ScrollReveal';
import { School, Exam, Certification } from '../../types';
import { ExternalLink } from 'lucide-react';

type Props = { school?: School; exams?: Exam[]; certifications?: Certification[] };

export default function QualificationsSection({ school, exams, certifications }: Props) {
  const [tab, setTab] = useState<'school'|'exams'|'certifications'>('school');
  const tabs = ['school','exams','certifications'] as const;

  return (
    <section id="qualifications" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-8 text-center">Qualifications</h2></ScrollReveal>
      <div className="flex gap-4 justify-center mb-12">
        {tabs.map(t => (
          <button key={t} onClick={() => setTab(t)}
            className={`px-6 py-2 rounded-full capitalize text-sm transition-all ${tab===t ? 'bg-gold text-navy font-semibold' : 'border border-gold/30 text-gray-400 hover:text-gold hover:border-gold'}`}>
            {t}
          </button>
        ))}
      </div>
      {tab==='school' && school && (
        <ScrollReveal>
          <div className="max-w-md mx-auto bg-navy-light rounded-xl border border-gold/20 p-8 text-center">
            <h3 className="font-playfair text-2xl font-bold text-white mb-2">{school.name}</h3>
            <p className="text-gold">Grade: {school.grade}</p>
            <p className="text-gray-400">Graduating: {school.graduationYear}</p>
          </div>
        </ScrollReveal>
      )}
      {tab==='exams' && (
        <ScrollReveal>
          <div className="overflow-x-auto rounded-xl border border-white/5">
            <table className="w-full">
              <thead className="bg-navy-light"><tr>
                {['Exam','Score','Date','Status'].map(h=><th key={h} className="text-left px-6 py-4 text-gray-400 text-sm font-medium">{h}</th>)}
              </tr></thead>
              <tbody>{exams?.map(e=>(
                <tr key={e.id} className="border-t border-white/5 hover:bg-navy-light transition-colors">
                  <td className="px-6 py-4 text-white font-medium">{e.name}</td>
                  <td className="px-6 py-4 text-gold font-bold">{e.score}</td>
                  <td className="px-6 py-4 text-gray-400">{e.date}</td>
                  <td className="px-6 py-4">
                    <span className={`px-3 py-1 rounded-full text-xs ${e.status==='Completed' ? 'bg-green-500/20 text-green-400' : 'bg-yellow-500/20 text-yellow-400'}`}>{e.status}</span>
                  </td>
                </tr>
              ))}</tbody>
            </table>
          </div>
        </ScrollReveal>
      )}
      {tab==='certifications' && (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {certifications?.map((c,i)=>(
            <ScrollReveal key={c.id} delay={i*0.1}>
              <div className="bg-navy-light rounded-xl border border-white/5 p-6 hover:border-gold/40 transition-all">
                <h3 className="font-semibold text-white mb-1">{c.name}</h3>
                <p className="text-gold text-sm">{c.issuer}</p>
                <p className="text-gray-500 text-xs mb-3">{c.date}</p>
                <p className="text-gray-400 text-sm mb-4">{c.description}</p>
                {c.link && <a href={c.link} target="_blank" rel="noreferrer" className="flex items-center gap-1 text-gold text-sm hover:underline"><ExternalLink size={14}/>View</a>}
              </div>
            </ScrollReveal>
          ))}
        </div>
      )}
    </section>
  );
}
EOF

cat > client/src/components/sections/ProjectsSection.tsx << 'EOF'
import ScrollReveal from '../ui/ScrollReveal';
import { Project } from '../../types';
import { Github, ExternalLink } from 'lucide-react';

export default function ProjectsSection({ projects }: { projects?: Project[] }) {
  return (
    <section id="projects" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-16 text-center">Projects</h2></ScrollReveal>
      <div className="flex flex-col gap-16">
        {projects?.map((p, i) => (
          <ScrollReveal key={p.id} delay={0.1}>
            <div className={`grid md:grid-cols-2 gap-8 items-center ${i%2===1 ? 'md:[direction:rtl]' : ''}`}>
              <div className={i%2===1 ? '[direction:ltr]' : ''}>
                <div className="aspect-video rounded-xl bg-navy-light border border-white/5 overflow-hidden group hover:border-gold/40 transition-all hover:scale-[1.01]">
                  {p.imageUrl ? <img src={p.imageUrl} alt={p.title} className="w-full h-full object-cover" /> :
                    <div className="w-full h-full flex items-center justify-center text-gray-600 font-playfair text-2xl">{p.title[0]}</div>}
                </div>
              </div>
              <div className={i%2===1 ? '[direction:ltr]' : ''}>
                <h3 className="font-playfair text-2xl font-bold text-white mb-3">{p.title}</h3>
                <p className="text-gray-400 mb-4">{p.description}</p>
                {p.impact && <p className="text-gold text-sm mb-4 font-medium">📊 {p.impact}</p>}
                <div className="flex flex-wrap gap-2 mb-6">
                  {p.tags.map(t => <span key={t} className="px-3 py-1 bg-gold/10 text-gold text-xs rounded-full border border-gold/20">{t}</span>)}
                </div>
                <div className="flex gap-4">
                  {p.githubUrl && <a href={p.githubUrl} target="_blank" rel="noreferrer" className="flex items-center gap-2 text-gray-400 hover:text-white transition-colors"><Github size={18}/>GitHub</a>}
                  {p.liveUrl && <a href={p.liveUrl} target="_blank" rel="noreferrer" className="flex items-center gap-2 text-gold hover:text-gold-light transition-colors"><ExternalLink size={18}/>Live</a>}
                </div>
              </div>
            </div>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}
EOF

cat > client/src/components/sections/SkillsSection.tsx << 'EOF'
import ScrollReveal from '../ui/ScrollReveal';
import { HardSkill, SoftSkill } from '../../types';

export default function SkillsSection({ hard, soft }: { hard?: HardSkill[]; soft?: SoftSkill[] }) {
  const grouped = hard?.reduce((acc, s) => { (acc[s.category] = acc[s.category] || []).push(s); return acc; }, {} as Record<string, HardSkill[]>) || {};

  return (
    <section id="skills" className="py-24 px-6 max-w-6xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-16 text-center">Superpowers</h2></ScrollReveal>
      <div className="grid md:grid-cols-2 gap-16">
        <div>
          <ScrollReveal><h3 className="text-xl font-semibold text-white mb-8">Hard Skills</h3></ScrollReveal>
          {Object.entries(grouped).map(([cat, skills]) => (
            <div key={cat} className="mb-8">
              <p className="text-gold text-sm mb-4 uppercase tracking-wider">{cat}</p>
              {skills.map((s, i) => (
                <ScrollReveal key={s.id} delay={i*0.05}>
                  <div className="mb-4">
                    <div className="flex justify-between mb-1">
                      <span className="text-gray-300 text-sm">{s.name}</span>
                      <span className="text-gold text-sm">{s.level}/5</span>
                    </div>
                    <div className="h-2 bg-navy-light rounded-full overflow-hidden">
                      <div className="h-full bg-gradient-to-r from-gold to-gold-light rounded-full transition-all duration-1000" style={{ width: `${(s.level/5)*100}%` }} />
                    </div>
                  </div>
                </ScrollReveal>
              ))}
            </div>
          ))}
        </div>
        <div>
          <ScrollReveal><h3 className="text-xl font-semibold text-white mb-8">Soft Skills</h3></ScrollReveal>
          <div className="grid grid-cols-2 gap-4">
            {soft?.map((s, i) => (
              <ScrollReveal key={s.id} delay={i*0.1}>
                <div className="bg-navy-light rounded-xl border border-white/5 p-4 hover:border-gold/40 transition-all group">
                  <p className="font-semibold text-white mb-1">{s.name}</p>
                  <p className="text-gray-500 text-xs">{s.description}</p>
                </div>
              </ScrollReveal>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
EOF

cat > client/src/components/sections/VisionSection.tsx << 'EOF'
import ScrollReveal from '../ui/ScrollReveal';
import { Vision } from '../../types';

export default function VisionSection({ vision }: { vision?: Vision }) {
  if (!vision) return null;
  const parts = vision.text.split(new RegExp(`(${vision.anchorWord})`, 'gi'));
  return (
    <section id="vision" className="py-24 px-6">
      <div className="section-divider mb-24" />
      <div className="max-w-4xl mx-auto text-center">
        <ScrollReveal>
          <div className="text-6xl text-gold/30 font-playfair leading-none mb-6">"</div>
          <p className="font-playfair text-2xl md:text-3xl text-gray-200 leading-relaxed">
            {parts.map((p, i) =>
              p.toLowerCase() === vision.anchorWord.toLowerCase()
                ? <span key={i} className="text-gold animate-pulse">{p}</span>
                : p
            )}
          </p>
          <div className="text-6xl text-gold/30 font-playfair leading-none mt-6 rotate-180 inline-block">"</div>
        </ScrollReveal>
      </div>
    </section>
  );
}
EOF

cat > client/src/components/sections/ResumeSection.tsx << 'EOF'
import ScrollReveal from '../ui/ScrollReveal';
import { FileText, Download } from 'lucide-react';

export default function ResumeSection({ resumeUrl }: { resumeUrl?: string }) {
  return (
    <section id="resume" className="py-24 px-6">
      <div className="max-w-md mx-auto text-center">
        <ScrollReveal>
          <h2 className="font-playfair text-4xl font-bold text-white mb-8">Resume</h2>
          {resumeUrl ? (
            <a href={resumeUrl} target="_blank" rel="noreferrer"
              className="inline-flex items-center gap-3 px-8 py-4 bg-gold text-navy font-semibold rounded-xl hover:bg-gold-light transition-colors">
              <Download size={20} />Download Resume
            </a>
          ) : (
            <div className="flex flex-col items-center gap-4 text-gray-500">
              <FileText size={48} /><p>No resume uploaded yet.</p>
            </div>
          )}
        </ScrollReveal>
      </div>
    </section>
  );
}
EOF

cat > client/src/components/sections/ContactSection.tsx << 'EOF'
import ScrollReveal from '../ui/ScrollReveal';
import { ContactLink } from '../../types';

const ICONS: Record<string, string> = {
  telegram: '✈️', instagram: '📸', email: '✉️', linkedin: '💼', whatsapp: '📱',
};

export default function ContactSection({ contacts }: { contacts?: ContactLink[] }) {
  return (
    <section id="contact" className="py-24 px-6 max-w-4xl mx-auto">
      <div className="section-divider mb-24" />
      <ScrollReveal><h2 className="font-playfair text-4xl font-bold text-white mb-12 text-center">Get In Touch</h2></ScrollReveal>
      <div className="grid grid-cols-2 md:grid-cols-3 gap-6">
        {contacts?.map((c, i) => (
          <ScrollReveal key={c.id} delay={i*0.1}>
            <a href={c.url} target="_blank" rel="noreferrer"
              className="flex flex-col items-center gap-3 p-6 bg-navy-light rounded-xl border border-white/5 hover:border-gold hover:-translate-y-1 transition-all duration-300 group">
              <span className="text-3xl">{ICONS[c.icon] || '🔗'}</span>
              <span className="font-medium text-white">{c.platform}</span>
              <span className="text-gray-500 text-sm text-center">{c.handle}</span>
            </a>
          </ScrollReveal>
        ))}
      </div>
    </section>
  );
}
EOF

# ─── PAGES ──────────────────────────────────────────────

cat > client/src/pages/PortfolioPage.tsx << 'EOF'
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
EOF

cat > client/src/pages/AdminLoginPage.tsx << 'EOF'
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
EOF

cat > client/src/pages/AdminDashboard.tsx << 'EOF'
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
EOF

# ─── ADMIN COMPONENTS ───────────────────────────────────

cat > client/src/components/admin/AdminProfile.tsx << 'EOF'
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
EOF

cat > client/src/components/admin/AdminECs.tsx << 'EOF'
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getActivities, createActivity, updateActivity, deleteActivity } from '../../api/activities';
import { ECActivity } from '../../types';
import { Pencil, Trash2, Plus, X } from 'lucide-react';

const empty = { title: '', role: '', dateRange: '', description: '', category: 'Leadership' };

export default function AdminECs() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['activities'], queryFn: getActivities });
  const [form, setForm] = useState<Partial<ECActivity>>(empty);
  const [editing, setEditing] = useState<string|null>(null);
  const [showForm, setShowForm] = useState(false);

  const save = useMutation({
    mutationFn: () => editing ? updateActivity(editing, form) : createActivity(form),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['activities'] }); toast.success('Saved!'); setShowForm(false); setForm(empty); setEditing(null); }
  });
  const del = useMutation({
    mutationFn: deleteActivity,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['activities'] }); toast.success('Deleted'); }
  });

  const edit = (a: ECActivity) => { setForm(a); setEditing(a.id); setShowForm(true); };

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h2 className="font-playfair text-2xl font-bold text-white">ECs & Leadership</h2>
        <button onClick={() => { setForm(empty); setEditing(null); setShowForm(true); }}
          className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold"><Plus size={16}/>Add New</button>
      </div>
      {showForm && (
        <div className="bg-navy-light rounded-xl border border-white/10 p-6 mb-6">
          <div className="flex justify-between mb-4"><h3 className="text-white font-semibold">{editing ? 'Edit' : 'New'} Activity</h3>
            <button onClick={() => setShowForm(false)}><X size={20} className="text-gray-400"/></button></div>
          <div className="grid grid-cols-2 gap-4">
            {(['title','role','dateRange','category'] as const).map(f => (
              <input key={f} value={form[f] || ''} onChange={e => setForm(p => ({...p,[f]:e.target.value}))} placeholder={f}
                className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none" />
            ))}
            <textarea value={form.description || ''} onChange={e => setForm(p => ({...p,description:e.target.value}))} placeholder="Description" rows={3}
              className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none resize-none" />
          </div>
          <button onClick={() => save.mutate()} disabled={save.isPending}
            className="mt-4 px-6 py-2 bg-gold text-navy rounded-lg font-semibold text-sm">{save.isPending ? 'Saving...' : 'Save'}</button>
        </div>
      )}
      <div className="flex flex-col gap-3">
        {data?.map(a => (
          <div key={a.id} className="flex items-center justify-between bg-navy-light rounded-xl border border-white/5 px-6 py-4">
            <div><p className="text-white font-medium">{a.title}</p><p className="text-gray-500 text-sm">{a.role} · {a.category}</p></div>
            <div className="flex gap-2">
              <button onClick={() => edit(a)} className="p-2 text-gray-400 hover:text-gold"><Pencil size={16}/></button>
              <button onClick={() => del.mutate(a.id)} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
EOF

cat > client/src/components/admin/AdminQualifications.tsx << 'EOF'
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getQualifications, updateSchool, createExam, deleteExam, createCertification, deleteCertification } from '../../api/qualifications';
import { Trash2, Plus } from 'lucide-react';

export default function AdminQualifications() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['qualifications'], queryFn: getQualifications });
  const [exam, setExam] = useState({ name: '', score: '', date: '', status: 'Completed' });
  const [cert, setCert] = useState({ name: '', issuer: '', date: '', description: '', link: '' });

  const saveSchool = useMutation({ mutationFn: updateSchool, onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('School saved!'); } });
  const addExam = useMutation({ mutationFn: () => createExam(exam), onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Exam added!'); } });
  const delExam = useMutation({ mutationFn: deleteExam, onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Deleted'); } });
  const addCert = useMutation({ mutationFn: () => createCertification(cert), onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Certification added!'); } });
  const delCert = useMutation({ mutationFn: deleteCertification, onSuccess: () => { qc.invalidateQueries({ queryKey: ['qualifications'] }); toast.success('Deleted'); } });

  return (
    <div className="flex flex-col gap-10">
      <h2 className="font-playfair text-2xl font-bold text-white">Qualifications</h2>
      <section>
        <h3 className="text-white font-semibold mb-4">School</h3>
        <div className="grid grid-cols-3 gap-4 mb-4">
          {['name','grade','graduationYear'].map(f => (
            <input key={f} defaultValue={data?.school?.[f as keyof typeof data.school] || ''} placeholder={f}
              id={`school-${f}`} className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none" />
          ))}
        </div>
        <button onClick={() => saveSchool.mutate({ name: (document.getElementById('school-name') as HTMLInputElement)?.value, grade: (document.getElementById('school-grade') as HTMLInputElement)?.value, graduationYear: (document.getElementById('school-graduationYear') as HTMLInputElement)?.value })}
          className="px-6 py-2 bg-gold text-navy rounded-lg font-semibold text-sm">Save School</button>
      </section>
      <section>
        <h3 className="text-white font-semibold mb-4">Exams</h3>
        <div className="grid grid-cols-4 gap-3 mb-4">
          {(['name','score','date'] as const).map(f => (
            <input key={f} value={exam[f]} onChange={e => setExam(p => ({...p,[f]:e.target.value}))} placeholder={f}
              className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none" />
          ))}
          <select value={exam.status} onChange={e => setExam(p => ({...p,status:e.target.value}))}
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none">
            <option>Completed</option><option>Upcoming</option>
          </select>
        </div>
        <button onClick={() => addExam.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.exams?.map((e: { id: string; name: string; score: string; status: string }) => (
          <div key={e.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{e.name} — {e.score} <span className="text-gray-500">({e.status})</span></span>
            <button onClick={() => delExam.mutate(e.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </section>
      <section>
        <h3 className="text-white font-semibold mb-4">Certifications</h3>
        <div className="grid grid-cols-2 gap-3 mb-4">
          {(['name','issuer','date','link'] as const).map(f => (
            <input key={f} value={cert[f]} onChange={e => setCert(p => ({...p,[f]:e.target.value}))} placeholder={f}
              className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none" />
          ))}
          <textarea value={cert.description} onChange={e => setCert(p => ({...p,description:e.target.value}))} placeholder="Description" rows={2}
            className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none resize-none" />
        </div>
        <button onClick={() => addCert.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.certifications?.map((c: { id: string; name: string; issuer: string }) => (
          <div key={c.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{c.name} <span className="text-gray-500">— {c.issuer}</span></span>
            <button onClick={() => delCert.mutate(c.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </section>
    </div>
  );
}
EOF

cat > client/src/components/admin/AdminProjects.tsx << 'EOF'
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getProjects, createProject, updateProject, deleteProject } from '../../api/projects';
import { Project } from '../../types';
import { Pencil, Trash2, Plus, X } from 'lucide-react';

const empty: Partial<Project> = { title: '', description: '', impact: '', tags: [], githubUrl: '', liveUrl: '' };

export default function AdminProjects() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['projects'], queryFn: getProjects });
  const [form, setForm] = useState<Partial<Project>>(empty);
  const [editing, setEditing] = useState<string|null>(null);
  const [showForm, setShowForm] = useState(false);
  const [tagsInput, setTagsInput] = useState('');

  const save = useMutation({
    mutationFn: () => editing ? updateProject(editing, { ...form, tags: tagsInput.split(',').map(t=>t.trim()).filter(Boolean) })
      : createProject({ ...form, tags: tagsInput.split(',').map(t=>t.trim()).filter(Boolean) }),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['projects'] }); toast.success('Saved!'); setShowForm(false); setForm(empty); setEditing(null); }
  });
  const del = useMutation({ mutationFn: deleteProject, onSuccess: () => { qc.invalidateQueries({ queryKey: ['projects'] }); toast.success('Deleted'); } });

  const edit = (p: Project) => { setForm(p); setEditing(p.id); setTagsInput(p.tags.join(', ')); setShowForm(true); };

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h2 className="font-playfair text-2xl font-bold text-white">Projects</h2>
        <button onClick={() => { setForm(empty); setEditing(null); setTagsInput(''); setShowForm(true); }}
          className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold"><Plus size={16}/>Add</button>
      </div>
      {showForm && (
        <div className="bg-navy-light rounded-xl border border-white/10 p-6 mb-6">
          <div className="flex justify-between mb-4"><h3 className="text-white font-semibold">{editing?'Edit':'New'} Project</h3>
            <button onClick={() => setShowForm(false)}><X size={20} className="text-gray-400"/></button></div>
          <div className="grid grid-cols-2 gap-4">
            {(['title','impact','githubUrl','liveUrl'] as const).map(f => (
              <input key={f} value={form[f] as string || ''} onChange={e => setForm(p=>({...p,[f]:e.target.value}))} placeholder={f}
                className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none" />
            ))}
            <textarea value={form.description||''} onChange={e=>setForm(p=>({...p,description:e.target.value}))} placeholder="Description" rows={3}
              className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none resize-none"/>
            <input value={tagsInput} onChange={e=>setTagsInput(e.target.value)} placeholder="Tags (comma separated)"
              className="col-span-2 bg-navy border border-white/10 rounded-lg px-4 py-3 text-white placeholder-gray-600 focus:border-gold focus:outline-none"/>
          </div>
          <button onClick={() => save.mutate()} disabled={save.isPending}
            className="mt-4 px-6 py-2 bg-gold text-navy rounded-lg font-semibold text-sm">{save.isPending?'Saving...':'Save'}</button>
        </div>
      )}
      <div className="flex flex-col gap-3">
        {data?.map(p => (
          <div key={p.id} className="flex items-center justify-between bg-navy-light rounded-xl border border-white/5 px-6 py-4">
            <div><p className="text-white font-medium">{p.title}</p><p className="text-gray-500 text-sm">{p.tags.join(', ')}</p></div>
            <div className="flex gap-2">
              <button onClick={() => edit(p)} className="p-2 text-gray-400 hover:text-gold"><Pencil size={16}/></button>
              <button onClick={() => del.mutate(p.id)} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
EOF

cat > client/src/components/admin/AdminSkills.tsx << 'EOF'
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getSkills, createHardSkill, deleteHardSkill, createSoftSkill, deleteSoftSkill } from '../../api/skills';
import { Trash2, Plus } from 'lucide-react';

export default function AdminSkills() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['skills'], queryFn: getSkills });
  const [hard, setHard] = useState({ name: '', category: '', level: 3 });
  const [soft, setSoft] = useState({ name: '', icon: 'Star', description: '' });

  const addHard = useMutation({ mutationFn: () => createHardSkill(hard), onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Added!'); } });
  const delHard = useMutation({ mutationFn: deleteHardSkill, onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Deleted'); } });
  const addSoft = useMutation({ mutationFn: () => createSoftSkill(soft), onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Added!'); } });
  const delSoft = useMutation({ mutationFn: deleteSoftSkill, onSuccess: () => { qc.invalidateQueries({ queryKey: ['skills'] }); toast.success('Deleted'); } });

  return (
    <div className="flex flex-col gap-10">
      <h2 className="font-playfair text-2xl font-bold text-white">Skills</h2>
      <section>
        <h3 className="text-white font-semibold mb-4">Hard Skills</h3>
        <div className="grid grid-cols-3 gap-3 mb-3">
          <input value={hard.name} onChange={e=>setHard(p=>({...p,name:e.target.value}))} placeholder="Skill name"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <input value={hard.category} onChange={e=>setHard(p=>({...p,category:e.target.value}))} placeholder="Category"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <div className="flex items-center gap-3 bg-navy border border-white/10 rounded-lg px-4 py-3">
            <span className="text-gray-400 text-sm">Level:</span>
            <input type="range" min={1} max={5} value={hard.level} onChange={e=>setHard(p=>({...p,level:+e.target.value}))} className="flex-1 accent-gold"/>
            <span className="text-gold font-bold">{hard.level}</span>
          </div>
        </div>
        <button onClick={() => addHard.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.hard?.map((s: { id: string; name: string; category: string; level: number }) => (
          <div key={s.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{s.name} <span className="text-gray-500">({s.category})</span></span>
            <div className="flex items-center gap-4"><span className="text-gold">{s.level}/5</span>
              <button onClick={() => delHard.mutate(s.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button></div>
          </div>
        ))}
      </section>
      <section>
        <h3 className="text-white font-semibold mb-4">Soft Skills</h3>
        <div className="grid grid-cols-3 gap-3 mb-3">
          <input value={soft.name} onChange={e=>setSoft(p=>({...p,name:e.target.value}))} placeholder="Skill name"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <input value={soft.icon} onChange={e=>setSoft(p=>({...p,icon:e.target.value}))} placeholder="Icon name"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
          <input value={soft.description} onChange={e=>setSoft(p=>({...p,description:e.target.value}))} placeholder="Description"
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
        </div>
        <button onClick={() => addSoft.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-4"><Plus size={14}/>Add</button>
        {data?.soft?.map((s: { id: string; name: string; description: string }) => (
          <div key={s.id} className="flex items-center justify-between bg-navy-light rounded-lg px-4 py-3 mb-2">
            <span className="text-white">{s.name} <span className="text-gray-500">— {s.description}</span></span>
            <button onClick={() => delSoft.mutate(s.id)} className="text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </section>
    </div>
  );
}
EOF

cat > client/src/components/admin/AdminVision.tsx << 'EOF'
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
EOF

cat > client/src/components/admin/AdminResume.tsx << 'EOF'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getResume, deleteResume } from '../../api/resume';
import { FileText, Trash2 } from 'lucide-react';

export default function AdminResume() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['resume'], queryFn: getResume });
  const del = useMutation({ mutationFn: deleteResume, onSuccess: () => { qc.invalidateQueries({ queryKey: ['resume'] }); toast.success('Deleted'); } });

  return (
    <div className="max-w-xl">
      <h2 className="font-playfair text-2xl font-bold text-white mb-8">Resume</h2>
      {data?.resumeUrl ? (
        <div className="bg-navy-light rounded-xl border border-white/10 p-6 flex items-center justify-between">
          <div className="flex items-center gap-3"><FileText className="text-gold" size={24}/>
            <a href={data.resumeUrl} target="_blank" rel="noreferrer" className="text-white hover:text-gold transition-colors">View Current Resume</a>
          </div>
          <button onClick={() => del.mutate()} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={18}/></button>
        </div>
      ) : (
        <div className="bg-navy-light rounded-xl border border-white/10 p-8 text-center">
          <FileText className="text-gray-600 mx-auto mb-3" size={40}/>
          <p className="text-gray-500 mb-4">No resume uploaded yet.</p>
          <p className="text-gray-600 text-sm">Upload via the API or contact your developer to enable file uploads.</p>
        </div>
      )}
    </div>
  );
}
EOF

cat > client/src/components/admin/AdminContact.tsx << 'EOF'
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { getContact, createContact, deleteContact } from '../../api/contact';
import { ContactLink } from '../../types';
import { Trash2, Plus } from 'lucide-react';

const empty = { platform: '', icon: 'email', handle: '', url: '' };

export default function AdminContact() {
  const qc = useQueryClient();
  const { data } = useQuery({ queryKey: ['contact'], queryFn: getContact });
  const [form, setForm] = useState<Partial<ContactLink>>(empty);

  const add = useMutation({ mutationFn: () => createContact(form), onSuccess: () => { qc.invalidateQueries({ queryKey: ['contact'] }); toast.success('Added!'); setForm(empty); } });
  const del = useMutation({ mutationFn: deleteContact, onSuccess: () => { qc.invalidateQueries({ queryKey: ['contact'] }); toast.success('Deleted'); } });

  return (
    <div>
      <h2 className="font-playfair text-2xl font-bold text-white mb-8">Contact Links</h2>
      <div className="grid grid-cols-2 gap-3 mb-3">
        {(['platform','icon','handle','url'] as const).map(f => (
          <input key={f} value={form[f]||''} onChange={e=>setForm(p=>({...p,[f]:e.target.value}))} placeholder={f}
            className="bg-navy border border-white/10 rounded-lg px-4 py-3 text-white focus:border-gold focus:outline-none"/>
        ))}
      </div>
      <button onClick={() => add.mutate()} className="flex items-center gap-2 px-4 py-2 bg-gold text-navy rounded-lg text-sm font-semibold mb-6"><Plus size={14}/>Add Link</button>
      <div className="flex flex-col gap-3">
        {data?.map(c => (
          <div key={c.id} className="flex items-center justify-between bg-navy-light rounded-xl border border-white/5 px-6 py-4">
            <div><p className="text-white font-medium">{c.platform}</p><p className="text-gray-500 text-sm">{c.handle}</p></div>
            <button onClick={() => del.mutate(c.id)} className="p-2 text-gray-400 hover:text-red-400"><Trash2 size={16}/></button>
          </div>
        ))}
      </div>
    </div>
  );
}
EOF

cat > client/src/App.tsx << 'EOF'
import { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate, useNavigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { Toaster } from 'sonner';
import PortfolioPage from './pages/PortfolioPage';
import AdminLoginPage from './pages/AdminLoginPage';
import AdminDashboard from './pages/AdminDashboard';
import ProtectedRoute from './components/layout/ProtectedRoute';

const qc = new QueryClient({ defaultOptions: { queries: { staleTime: 5 * 60 * 1000 } } });

function KeyboardShortcut() {
  const navigate = useNavigate();
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.ctrlKey && e.shiftKey && e.key === 'A') navigate('/admin');
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [navigate]);
  return null;
}

export default function App() {
  return (
    <QueryClientProvider client={qc}>
      <BrowserRouter>
        <KeyboardShortcut />
        <Toaster position="top-right" theme="dark" />
        <Routes>
          <Route path="/" element={<PortfolioPage />} />
          <Route path="/admin/login" element={<AdminLoginPage />} />
          <Route path="/admin" element={<ProtectedRoute><AdminDashboard /></ProtectedRoute>} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </QueryClientProvider>
  );
}
EOF

echo ""
echo "✅ HAMMA FAYLLAR YARATILDI!"
echo ""
echo "Endi shu buyruqlarni bajaring:"
echo ""
echo "1. cd server && npm install"
echo "2. cd ../client && npm install"
echo "3. cp server/.env.example server/.env"
echo "   (keyin server/.env faylini oching va o'z ma'lumotlaringizni kiriting)"
echo ""
echo "🎉 Sayt tayyor!"
