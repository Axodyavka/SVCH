import { useState, useEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { compositionsApi } from '../api/compositionsApi';
import { adminApi } from '../api/adminApi';

const INSTRUMENTS = [
  { value: '', label: 'Все инструменты' },
  { value: 'piano', label: 'Фортепиано' },
  { value: 'violin', label: 'Скрипка' },
  { value: 'guitar', label: 'Гитара' },
  { value: 'flute', label: 'Флейта' },
];

const ITEMS_PER_PAGE = 8;

const EMPTY_ADMIN_FORM = {
  title: '',
  composer: '',
  instrument: 'piano',
  difficulty: 'easy',
  material_type: 'composition',
  sheet_notes: '',
};

function fileNameFromPath(storedPath) {
  if (!storedPath) return '';
  return storedPath.split(/[/\\]/).pop();
}

export default function LibraryPage() {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const isAdmin = user?.role === 'admin';
  const didInitFilters = useRef(false);

  const [compositions, setCompositions] = useState([]);
  const [suggestions, setSuggestions] = useState([]);
  const [search, setSearch] = useState(localStorage.getItem('librarySearch') || '');
  const [instrument, setInstrument] = useState(localStorage.getItem('libraryInstrument') || '');
  const [page, setPage] = useState(Number(localStorage.getItem('libraryPage')) || 1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [suggestMsg, setSuggestMsg] = useState('');
  const [adminForm, setAdminForm] = useState(EMPTY_ADMIN_FORM);
  const [editingId, setEditingId] = useState(null);
  const [editingFiles, setEditingFiles] = useState({
    midi_path: null,
    sheet_file_path: null,
    reference_audio_path: null,
  });
  const [midiFile, setMidiFile] = useState(null);
  const [sheetFile, setSheetFile] = useState(null);
  const [referenceAudioFile, setReferenceAudioFile] = useState(null);
  const [saving, setSaving] = useState(false);

  const load = async () => {
    try {
      setLoading(true);
      const data = await compositionsApi.getAll({ search, instrument });
      setCompositions(data);
    } catch {
      setError('Не удалось загрузить библиотеку');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const timer = setTimeout(load, 300);
    return () => clearTimeout(timer);
  }, [search, instrument]);

  useEffect(() => {
    localStorage.setItem('librarySearch', search);
    localStorage.setItem('libraryInstrument', instrument);
  }, [search, instrument]);

  useEffect(() => {
    localStorage.setItem('libraryPage', String(page));
  }, [page]);

  useEffect(() => {
    const handleReset = () => {
      setSearch('');
      setInstrument('');
      setPage(1);
    };
    window.addEventListener('app-settings-reset', handleReset);
    return () => window.removeEventListener('app-settings-reset', handleReset);
  }, []);

  useEffect(() => {
    if (didInitFilters.current) {
      setPage(1);
    } else {
      didInitFilters.current = true;
    }
  }, [search, instrument]);

  const loadSuggestions = async () => {
    if (!isAdmin) return;
    try {
      const data = await adminApi.getSuggestions();
      setSuggestions(data);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    loadSuggestions();
  }, [isAdmin]);

  const resetAdminForm = () => {
    setEditingId(null);
    setAdminForm(EMPTY_ADMIN_FORM);
    setEditingFiles({ midi_path: null, sheet_file_path: null, reference_audio_path: null });
    setMidiFile(null);
    setSheetFile(null);
    setReferenceAudioFile(null);
  };

  const buildFormData = () => {
    const formData = new FormData();
    Object.entries(adminForm).forEach(([key, value]) => {
      formData.append(key, value ?? '');
    });
    if (midiFile) formData.append('midi', midiFile);
    if (sheetFile) formData.append('sheet', sheetFile);
    if (referenceAudioFile) formData.append('referenceAudio', referenceAudioFile);
    return formData;
  };

  const handleAdminSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const formData = buildFormData();
      if (editingId) {
        await compositionsApi.update(editingId, formData);
        setSuggestMsg('Произведение обновлено');
      } else {
        await compositionsApi.create(formData);
        setSuggestMsg('Произведение добавлено');
      }
      resetAdminForm();
      load();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка сохранения');
    } finally {
      setSaving(false);
    }
  };

  const handleEdit = (composition) => {
    setEditingId(composition.id);
    setAdminForm({
      title: composition.title,
      composer: composition.composer,
      instrument: composition.instrument,
      difficulty: composition.difficulty,
      material_type: composition.material_type || 'composition',
      sheet_notes: composition.sheet_notes || '',
    });
    setEditingFiles({
      midi_path: composition.midi_path,
      sheet_file_path: composition.sheet_file_path,
      reference_audio_path: composition.reference_audio_path,
    });
    setMidiFile(null);
    setSheetFile(null);
    setReferenceAudioFile(null);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Удалить произведение из библиотеки?')) return;
    try {
      await compositionsApi.remove(id);
      setSuggestMsg('Произведение удалено');
      if (editingId === id) resetAdminForm();
      load();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка удаления');
    }
  };

  const handleApproveSuggestion = async (id) => {
    try {
      await adminApi.approveSuggestion(id);
      setSuggestMsg('Предложение одобрено и добавлено в библиотеку');
      loadSuggestions();
      load();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка одобрения предложения');
    }
  };

  const handleRejectSuggestion = async (id) => {
    try {
      await adminApi.rejectSuggestion(id);
      setSuggestMsg('Предложение отклонено');
      loadSuggestions();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка отклонения предложения');
    }
  };

  const pageCount = Math.max(1, Math.ceil(compositions.length / ITEMS_PER_PAGE));
  const safePage = Math.min(page, pageCount);
  const pageStart = (safePage - 1) * ITEMS_PER_PAGE;
  const visibleCompositions = compositions.slice(pageStart, pageStart + ITEMS_PER_PAGE);

  useEffect(() => {
    if (page > pageCount) {
      setPage(pageCount);
    }
  }, [page, pageCount]);

  return (
    <div className="page">
      <h1>Библиотека произведений</h1>

      {isAdmin && (
        <section className="section admin-library-form">
          <h2>{editingId ? 'Редактировать произведение' : 'Добавить произведение или упражнение'}</h2>
          <form onSubmit={handleAdminSubmit} className="admin-form">
            <div className="inline-form">
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
              <select
                value={adminForm.material_type}
                onChange={(e) => setAdminForm((p) => ({ ...p, material_type: e.target.value }))}
              >
                <option value="composition">Произведение</option>
                <option value="exercise">Упражнение</option>
              </select>
            </div>

            <div className="file-upload-grid">
              <label className="file-field">
                <span>MIDI-файл (.mid)</span>
                <input
                  type="file"
                  accept=".mid,.midi,audio/midi"
                  onChange={(e) => setMidiFile(e.target.files?.[0] || null)}
                />
                {midiFile && <small className="text-muted">Выбран: {midiFile.name}</small>}
                {!midiFile && editingFiles.midi_path && (
                  <small className="text-muted">
                    Загружен: {fileNameFromPath(editingFiles.midi_path)}
                  </small>
                )}
              </label>

              <label className="file-field">
                <span>Файл нот (PDF, PNG, JPG)</span>
                <input
                  type="file"
                  accept=".pdf,.png,.jpg,.jpeg,application/pdf,image/png,image/jpeg"
                  onChange={(e) => setSheetFile(e.target.files?.[0] || null)}
                />
                {sheetFile && <small className="text-muted">Выбран: {sheetFile.name}</small>}
                {!sheetFile && editingFiles.sheet_file_path && (
                  <small className="text-muted">
                    Загружен: {fileNameFromPath(editingFiles.sheet_file_path)}
                  </small>
                )}
              </label>

              <label className="file-field">
                <span>Эталонное аудио (WAV, MP3)</span>
                <input
                  type="file"
                  accept=".wav,.mp3,audio/wav,audio/mpeg"
                  onChange={(e) => setReferenceAudioFile(e.target.files?.[0] || null)}
                />
                {referenceAudioFile && (
                  <small className="text-muted">Выбран: {referenceAudioFile.name}</small>
                )}
                {!referenceAudioFile && editingFiles.reference_audio_path && (
                  <small className="text-muted">
                    Загружен: {fileNameFromPath(editingFiles.reference_audio_path)}
                  </small>
                )}
              </label>
            </div>

            <textarea
              className="notes-textarea"
              placeholder="Краткое описание упражнения (необязательно)"
              value={adminForm.sheet_notes}
              onChange={(e) => setAdminForm((p) => ({ ...p, sheet_notes: e.target.value }))}
            />

            <div className="inline-form">
              <button type="submit" className="btn btn-primary" disabled={saving}>
                {saving ? 'Сохранение…' : editingId ? 'Сохранить изменения' : 'Добавить'}
              </button>
              {editingId && (
                <button type="button" className="btn btn-outline" onClick={resetAdminForm}>
                  Отменить
                </button>
              )}
            </div>
          </form>

          <p className="text-muted">
            Выберите файлы на компьютере — они сохраняются на сервере в{' '}
            <code>server/uploads/</code>. В базе хранится только ссылка на файл. MIDI используется для
            анализа, файл нот показывается пользователю, эталонное аудио можно открыть и прослушать.
          </p>
        </section>
      )}

      {isAdmin && (
        <section className="section">
          <h2>Модерация предложений</h2>
          {suggestions.length === 0 ? (
            <p className="empty-text">Нет предложений</p>
          ) : (
            <div className="table-wrap">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>Название</th>
                    <th>Композитор</th>
                    <th>Инструмент</th>
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
                      <td>{s.instrument || 'piano'}</td>
                      <td>{s.user?.login}</td>
                      <td>{s.status}</td>
                      <td>
                        {s.status === 'pending' && (
                          <div className="table-actions">
                            <button
                              type="button"
                              className="btn btn-primary btn-sm"
                              onClick={() => handleApproveSuggestion(s.id)}
                            >
                              Одобрить
                            </button>
                            <button
                              type="button"
                              className="btn btn-outline btn-sm"
                              onClick={() => handleRejectSuggestion(s.id)}
                            >
                              Отклонить
                            </button>
                          </div>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
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
        {visibleCompositions.map((c) => (
          <article
            key={c.id}
            className="card library-card"
            role={!isAdmin ? 'button' : undefined}
            tabIndex={!isAdmin ? 0 : undefined}
            onClick={() => {
              if (!isAdmin) {
                window.location.hash = `#/upload?compositionId=${c.id}`;
              }
            }}
            onKeyDown={(e) => {
              if (!isAdmin && (e.key === 'Enter' || e.key === ' ')) {
                e.preventDefault();
                window.location.hash = `#/upload?compositionId=${c.id}`;
              }
            }}
          >
            <h3>{c.title}</h3>
            <p className="text-muted">{c.composer}</p>
            <div className="card-tags">
              <span className="tag">{c.material_type === 'exercise' ? 'упражнение' : 'произведение'}</span>
              <span className="tag">{c.instrument}</span>
              <span className="tag">{c.difficulty}</span>
            </div>
            <p className="text-muted">{c.midi_path ? 'MIDI: загружен' : 'MIDI: не добавлен'}</p>
            {c.sheet_file_path && (
              <p className="text-muted">
                Ноты:{' '}
                <a
                  className="inline-link"
                  href={compositionsApi.fileUrl(c.id, 'sheet')}
                  target="_blank"
                  rel="noreferrer"
                  onClick={(e) => e.stopPropagation()}
                >
                  открыть файл
                </a>
              </p>
            )}
            {c.reference_audio_path && (
              <p className="text-muted">
                Эталон:{' '}
                <a
                  className="inline-link"
                  href={compositionsApi.fileUrl(c.id, 'reference-audio')}
                  target="_blank"
                  rel="noreferrer"
                  onClick={(e) => e.stopPropagation()}
                >
                  прослушать
                </a>
              </p>
            )}
            {c.sheet_notes && <p className="text-muted">{c.sheet_notes}</p>}

            {isAdmin && (
              <div className="card-admin-actions">
                <button
                  type="button"
                  className="btn btn-outline btn-sm"
                  onClick={(e) => {
                    e.stopPropagation();
                    handleEdit(c);
                  }}
                >
                  Редактировать
                </button>
                <button
                  type="button"
                  className="btn btn-outline btn-sm"
                  onClick={(e) => {
                    e.stopPropagation();
                    handleDelete(c.id);
                  }}
                >
                  Удалить
                </button>
              </div>
            )}
          </article>
        ))}
      </div>

      {!loading && compositions.length > ITEMS_PER_PAGE && (
        <div className="pagination">
          <button
            type="button"
            className="btn btn-outline btn-sm"
            onClick={() => setPage((value) => Math.max(1, value - 1))}
            disabled={page === 1}
          >
            Назад
          </button>
          <span className="text-muted">
            Страница {safePage} из {pageCount}
          </span>
          <button
            type="button"
            className="btn btn-outline btn-sm"
            onClick={() => setPage((value) => Math.min(pageCount, value + 1))}
            disabled={safePage === pageCount}
          >
            Вперёд
          </button>
        </div>
      )}

    </div>
  );
}
