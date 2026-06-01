import api from './axiosConfig';

export const achievementsApi = {
  getAll: () => api.get('/achievements').then((r) => r.data),
};
