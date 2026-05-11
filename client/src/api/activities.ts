import api from './axios';
import { ECActivity } from '../types';
export const getActivities = (): Promise<ECActivity[]> => api.get('/activities').then(r => r.data);
export const createActivity = (data: Partial<ECActivity>) => api.post('/activities', data).then(r => r.data);
export const updateActivity = (id: string, data: Partial<ECActivity>) => api.put(`/activities/${id}`, data).then(r => r.data);
export const deleteActivity = (id: string) => api.delete(`/activities/${id}`);
export const reorderActivities = (items: { id: string; order: number }[]) => api.patch('/activities/reorder', items);
