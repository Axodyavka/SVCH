import { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { compositionsApi } from '../api/compositionsApi';
import { recordingsApi } from '../api/recordingsApi';

export default function UploadPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const [compositions, setCompositions] = useState([]);
  const [compositionId, setCompositionId] = useState('');
  const [file, setFile] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const selectedComposition = compositions.find((item) => String(item.id) === String(compositionId));

  useEffect(() => {
    const presetId = searchParams.get('compositionId');
    compositionsApi
      .getAll()
      .then((items) => {
        setCompositions(items);
        if (presetId && items.some((item) => String(item.id) === String(presetId))) {
          setCompositionId(String(presetId));
        }
      })
      .catch(() => setError('Не удалось загрузить список'));
  }, [searchParams]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!file || !compositionId) {
      setError('Выберите произведение и файл');
      return;
    }
    setError('');
    setLoading(true);
    try {
      const formData = new FormData();
      formData.append('audio', file);
      formData.append('compositionId', compositionId);
      const result = await recordingsApi.upload(formData);
      navigate(`/reports/${result.reportId}`);
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка загрузки');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page">
      <h1>Загрузка аудио</h1>
      <p className="lead">
        Загрузите свою запись исполнения. Для анализа она сравнивается с MIDI-эталоном, а аудиозапись
        произведения можно прослушать как пример.
      </p>

      <div className="upload-layout">
        <form onSubmit={handleSubmit} className="form-card upload-form">
          <div className="form-group">
            <label htmlFor="composition">Произведение</label>
            <select
              id="composition"
              value={compositionId}
              onChange={(e) => setCompositionId(e.target.value)}
              required
            >
              <option value="">— Выберите —</option>
              {compositions.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.title} — {c.composer}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label htmlFor="audio">Аудиофайл</label>
            <input
              id="audio"
              type="file"
              accept=".wav,.mp3,audio/wav,audio/mpeg"
              onChange={(e) => setFile(e.target.files?.[0] || null)}
              required
            />
            {file && <small className="text-muted">Выбран: {file.name}</small>}
          </div>

          {error && <p className="error-text">{error}</p>}

          <button type="submit" className="btn btn-primary btn-block" disabled={loading}>
            {loading ? 'Анализ…' : 'Загрузить и проанализировать'}
          </button>
        </form>

        <aside className="card upload-details">
          {selectedComposition ? (
            <>
              <h2>{selectedComposition.title}</h2>
              <p className="text-muted">{selectedComposition.composer}</p>
              <div className="card-tags">
                <span className="tag">{selectedComposition.instrument}</span>
                <span className="tag">{selectedComposition.difficulty}</span>
                <span className="tag">
                  {selectedComposition.material_type === 'exercise' ? 'упражнение' : 'произведение'}
                </span>
              </div>
              {selectedComposition.sheet_notes && <p>{selectedComposition.sheet_notes}</p>}

              <div className="material-links">
                {selectedComposition.sheet_file_path ? (
                  <a
                    href={compositionsApi.fileUrl(selectedComposition.id, 'sheet')}
                    target="_blank"
                    rel="noreferrer"
                    className="btn btn-outline btn-sm"
                  >
                    Открыть ноты
                  </a>
                ) : (
                  <p className="empty-text">Ноты не добавлены</p>
                )}
                {selectedComposition.reference_audio_path ? (
                  <a
                    href={compositionsApi.fileUrl(selectedComposition.id, 'reference-audio')}
                    target="_blank"
                    rel="noreferrer"
                    className="btn btn-outline btn-sm"
                  >
                    Прослушать аудиозапись
                  </a>
                ) : (
                  <p className="empty-text">Аудиозапись для прослушивания не добавлена</p>
                )}
                <p className="text-muted">
                  {selectedComposition.midi_path
                    ? 'MIDI-эталон загружен: анализ будет сравнивать запись с эталонными нотами.'
                    : 'MIDI-эталон не добавлен: точное сравнение с эталонными нотами недоступно.'}
                </p>
              </div>
            </>
          ) : (
            <p className="empty-text">
              Выберите произведение, чтобы увидеть ноты, аудиозапись для прослушивания и статус MIDI-эталона.
            </p>
          )}
        </aside>
      </div>
    </div>
  );
}
