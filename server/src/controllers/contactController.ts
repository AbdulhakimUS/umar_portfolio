import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getContact = async (_req: Request, res: Response): Promise<void> => { res.json(await prisma.contactLink.findMany({ orderBy: { order: 'asc' } })); };
export const createContact = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.contactLink.create({ data: req.body })); };
export const updateContact = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.contactLink.update({ where: { id: String(req.params.id) }, data: req.body })); };
export const deleteContact = async (req: Request, res: Response): Promise<void> => { await prisma.contactLink.delete({ where: { id: String(req.params.id) } }); res.json({ message: 'Deleted' }); };
export const reorderContact = async (req: Request, res: Response): Promise<void> => {
  const items: { id: string; order: number }[] = req.body;
  await Promise.all(items.map(i => prisma.contactLink.update({ where: { id: i.id }, data: { order: i.order } })));
  res.json({ message: 'Reordered' });
};
