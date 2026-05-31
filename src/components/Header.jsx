import { Link, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { logout } from '../store/slices/authSlice';
import { toggleTheme } from '../store/slices/uiSlice';
import NotificationBell from './NotificationBell';

function Header() {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const isAdmin = user?.role === 'admin';

  const handleLogout = () => {
    dispatch(logout());
    navigate('/login');
  };

  const logoTitle = isAdmin ? 'Music Platform Admin' : 'Music Platform';

  return (
    <header className="header">
      <div className="header-inner">
        <Link to="/" className="logo">
          {logoTitle}
        </Link>
        <nav className="nav">
          <Link to="/library">Библиотека</Link>
          {isAuthenticated && (
            <>
              {!isAdmin && (
                <>
                  <Link to="/upload">Загрузка</Link>
                  <Link to="/progress">Прогресс</Link>
                </>
              )}
            </>
          )}
        </nav>
        <div className="header-actions">
          {isAuthenticated && !isAdmin && <NotificationBell />}
          <button type="button" className="btn btn-outline" onClick={() => dispatch(toggleTheme())}>
            Сменить тему
          </button>
          {isAuthenticated ? (
            <>
              {!isAdmin && (
                <Link to="/profile" className="user-link">
                  {user?.login}
                </Link>
              )}
              {isAdmin && <span className="user-link">Администратор: {user?.login}</span>}
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
