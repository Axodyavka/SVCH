import { useState, useEffect } from 'react';
import { adminApi } from '../api/adminApi';

export default function AdminPage() {
  const [stats, setStats] = useState(null);
  const [users, setUsers] = useState([]);
  const [suggestions, setSuggestions] = useState([]);
  const [search, setSearch] = useState('');
  const [message, setMessage] = useState('');

  const load = async () => {
    try {
      const [statsData, usersData, suggestionsData] = await Promise.all([
        adminApi.getStats(),
        adminApi.getUsers({ search }),
        adminApi.getSuggestions(),
      ]);
      setStats(statsData);
      setUsers(usersData);
      setSuggestions(suggestionsData);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    load();
  }, [search]);

  const handleBlock = async (id, blocked) => {
    if (blocked) await adminApi.unblockUser(id);
    else await adminApi.blockUser(id);
    load();
  };

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
        <h2>Пользователи</h2>
        <input
          type="search"
          placeholder="Поиск…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="search-input"
        />
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr>
                <th>Логин</th>
                <th>Email</th>
                <th>Роль</th>
                <th>Статус</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {users.map((u) => (
                <tr key={u.id}>
                  <td>{u.login}</td>
                  <td>{u.email}</td>
                  <td>{u.role}</td>
                  <td>{u.status}</td>
                  <td>
                    {u.role !== 'admin' && (
                      <button
                        type="button"
                        className="btn btn-outline btn-sm"
                        onClick={() => handleBlock(u.id, u.status === 'blocked')}
                      >
                        {u.status === 'blocked' ? 'Разблок.' : 'Блок.'}
                      </button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

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
                  <th>Композитор</th>
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
                    <td>{s.user?.login}</td>
                    <td>{s.status}</td>
                    <td>
                      {s.status === 'pending' && (
                        <button type="button" className="btn btn-primary btn-sm" onClick={() => handleApprove(s.id)}>
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
