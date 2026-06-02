import api from './axiosConfig';

export const adminApi = {
  getStats: () => api.get('/admin/stats').then((r) => r.data),
  getSuggestions: () => api.get('/admin/suggestions').then((r) => r.data),
  suggestionFileUrl: (id, kind) => `/api/admin/suggestions/${id}/files/${kind}`,
  getSuggestionFile: (id, kind) =>
    api.get(`/admin/suggestions/${id}/files/${kind}`, { responseType: 'blob' }).then((r) => r.data),
  approveSuggestion: (id) => api.put(`/admin/suggestions/${id}/approve`).then((r) => r.data),
  rejectSuggestion: (id) => api.put(`/admin/suggestions/${id}/reject`).then((r) => r.data),
};
