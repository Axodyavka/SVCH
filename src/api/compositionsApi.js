import api from './axiosConfig';

export const compositionsApi = {
  getAll: (params) => api.get('/compositions', { params }).then((r) => r.data),
  getById: (id) => api.get(`/compositions/${id}`).then((r) => r.data),
  create: (formData) =>
    api
      .post('/compositions', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
      .then((r) => r.data),
  update: (id, formData) =>
    api
      .put(`/compositions/${id}`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
      .then((r) => r.data),
  remove: (id) => api.delete(`/compositions/${id}`).then((r) => r.data),
  fileUrl: (id, kind) => `/api/compositions/${id}/files/${kind}`,
  suggest: (data) => api.post('/compositions/suggest', data).then((r) => r.data),
};
