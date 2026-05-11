import api from './axios';
import { ContactLink } from '../types';
export const getContact = (): Promise<ContactLink[]> => api.get('/contact').then(r => r.data);
export const createContact = (data: Partial<ContactLink>) => api.post('/contact', data).then(r => r.data);
export const updateContact = (id: string, data: Partial<ContactLink>) => api.put(`/contact/${id}`, data).then(r => r.data);
export const deleteContact = (id: string) => api.delete(`/contact/${id}`);
