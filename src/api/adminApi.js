import api from './axiosConfig';

export const adminApi = {
  getStats: () => api.get('/admin/stats').then((r) => r.data),
  getUsers: (params) => api.get('/admin/users', { params }).then((r) => r.data),
  blockUser: (id) => api.put(`/admin/users/${id}/block`).then((r) => r.data),
  unblockUser: (id) => api.put(`/admin/users/${id}/unblock`).then((r) => r.data),
  getSuggestions: () => api.get('/admin/suggestions').then((r) => r.data),
  approveSuggestion: (id) => api.put(`/admin/suggestions/${id}/approve`).then((r) => r.data),
};
