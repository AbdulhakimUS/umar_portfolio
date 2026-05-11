import api from './axios';
export const getResume = () => api.get('/resume').then(r => r.data);
export const deleteResume = () => api.delete('/resume');
