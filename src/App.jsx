import { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import Header from './components/Header';
import Footer from './components/Footer';
import PrivateRoute from './components/PrivateRoute';
import DashboardPage from './pages/DashboardPage';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import LibraryPage from './pages/LibraryPage';
import UploadPage from './pages/UploadPage';
import ReportPage from './pages/ReportPage';
import ProgressPage from './pages/ProgressPage';
import ProfilePage from './pages/ProfilePage';
import NotFoundPage from './pages/NotFoundPage';
import { setTheme } from './store/slices/uiSlice';

function HomePage() {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  if (isAuthenticated && user?.role === 'admin') {
    return <Navigate to="/library" replace />;
  }
  return <DashboardPage />;
}

function App() {
  const dispatch = useDispatch();
  const theme = useSelector((state) => state.ui.theme);

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
  }, [theme]);

  useEffect(() => {
    dispatch(setTheme(localStorage.getItem('theme') || 'light'));
  }, [dispatch]);

  return (
    <div className="app">
      <Header />
      <main className="main-content">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route path="/library" element={<LibraryPage />} />
          <Route
            path="/upload"
            element={
              <PrivateRoute musicianOnly>
                <UploadPage />
              </PrivateRoute>
            }
          />
          <Route
            path="/reports/:id"
            element={
              <PrivateRoute musicianOnly>
                <ReportPage />
              </PrivateRoute>
            }
          />
          <Route
            path="/progress"
            element={
              <PrivateRoute musicianOnly>
                <ProgressPage />
              </PrivateRoute>
            }
          />
          <Route
            path="/profile"
            element={
              <PrivateRoute musicianOnly>
                <ProfilePage />
              </PrivateRoute>
            }
          />
          <Route path="*" element={<NotFoundPage />} />
        </Routes>
      </main>
      <Footer />
    </div>
  );
}

export default App;
