import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { compositionsApi } from '../api/compositionsApi';
import { adminApi } from '../api/adminApi';

const INSTRUMENTS = [
  { value: '', label: 'Все инструменты' },
  { value: 'Фортепиано', label: 'Фортепиано' },
  { value: 'Скрипка', label: 'Скрипка' },
  { value: 'Гитара', label: 'Гитара' },
  { value: 'Флейта', label: 'Флейта' },
];

const SORT_OPTIONS = [
  { value: '', label: 'От А до Я' },
  { value: 'title-desc', label: 'От Я до А' },
  { value: 'difficulty-asc', label: 'Сначала легкие' },
  { value: 'difficulty-desc', label: 'Сначала сложные' },
];

const DIFFICULTY_ORDER = {
  Легкий: 1,
  Средний: 2,
  Сложный: 3,
};

const ITEMS_PER_PAGE = 8;

const EMPTY_ADMIN_FORM = {
  title: '',
  composer: '',
  instrument: 'Фортепиано',
  difficulty: 'Легкий',
  material_type: 'composition',
  sheet_notes: '',
};

function getInitialInstrumentFilter() {
  const storedInstrument = localStorage.getItem('libraryInstrument') || '';
  return INSTRUMENTS.some((item) => item.value === storedInstrument) ? storedInstrument : '';
}

function getInitialSort() {
  const storedSort = localStorage.getItem('librarySort') || '';
  return SORT_OPTIONS.some((item) => item.value === storedSort) ? storedSort : '';
}

function sortCompositions(items, sort) {
  const sorted = [...items];
  if (sort === 'difficulty-asc' || sort === 'difficulty-desc') {
    const direction = sort === 'difficulty-asc' ? 1 : -1;
    return sorted.sort((a, b) => {
      const difficultyDiff =
        ((DIFFICULTY_ORDER[a.difficulty] || 0) - (DIFFICULTY_ORDER[b.difficulty] || 0)) * direction;
      if (difficultyDiff !== 0) return difficultyDiff;
      return a.title.localeCompare(b.title, 'ru');
    });
  }
  if (sort === 'title-desc') {
    return sorted.sort((a, b) => b.title.localeCompare(a.title, 'ru'));
  }
  return sorted;
}

function fileNameFromPath(storedPath) {
  if (!storedPath) return '';
  return storedPath.split(/[/\\]/).pop();
}

export default function LibraryPage() {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const isAdmin = user?.role === 'admin';

  const [compositions, setCompositions] = useState([]);
  const [suggestions, setSuggestions] = useState([]);
  const [search, setSearch] = useState(localStorage.getItem('librarySearch') || '');
  const [instrument, setInstrument] = useState(getInitialInstrumentFilter);
  const [sort, setSort] = useState(getInitialSort);
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
    localStorage.setItem('librarySort', sort);
  }, [search, instrument, sort]);

  useEffect(() => {
    localStorage.setItem('libraryPage', String(page));
  }, [page]);

  useEffect(() => {
    const handleReset = () => {
      setSearch('');
      setInstrument('');
      setSort('');
      setPage(1);
    };
    window.addEventListener('app-settings-reset', handleReset);
    return () => window.removeEventListener('app-settings-reset', handleReset);
  }, []);

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

  useEffect(() => {
    if (!suggestMsg) return undefined;
    const timer = setTimeout(() => setSuggestMsg(''), 3500);
    return () => clearTimeout(timer);
  }, [suggestMsg]);

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
      setSuggestions((items) => items.filter((item) => item.id !== id));
      load();
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка одобрения предложения');
    }
  };

  const handleRejectSuggestion = async (id) => {
    try {
      await adminApi.rejectSuggestion(id);
      setSuggestMsg('Предложение отклонено');
      setSuggestions((items) => items.filter((item) => item.id !== id));
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка отклонения предложения');
    }
  };

  const handleOpenSuggestionFile = async (id, kind) => {
    try {
      const file = await adminApi.getSuggestionFile(id, kind);
      const url = URL.createObjectURL(file);
      window.open(url, '_blank', 'noopener,noreferrer');
      setTimeout(() => URL.revokeObjectURL(url), 30000);
    } catch {
      setError('Не удалось открыть файл предложения');
    }
  };

  const sortedCompositions = sortCompositions(compositions, sort);
  const pageCount = Math.max(1, Math.ceil(sortedCompositions.length / ITEMS_PER_PAGE));
  const safePage = Math.min(page, pageCount);
  const pageStart = (safePage - 1) * ITEMS_PER_PAGE;
  const visibleCompositions = sortedCompositions.slice(pageStart, pageStart + ITEMS_PER_PAGE);

  useEffect(() => {
    if (!loading && page > pageCount) {
      setPage(pageCount);
    }
  }, [loading, page, pageCount]);

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
                <option value="Легкий">Легкий</option>
                <option value="Средний">Средний</option>
                <option value="Сложный">Сложный</option>
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
                <span>MIDI-эталон для анализа (.mid)</span>
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
                <span>Аудиозапись для прослушивания (WAV, MP3)</span>
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
            MIDI используется для анализа, файл нот показывается пользователю, аудиозапись можно открыть и
            прослушать.
          </p>
        </section>
      )}

      {isAdmin && (
        <section className="section">
          <h2>Модерация предложений</h2>
          {suggestions.filter((s) => s.status === 'pending').length === 0 ? (
            <p className="empty-text">Нет предложений</p>
          ) : (
            <div className="card-grid moderation-grid">
              {suggestions
                .filter((s) => s.status === 'pending')
                .map((s) => (
                  <article key={s.id} className="card library-card">
                    <div className="library-card-body">
                      <h3>{s.title}</h3>
                      <p className="text-muted">{s.composer}</p>
                      <div className="card-tags">
                        <span className="tag">{s.instrument || 'Фортепиано'}</span>
                        <span className="tag">{s.difficulty || 'Легкий'}</span>
                        <span className="tag">ожидает решения</span>
                      </div>
                      <p className="text-muted">Автор предложения: {s.user?.login || 'не указан'}</p>
                      <div className="suggestion-file-links">
                        {s.midi_path ? (
                          <button
                            type="button"
                            className="inline-link"
                            onClick={() => handleOpenSuggestionFile(s.id, 'midi')}
                          >
                            MIDI-эталон
                          </button>
                        ) : (
                          <span className="text-muted">MIDI-эталон не добавлен</span>
                        )}
                        {s.sheet_file_path && (
                          <button
                            type="button"
                            className="inline-link"
                            onClick={() => handleOpenSuggestionFile(s.id, 'sheet')}
                          >
                            Ноты
                          </button>
                        )}
                        {s.reference_audio_path && (
                          <button
                            type="button"
                            className="inline-link"
                            onClick={() => handleOpenSuggestionFile(s.id, 'audio')}
                          >
                            Аудиозапись
                          </button>
                        )}
                      </div>
                    </div>

                    <div className="card-admin-actions">
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
                  </article>
                ))}
            </div>
          )}
        </section>
      )}

      <section className="section section-spaced library-materials-section">
        <h2>Все материалы</h2>
        <p className="text-muted">Произведения и упражнения для анализа записей</p>
      </section>

      <div className="filters">
        <input
          type="search"
          placeholder="Поиск по названию или композитору"
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setPage(1);
          }}
          className="search-input"
        />
        <select
          value={instrument}
          onChange={(e) => {
            setInstrument(e.target.value);
            setPage(1);
          }}
        >
          {INSTRUMENTS.map((opt) => (
            <option key={opt.value} value={opt.value}>
              {opt.label}
            </option>
          ))}
        </select>
        <select
          value={sort}
          onChange={(e) => {
            setSort(e.target.value);
            setPage(1);
          }}
        >
          {SORT_OPTIONS.map((opt) => (
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
            <div className="library-card-body">
              <h3>{c.title}</h3>
              <p className="text-muted">{c.composer}</p>
              <div className="card-tags">
                <span className="tag">{c.material_type === 'exercise' ? 'упражнение' : 'произведение'}</span>
                <span className="tag">{c.instrument}</span>
                <span className="tag">{c.difficulty}</span>
              </div>
              <p className="text-muted">
                {c.midi_path ? 'MIDI-эталон: загружен' : 'MIDI-эталон: не добавлен'}
              </p>
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
                  Аудиозапись:{' '}
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
              {c.sheet_notes && <p className="text-muted library-card-description">{c.sheet_notes}</p>}
            </div>

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
