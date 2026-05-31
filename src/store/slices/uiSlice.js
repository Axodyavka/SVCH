import { createSlice } from '@reduxjs/toolkit';

const savedTheme = localStorage.getItem('theme') || 'light';

const initialState = {
  theme: savedTheme,
};

const uiSlice = createSlice({
  name: 'ui',
  initialState,
  reducers: {
    toggleTheme(state) {
      state.theme = state.theme === 'light' ? 'dark' : 'light';
      localStorage.setItem('theme', state.theme);
      document.documentElement.setAttribute('data-theme', state.theme);
    },
    setTheme(state, action) {
      state.theme = action.payload;
      localStorage.setItem('theme', state.theme);
      document.documentElement.setAttribute('data-theme', state.theme);
    },
  },
});

export const { toggleTheme, setTheme } = uiSlice.actions;
export default uiSlice.reducer;
