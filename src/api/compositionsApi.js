import api from './axiosConfig';

export const compositionsApi = {
  getAll: (params) => api.get('/compositions', { params }).then((r) => r.data),
  getById: (id) => api.get(`/compositions/${id}`).then((r) => r.data),
  create: (data) => api.post('/compositions', data).then((r) => r.data),
  update: (id, data) => api.put(`/compositions/${id}`, data).then((r) => r.data),
  remove: (id) => api.delete(`/compositions/${id}`).then((r) => r.data),
  suggest: (data) => api.post('/compositions/suggest', data).then((r) => r.data),
};
