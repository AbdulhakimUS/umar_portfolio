import api from './axios';
export const login = (username: string, password: string) => api.post('/auth/login', { username, password }).then(r => r.data);
export const logout = () => api.post('/auth/logout');
