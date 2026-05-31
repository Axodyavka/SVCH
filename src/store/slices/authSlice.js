import { createSlice } from '@reduxjs/toolkit';

const token = localStorage.getItem('token');
const userJson = localStorage.getItem('user');

const initialState = {
  user: userJson ? JSON.parse(userJson) : null,
  token: token || null,
  isAuthenticated: Boolean(token),
};

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setCredentials(state, action) {
      state.user = action.payload.user;
      state.token = action.payload.token;
      state.isAuthenticated = true;
      localStorage.setItem('token', action.payload.token);
      localStorage.setItem('user', JSON.stringify(action.payload.user));
    },
    logout(state) {
      state.user = null;
      state.token = null;
      state.isAuthenticated = false;
      localStorage.removeItem('token');
      localStorage.removeItem('user');
    },
    setUser(state, action) {
      state.user = action.payload;
      localStorage.setItem('user', JSON.stringify(action.payload));
    },
  },
});

export const { setCredentials, logout, setUser } = authSlice.actions;
export default authSlice.reducer;
