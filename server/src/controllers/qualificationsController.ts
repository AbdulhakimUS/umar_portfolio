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
export const updateExam = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.exam.update({ where: { id: String(req.params.id) }, data: req.body })); };
export const deleteExam = async (req: Request, res: Response): Promise<void> => { await prisma.exam.delete({ where: { id: String(req.params.id) } }); res.json({ message: 'Deleted' }); };
export const createCertification = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.certification.create({ data: req.body })); };
export const updateCertification = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.certification.update({ where: { id: String(req.params.id) }, data: req.body })); };
export const deleteCertification = async (req: Request, res: Response): Promise<void> => { await prisma.certification.delete({ where: { id: String(req.params.id) } }); res.json({ message: 'Deleted' }); };
