import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getProjects = async (_req: Request, res: Response): Promise<void> => { res.json(await prisma.project.findMany({ orderBy: { order: 'asc' } })); };
export const createProject = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.project.create({ data: req.body })); };
export const updateProject = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.project.update({ where: { id: String(req.params.id) }, data: req.body })); };
export const deleteProject = async (req: Request, res: Response): Promise<void> => { await prisma.project.delete({ where: { id: String(req.params.id) } }); res.json({ message: 'Deleted' }); };
export const reorderProjects = async (req: Request, res: Response): Promise<void> => {
  const items: { id: string; order: number }[] = req.body;
  await Promise.all(items.map(i => prisma.project.update({ where: { id: i.id }, data: { order: i.order } })));
  res.json({ message: 'Reordered' });
};
