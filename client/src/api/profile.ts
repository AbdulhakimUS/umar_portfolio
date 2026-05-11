import api from './axios';
import { Profile } from '../types';
export const getProfile = (): Promise<Profile> => api.get('/profile').then(r => r.data);
export const updateProfile = (data: Partial<Profile>) => api.put('/profile', data).then(r => r.data);
