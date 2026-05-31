import { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { compositionsApi } from '../api/compositionsApi';

const INSTRUMENTS = [
  { value: '', label: 'Все инструменты' },
  { value: 'piano', label: 'Фортепиано' },
  { value: 'violin', label: 'Скрипка' },
  { value: 'guitar', label: 'Гитара' },
  { value: 'flute', label: 'Флейта' },
];

export default function LibraryPage() {
  const { isAuthenticated } = useSelector((state) => state.auth);
  const [compositions, setCompositions] = useState([]);
  const [search, setSearch] = useState('');
  const [instrument, setInstrument] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [suggestForm, setSuggestForm] = useState({ title: '', composer: '' });
  const [suggestMsg, setSuggestMsg] = useState('');

  useEffect(() => {
    const load = async () => {
      try {
        setLoading(true);
        const data = await compositionsApi.getAll({ search, instrument });
        setCompositions(data);
      } catch (e) {
        setError('Не удалось загрузить библиотеку');
      } finally {
        setLoading(false);
      }
    };
    const timer = setTimeout(load, 300);
    return () => clearTimeout(timer);
  }, [search, instrument]);

  const handleSuggest = async (e) => {
    e.preventDefault();
    setSuggestMsg('');
    try {
      await compositionsApi.suggest(suggestForm);
      setSuggestForm({ title: '', composer: '' });
      setSuggestMsg('Предложение отправлено администратору');
    } catch (err) {
      setSuggestMsg(err.response?.data?.message || 'Ошибка отправки');
    }
  };

  return (
    <div className="page">
      <h1>Библиотека произведений</h1>

      <div className="filters">
        <input
          type="search"
          placeholder="Поиск по названию или композитору…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="search-input"
        />
        <select value={instrument} onChange={(e) => setInstrument(e.target.value)}>
          {INSTRUMENTS.map((opt) => (
            <option key={opt.value} value={opt.value}>
              {opt.label}
            </option>
          ))}
        </select>
      </div>

      {loading && <p>Загрузка…</p>}
      {error && <p className="error-text">{error}</p>}

      {!loading && compositions.length === 0 && (
        <p className="empty-text">Произведения не найдены</p>
      )}

      <div className="card-grid">
        {compositions.map((c) => (
          <article key={c.id} className="card">
            <h3>{c.title}</h3>
            <p className="text-muted">{c.composer}</p>
            <div className="card-tags">
              <span className="tag">{c.instrument}</span>
              <span className="tag">{c.difficulty}</span>
            </div>
          </article>
        ))}
      </div>

      {isAuthenticated && (
        <section className="section suggest-section">
          <h2>Предложить произведение</h2>
          <form onSubmit={handleSuggest} className="inline-form">
            <input
              placeholder="Название"
              value={suggestForm.title}
              onChange={(e) => setSuggestForm((p) => ({ ...p, title: e.target.value }))}
              required
            />
            <input
              placeholder="Композитор"
              value={suggestForm.composer}
              onChange={(e) => setSuggestForm((p) => ({ ...p, composer: e.target.value }))}
              required
            />
            <button type="submit" className="btn btn-primary">
              Отправить
            </button>
          </form>
          {suggestMsg && <p className="success-text">{suggestMsg}</p>}
        </section>
      )}
    </div>
  );
}
