import { Request, Response, NextFunction } from 'express';
export const authLimiter = (_req: Request, _res: Response, next: NextFunction) => next();
