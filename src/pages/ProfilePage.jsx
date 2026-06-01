import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { authApi } from '../api/authApi';
import { achievementsApi } from '../api/achievementsApi';
import { setUser } from '../store/slices/authSlice';

export default function ProfilePage() {
  const dispatch = useDispatch();
  const { user } = useSelector((state) => state.auth);
  const [profile, setProfile] = useState({
    login: user?.login || '',
    email: user?.email || '',
    instrument: user?.instrument || '',
    level: user?.level || '',
  });
  const [passwords, setPasswords] = useState({ currentPassword: '', newPassword: '' });
  const [achievements, setAchievements] = useState([]);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    achievementsApi
      .getAll()
      .then(setAchievements)
      .catch(() => setError('Не удалось загрузить достижения'));
  }, []);

  const handleProfileSave = async (e) => {
    e.preventDefault();
    setMessage('');
    setError('');
    try {
      const data = await authApi.updateProfile(profile);
      dispatch(setUser(data.user));
      setMessage('Профиль сохранён');
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка сохранения');
    }
  };

  const handlePasswordChange = async (e) => {
    e.preventDefault();
    setMessage('');
    setError('');
    try {
      await authApi.changePassword(passwords);
      setPasswords({ currentPassword: '', newPassword: '' });
      setMessage('Пароль изменён');
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка смены пароля');
    }
  };

  return (
    <div className="page">
      <h1>Профиль</h1>

      <form onSubmit={handleProfileSave} className="form-card">
        <h2>Данные пользователя</h2>
        <div className="form-group">
          <label htmlFor="login">Логин</label>
          <input
            id="login"
            value={profile.login}
            onChange={(e) => setProfile((p) => ({ ...p, login: e.target.value }))}
          />
        </div>
        <div className="form-group">
          <label htmlFor="email">Email</label>
          <input
            id="email"
            type="email"
            value={profile.email}
            onChange={(e) => setProfile((p) => ({ ...p, email: e.target.value }))}
          />
        </div>
        <div className="form-group">
          <label htmlFor="instrument">Инструмент</label>
          <select
            id="instrument"
            value={profile.instrument}
            onChange={(e) => setProfile((p) => ({ ...p, instrument: e.target.value }))}
          >
            <option value="">—</option>
            <option value="piano">Фортепиано</option>
            <option value="violin">Скрипка</option>
            <option value="guitar">Гитара</option>
            <option value="flute">Флейта</option>
          </select>
        </div>
        <div className="form-group">
          <label htmlFor="level">Уровень</label>
          <select
            id="level"
            value={profile.level}
            onChange={(e) => setProfile((p) => ({ ...p, level: e.target.value }))}
          >
            <option value="">—</option>
            <option value="beginner">Начинающий</option>
            <option value="intermediate">Средний</option>
            <option value="advanced">Продвинутый</option>
          </select>
        </div>
        <button type="submit" className="btn btn-primary">
          Сохранить
        </button>
      </form>

      <form onSubmit={handlePasswordChange} className="form-card">
        <h2>Смена пароля</h2>
        <div className="form-group">
          <label htmlFor="current">Текущий пароль</label>
          <input
            id="current"
            type="password"
            value={passwords.currentPassword}
            onChange={(e) => setPasswords((p) => ({ ...p, currentPassword: e.target.value }))}
          />
        </div>
        <div className="form-group">
          <label htmlFor="new">Новый пароль</label>
          <input
            id="new"
            type="password"
            value={passwords.newPassword}
            onChange={(e) => setPasswords((p) => ({ ...p, newPassword: e.target.value }))}
            minLength={6}
          />
        </div>
        <button type="submit" className="btn btn-outline">
          Изменить пароль
        </button>
      </form>

      <section className="section">
        <h2>Достижения</h2>
        {achievements.length === 0 ? (
          <p className="empty-text">Достижения появятся после первых занятий.</p>
        ) : (
          <div className="achievement-grid">
            {achievements.map((achievement) => {
              const percent = Math.min(100, Math.round((achievement.progress / achievement.target) * 100));
              return (
                <article
                  key={achievement.code}
                  className={`card achievement-card ${achievement.isEarned ? 'earned' : ''}`}
                >
                  <div className="achievement-header">
                    <h3>{achievement.title}</h3>
                    <span className="tag">{achievement.isEarned ? 'получено' : `${percent}%`}</span>
                  </div>
                  <p className="text-muted">{achievement.description}</p>
                  <div className="progress-bar" aria-label={`Прогресс ${achievement.title}`}>
                    <span style={{ width: `${percent}%` }} />
                  </div>
                  <small className="text-muted">
                    {achievement.isEarned
                      ? `Получено: ${new Date(achievement.earned_at).toLocaleDateString('ru-RU')}`
                      : `${achievement.progress} из ${achievement.target}`}
                  </small>
                </article>
              );
            })}
          </div>
        )}
      </section>

      {message && <p className="success-text">{message}</p>}
      {error && <p className="error-text">{error}</p>}
    </div>
  );
}
