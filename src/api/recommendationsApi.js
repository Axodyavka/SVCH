import api from './axiosConfig';

export const recommendationsApi = {
  getAll: () => api.get('/recommendations').then((r) => r.data),
};
