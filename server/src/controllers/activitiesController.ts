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
  const { id } = req.params;
  const activity = await prisma.eCActivity.update({ where: { id: String(id) }, data: req.body });
  res.json(activity);
};
export const deleteActivity = async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;
  await prisma.eCActivity.delete({ where: { id: String(id) } });
  res.json({ message: 'Deleted' });
};
export const reorderActivities = async (req: Request, res: Response): Promise<void> => {
  const items: { id: string; order: number }[] = req.body;
  await Promise.all(items.map(i => prisma.eCActivity.update({ where: { id: i.id }, data: { order: i.order } })));
  res.json({ message: 'Reordered' });
};
