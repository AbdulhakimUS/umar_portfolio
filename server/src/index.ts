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
const PORT = process.env.PORT || 4000;

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
