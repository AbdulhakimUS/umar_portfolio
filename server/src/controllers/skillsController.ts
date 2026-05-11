import { Request, Response } from 'express';
import { prisma } from '../utils/prisma';

export const getSkills = async (_req: Request, res: Response): Promise<void> => {
  const [hard, soft] = await Promise.all([prisma.hardSkill.findMany(), prisma.softSkill.findMany()]);
  res.json({ hard, soft });
};
export const createHard = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.hardSkill.create({ data: req.body })); };
export const updateHard = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.hardSkill.update({ where: { id: String(req.params.id) }, data: req.body })); };
export const deleteHard = async (req: Request, res: Response): Promise<void> => { await prisma.hardSkill.delete({ where: { id: String(req.params.id) } }); res.json({ message: 'Deleted' }); };
export const createSoft = async (req: Request, res: Response): Promise<void> => { res.status(201).json(await prisma.softSkill.create({ data: req.body })); };
export const updateSoft = async (req: Request, res: Response): Promise<void> => { res.json(await prisma.softSkill.update({ where: { id: String(req.params.id) }, data: req.body })); };
export const deleteSoft = async (req: Request, res: Response): Promise<void> => { await prisma.softSkill.delete({ where: { id: String(req.params.id) } }); res.json({ message: 'Deleted' }); };
