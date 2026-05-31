import api from './axiosConfig';

export const reportsApi = {
  getAll: (params) => api.get('/reports', { params }).then((r) => r.data),
  getById: (id) => api.get(`/reports/${id}`).then((r) => r.data),
  getRecent: () => api.get('/reports/recent').then((r) => r.data),
  getProgress: () => api.get('/reports/progress').then((r) => r.data),
};
