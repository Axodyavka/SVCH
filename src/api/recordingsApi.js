import api from './axiosConfig';

export const recordingsApi = {
  getAll: () => api.get('/recordings').then((r) => r.data),
  upload: (formData) =>
    api.post('/recordings', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    }).then((r) => r.data),
};
