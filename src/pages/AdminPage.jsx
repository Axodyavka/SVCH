import { useState, useEffect } from 'react';
import { adminApi } from '../api/adminApi';

export default function AdminPage() {
  const [stats, setStats] = useState(null);
  const [suggestions, setSuggestions] = useState([]);
  const [message, setMessage] = useState('');

  const load = async () => {
    try {
      const [statsData, suggestionsData] = await Promise.all([
        adminApi.getStats(),
        adminApi.getSuggestions(),
      ]);
      setStats(statsData);
      setSuggestions(suggestionsData);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    load();
  }, []);

  const handleApprove = async (id) => {
    await adminApi.approveSuggestion(id);
    setMessage('Произведение добавлено');
    load();
  };

  return (
    <div className="page">
      <h1>Админ-панель</h1>

      {stats && (
        <div className="stats-grid">
          <div className="card stat-card">
            <strong>{stats.users}</strong>
            <span>Пользователей</span>
          </div>
          <div className="card stat-card">
            <strong>{stats.recordings}</strong>
            <span>Записей</span>
          </div>
          <div className="card stat-card">
            <strong>{stats.reports}</strong>
            <span>Отчётов</span>
          </div>
          <div className="card stat-card">
            <strong>{stats.pendingSuggestions}</strong>
            <span>Ожидают</span>
          </div>
        </div>
      )}

      {message && <p className="success-text">{message}</p>}

      <section className="section">
        <h2>Предложения произведений</h2>
        {suggestions.length === 0 ? (
          <p className="empty-text">Нет предложений</p>
        ) : (
          <div className="table-wrap">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Название</th>
                  <th>Автор</th>
                  <th>Статус</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {suggestions.map((s) => (
                  <tr key={s.id}>
                    <td>{s.title}</td>
                    <td>{s.composer}</td>
                    <td>{s.status}</td>
                    <td>
                      {s.status === 'pending' && (
                        <button
                          type="button"
                          className="btn btn-primary btn-sm"
                          onClick={() => handleApprove(s.id)}
                        >
                          Одобрить
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </div>
  );
}
