import { Link, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { logout } from '../store/slices/authSlice';
import { setTheme, toggleTheme } from '../store/slices/uiSlice';
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

  const handleResetSettings = () => {
    localStorage.removeItem('reportSort');
    localStorage.removeItem('reportDateFrom');
    localStorage.removeItem('reportDateTo');
    localStorage.removeItem('reportPage');
    localStorage.removeItem('librarySearch');
    localStorage.removeItem('libraryInstrument');
    localStorage.removeItem('librarySort');
    localStorage.removeItem('libraryPage');
    dispatch(setTheme('light'));
    window.dispatchEvent(new Event('app-settings-reset'));
  };

  const logoTitle = isAdmin ? 'Music Platform Admin' : 'Music Platform';

  return (
    <header className="header">
      <div className="header-inner">
        <Link to={isAdmin ? '/library' : '/'} className="logo">
          {logoTitle}
        </Link>
        <nav className="nav">
          <Link to="/library">Библиотека</Link>
          {isAuthenticated && (
            <>
              {!isAdmin && (
                <>
                  <Link to="/upload">Загрузка</Link>
                  <Link to="/suggest">Предложить</Link>
                  <Link to="/progress">Прогресс</Link>
                </>
              )}
            </>
          )}
        </nav>
        <div className="header-actions">
          {isAuthenticated && !isAdmin && <NotificationBell />}
          <button
            type="button"
            className="btn btn-outline icon-btn theme-toggle"
            onClick={() => dispatch(toggleTheme())}
            title="Сменить тему"
            aria-label="Сменить тему"
          >
            <span className="asset-icon theme-icon" aria-hidden="true" />
          </button>
          <button
            type="button"
            className="btn btn-outline icon-btn"
            onClick={handleResetSettings}
            title="Сбросить настройки интерфейса"
            aria-label="Сбросить настройки интерфейса"
          >
            <span className="asset-icon reset-icon" aria-hidden="true" />
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
