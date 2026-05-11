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
