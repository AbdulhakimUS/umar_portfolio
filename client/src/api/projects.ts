import api from './axios';
import { Project } from '../types';
export const getProjects = (): Promise<Project[]> => api.get('/projects').then(r => r.data);
export const createProject = (data: Partial<Project>) => api.post('/projects', data).then(r => r.data);
export const updateProject = (id: string, data: Partial<Project>) => api.put(`/projects/${id}`, data).then(r => r.data);
export const deleteProject = (id: string) => api.delete(`/projects/${id}`);
