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
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const isAdmin = user?.role === 'admin';

  const [compositions, setCompositions] = useState([]);
  const [search, setSearch] = useState('');
  const [instrument, setInstrument] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [suggestForm, setSuggestForm] = useState({ title: '', composer: '' });
  const [suggestMsg, setSuggestMsg] = useState('');
  const [adminForm, setAdminForm] = useState({
    title: '',
    composer: '',
    instrument: 'piano',
    difficulty: 'easy',
    midi_path: '',
    sheet_notes: '',
  });
  const [editingId, setEditingId] = useState(null);
  const [referenceFiles, setReferenceFiles] = useState({});

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

  useEffect(() => {
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

  const handleAdminSubmit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      if (editingId) {
        await compositionsApi.update(editingId, adminForm);
        setSuggestMsg('Произведение обновлено');
      } else {
        await compositionsApi.create(adminForm);
        setSuggestMsg('Произведение добавлено');
      }
      setEditingId(null);
      setAdminForm({
        title: '',
        composer: '',
        instrument: 'piano',
        difficulty: 'easy',
        midi_path: '',
        sheet_notes: '',
      });
      load();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка сохранения');
    }
  };

  const handleEdit = (composition) => {
    setEditingId(composition.id);
    setAdminForm({
      title: composition.title,
      composer: composition.composer,
      instrument: composition.instrument,
      difficulty: composition.difficulty,
      midi_path: composition.midi_path || '',
      sheet_notes: composition.sheet_notes || '',
    });
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Удалить произведение из библиотеки?')) return;
    try {
      await compositionsApi.remove(id);
      setSuggestMsg('Произведение удалено');
      load();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка удаления');
    }
  };

  const handleReferenceUpload = async (compositionId) => {
    const file = referenceFiles[compositionId];
    if (!file) return;
    try {
      const formData = new FormData();
      formData.append('audio', file);
      await compositionsApi.uploadReferenceAudio(compositionId, formData);
      setSuggestMsg('Эталонное аудио загружено');
      setReferenceFiles((prev) => ({ ...prev, [compositionId]: null }));
      load();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка загрузки эталонного аудио');
    }
  };

  return (
    <div className="page">
      <h1>Библиотека произведений</h1>

      {isAdmin && (
        <section className="section admin-library-form">
          <h2>{editingId ? 'Редактировать произведение' : 'Добавить произведение или упражнение'}</h2>
          <form onSubmit={handleAdminSubmit} className="inline-form">
            <input
              placeholder="Название"
              value={adminForm.title}
              onChange={(e) => setAdminForm((p) => ({ ...p, title: e.target.value }))}
              required
            />
            <input
              placeholder="Автор / источник"
              value={adminForm.composer}
              onChange={(e) => setAdminForm((p) => ({ ...p, composer: e.target.value }))}
              required
            />
            <select
              value={adminForm.instrument}
              onChange={(e) => setAdminForm((p) => ({ ...p, instrument: e.target.value }))}
            >
              {INSTRUMENTS.filter((x) => x.value).map((opt) => (
                <option key={opt.value} value={opt.value}>
                  {opt.label}
                </option>
              ))}
            </select>
            <select
              value={adminForm.difficulty}
              onChange={(e) => setAdminForm((p) => ({ ...p, difficulty: e.target.value }))}
            >
              <option value="easy">Легкий</option>
              <option value="medium">Средний</option>
              <option value="hard">Сложный</option>
            </select>
            <input
              placeholder="Путь к MIDI (например uploads/midi/c-major.mid)"
              value={adminForm.midi_path}
              onChange={(e) => setAdminForm((p) => ({ ...p, midi_path: e.target.value }))}
            />
            <button type="submit" className="btn btn-primary">
              {editingId ? 'Сохранить изменения' : 'Добавить'}
            </button>
            {editingId && (
              <button
                type="button"
                className="btn btn-outline"
                onClick={() => {
                  setEditingId(null);
                  setAdminForm({
                    title: '',
                    composer: '',
                    instrument: 'piano',
                    difficulty: 'easy',
                    midi_path: '',
                    sheet_notes: '',
                  });
                }}
              >
                Отменить
              </button>
            )}
          </form>
          <div className="section">
            <textarea
              className="notes-textarea"
              placeholder="Текст нот или описание упражнения (например: гамма до мажор в 2 октавы, метроном 60)"
              value={adminForm.sheet_notes}
              onChange={(e) => setAdminForm((p) => ({ ...p, sheet_notes: e.target.value }))}
            />
          </div>
          <p className="text-muted">
            MIDI нужен для сравнения записей пользователей. Эталонное аудио помогает показать, как должен звучать материал.
          </p>
        </section>
      )}

      <div className="filters">
        <input
          type="search"
          placeholder="Поиск по названию или композитору"
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

      {loading && <p>Загрузка...</p>}
      {error && <p className="error-text">{error}</p>}
      {suggestMsg && <p className="success-text">{suggestMsg}</p>}

      {!loading && compositions.length === 0 && <p className="empty-text">Произведения не найдены</p>}

      <div className="card-grid">
        {compositions.map((c) => (
          <article key={c.id} className="card">
            <h3>{c.title}</h3>
            <p className="text-muted">{c.composer}</p>
            <div className="card-tags">
              <span className="tag">{c.instrument}</span>
              <span className="tag">{c.difficulty}</span>
            </div>
            <p className="text-muted">{c.midi_path ? 'MIDI: подключен' : 'MIDI: не добавлен'}</p>
            {c.reference_audio_path && <p className="text-muted">Эталонное аудио: добавлено</p>}
            {c.sheet_notes && <p className="text-muted">Ноты/описание: добавлены</p>}

            {isAuthenticated && !isAdmin && c.midi_path && (
              <a href={`/#/upload?compositionId=${c.id}`} className="btn btn-outline btn-sm card-action">
                Перейти к практике
              </a>
            )}

            {isAdmin && (
              <div className="card-admin-actions">
                <button type="button" className="btn btn-outline btn-sm" onClick={() => handleEdit(c)}>
                  Редактировать
                </button>
                <button type="button" className="btn btn-outline btn-sm" onClick={() => handleDelete(c.id)}>
                  Удалить
                </button>
                <input
                  type="file"
                  accept=".wav,.mp3,audio/wav,audio/mpeg"
                  onChange={(e) =>
                    setReferenceFiles((prev) => ({
                      ...prev,
                      [c.id]: e.target.files?.[0] || null,
                    }))
                  }
                />
                <button type="button" className="btn btn-primary btn-sm" onClick={() => handleReferenceUpload(c.id)}>
                  Загрузить эталонное аудио
                </button>
              </div>
            )}
          </article>
        ))}
      </div>

      {isAuthenticated && !isAdmin && (
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
        </section>
      )}
    </div>
  );
}
