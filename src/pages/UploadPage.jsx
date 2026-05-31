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
      <p className="lead">Загрузите запись исполнения (WAV или MP3) для анализа.</p>

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
    </div>
  );
}
