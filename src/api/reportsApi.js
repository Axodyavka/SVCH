import api from './axiosConfig';

export const reportsApi = {
  getAll: (params) => api.get('/reports', { params }).then((r) => r.data),
  getById: (id) => api.get(`/reports/${id}`).then((r) => r.data),
  getRecent: () => api.get('/reports/recent').then((r) => r.data),
  getProgress: (params) => api.get('/reports/progress', { params }).then((r) => r.data),
};
