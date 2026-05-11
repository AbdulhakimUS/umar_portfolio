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
