import api from './axios';
import { Vision } from '../types';
export const getVision = (): Promise<Vision> => api.get('/vision').then(r => r.data);
export const updateVision = (data: Partial<Vision>) => api.put('/vision', data).then(r => r.data);
