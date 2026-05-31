import { Link, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { logout } from '../store/slices/authSlice';
import { toggleTheme } from '../store/slices/uiSlice';
import NotificationBell from './NotificationBell';

function Header() {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const theme = useSelector((state) => state.ui.theme);

  const handleLogout = () => {
    dispatch(logout());
    navigate('/login');
  };

  return (
    <header className="header">
      <div className="header-inner">
        <Link to="/" className="logo">
          Music Platform
        </Link>
        <nav className="nav">
          <Link to="/library">Библиотека</Link>
          {isAuthenticated && (
            <>
              <Link to="/upload">Загрузка</Link>
              <Link to="/progress">Прогресс</Link>
              {user?.role === 'admin' && <Link to="/admin">Админ</Link>}
            </>
          )}
        </nav>
        <div className="header-actions">
          {isAuthenticated && <NotificationBell />}
          <button type="button" className="btn-icon" onClick={() => dispatch(toggleTheme())} title="Сменить тему">
            {theme === 'light' ? '🌙' : '☀️'}
          </button>
          {isAuthenticated ? (
            <>
              <Link to="/profile" className="user-link">
                {user?.login}
              </Link>
              <button type="button" className="btn btn-outline" onClick={handleLogout}>
                Выход
              </button>
            </>
          ) : (
            <>
              <Link to="/login" className="btn btn-outline">
                Вход
              </Link>
              <Link to="/register" className="btn btn-primary">
                Регистрация
              </Link>
            </>
          )}
        </div>
      </div>
    </header>
  );
}

export default Header;
