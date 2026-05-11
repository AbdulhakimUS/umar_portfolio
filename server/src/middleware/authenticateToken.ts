import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken } from '../utils/jwt';

export interface AuthRequest extends Request {
  user?: { userId: string };
}

export const authenticateToken = (req: AuthRequest, res: Response, next: NextFunction): void => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) { res.status(401).json({ message: 'No token' }); return; }
  try {
    const payload = verifyAccessToken(token) as { userId: string };
    req.user = payload;
    next();
  } catch {
    res.status(403).json({ message: 'Invalid token' });
  }
};
