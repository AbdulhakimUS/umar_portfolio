import api from './axios';
export const getSkills = () => api.get('/skills').then(r => r.data);
export const createHardSkill = (data: object) => api.post('/skills/hard', data).then(r => r.data);
export const updateHardSkill = (id: string, data: object) => api.put(`/skills/hard/${id}`, data).then(r => r.data);
export const deleteHardSkill = (id: string) => api.delete(`/skills/hard/${id}`);
export const createSoftSkill = (data: object) => api.post('/skills/soft', data).then(r => r.data);
export const updateSoftSkill = (id: string, data: object) => api.put(`/skills/soft/${id}`, data).then(r => r.data);
export const deleteSoftSkill = (id: string) => api.delete(`/skills/soft/${id}`);
