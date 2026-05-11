import { Router } from 'express';
import { getVision, updateVision } from '../controllers/visionController';
import { authenticateToken } from '../middleware/authenticateToken';
const router = Router();
router.get('/', getVision);
router.put('/', authenticateToken, updateVision);
export default router;
