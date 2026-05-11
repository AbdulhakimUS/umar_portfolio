import api from './axios';
export const getQualifications = () => api.get('/qualifications').then(r => r.data);
export const updateSchool = (data: object) => api.put('/qualifications/school', data).then(r => r.data);
export const createExam = (data: object) => api.post('/qualifications/exams', data).then(r => r.data);
export const updateExam = (id: string, data: object) => api.put(`/qualifications/exams/${id}`, data).then(r => r.data);
export const deleteExam = (id: string) => api.delete(`/qualifications/exams/${id}`);
export const createCertification = (data: object) => api.post('/qualifications/certifications', data).then(r => r.data);
export const updateCertification = (id: string, data: object) => api.put(`/qualifications/certifications/${id}`, data).then(r => r.data);
export const deleteCertification = (id: string) => api.delete(`/qualifications/certifications/${id}`);
