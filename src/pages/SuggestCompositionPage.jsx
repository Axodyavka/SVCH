import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { compositionsApi } from '../api/compositionsApi';

const INSTRUMENTS = [
  { value: 'piano', label: 'Фортепиано' },
  { value: 'violin', label: 'Скрипка' },
  { value: 'guitar', label: 'Гитара' },
  { value: 'flute', label: 'Флейта' },
];

export default function SuggestCompositionPage() {
  const navigate = useNavigate();
  const [form, setForm] = useState({
    title: '',
    composer: '',
    instrument: 'piano',
  });
  const [sheetFile, setSheetFile] = useState(null);
  const [referenceAudioFile, setReferenceAudioFile] = useState(null);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage('');
    setError('');

    if (!sheetFile) {
      setError('Загрузите файл нот');
      return;
    }
    if (!referenceAudioFile) {
      setError('Загрузите эталонную запись');
      return;
    }

    try {
      setLoading(true);
      const formData = new FormData();
      formData.append('title', form.title);
      formData.append('composer', form.composer);
      formData.append('instrument', form.instrument);
      formData.append('sheet', sheetFile);
      formData.append('referenceAudio', referenceAudioFile);

      await compositionsApi.suggest(formData);
      setMessage('Предложение отправлено администратору');
      setTimeout(() => navigate('/library'), 900);
    } catch (err) {
      setError(err.response?.data?.message || 'Ошибка отправки предложения');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page">
      <h1>Предложить произведение</h1>
      <p className="lead">
        Заполните данные произведения и приложите файлы. Администратор проверит заявку и добавит материал
        в библиотеку.
      </p>

      <form onSubmit={handleSubmit} className="form-card suggest-form">
        <div className="form-group">
          <label htmlFor="title">Название</label>
          <input
            id="title"
            value={form.title}
            onChange={(e) => setForm((p) => ({ ...p, title: e.target.value }))}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="composer">Автор / композитор</label>
          <input
            id="composer"
            value={form.composer}
            onChange={(e) => setForm((p) => ({ ...p, composer: e.target.value }))}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="instrument">Инструмент</label>
          <select
            id="instrument"
            value={form.instrument}
            onChange={(e) => setForm((p) => ({ ...p, instrument: e.target.value }))}
            required
          >
            {INSTRUMENTS.map((item) => (
              <option key={item.value} value={item.value}>
                {item.label}
              </option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label htmlFor="sheet">Файл нот</label>
          <input
            id="sheet"
            type="file"
            accept=".pdf,.png,.jpg,.jpeg,application/pdf,image/png,image/jpeg"
            onChange={(e) => setSheetFile(e.target.files?.[0] || null)}
            required
          />
          {sheetFile && <small className="text-muted">Выбран: {sheetFile.name}</small>}
        </div>

        <div className="form-group">
          <label htmlFor="referenceAudio">Эталонная запись</label>
          <input
            id="referenceAudio"
            type="file"
            accept=".wav,.mp3,audio/wav,audio/mpeg"
            onChange={(e) => setReferenceAudioFile(e.target.files?.[0] || null)}
            required
          />
          {referenceAudioFile && <small className="text-muted">Выбран: {referenceAudioFile.name}</small>}
        </div>

        {error && <p className="error-text">{error}</p>}
        {message && <p className="success-text">{message}</p>}

        <button type="submit" className="btn btn-primary btn-block" disabled={loading}>
          {loading ? 'Отправка...' : 'Отправить предложение'}
        </button>
      </form>
    </div>
  );
}
