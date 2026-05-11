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
