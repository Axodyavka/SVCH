import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { reportsApi } from '../api/reportsApi';
import { downloadReportPdf } from '../utils/reports';

const ERROR_TYPE_LABELS = {
  wrong_pitch: 'Неточная высота',
  missing_note: 'Пропущенная нота',
  early: 'Раннее вступление',
  late: 'Позднее вступление',
  articulation: 'Артикуляция',
  duration: 'Длительность',
  analysis_unavailable: 'Анализ недоступен',
};

const ERROR_DESCRIPTION_FALLBACKS = {
  analysis_unavailable:
    'В загруженном аудио не удалось распознать ноты. Проверьте, что файл содержит достаточно громкую запись инструмента и не повреждён.',
};

const ERRORS_PER_PAGE = 15;

function ScoreBadge({ score }) {
  const cls = score >= 80 ? 'good' : score >= 60 ? 'medium' : 'low';
  return <span className={`score-badge ${cls}`}>{score}</span>;
}

export default function ReportPage() {
  const { id } = useParams();
  const [report, setReport] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [errorsPage, setErrorsPage] = useState(1);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await reportsApi.getById(id);
        setReport(data);
      } catch {
        setError('Отчёт не найден');
      } finally {
        setLoading(false);
      }
    };
    load();
    setErrorsPage(1);
  }, [id]);

  if (loading) return <div className="page"><p>Загрузка…</p></div>;
  if (error || !report) return <div className="page"><p className="error-text">{error}</p></div>;

  const composition = report.recording?.composition;
  const hasAnalysisUnavailable = report.errors?.some((err) => err.type === 'analysis_unavailable');
  const reportErrors = report.errors || [];
  const errorsPageCount = Math.max(1, Math.ceil(reportErrors.length / ERRORS_PER_PAGE));
  const safeErrorsPage = Math.min(errorsPage, errorsPageCount);
  const errorsStart = (safeErrorsPage - 1) * ERRORS_PER_PAGE;
  const visibleErrors = reportErrors.slice(errorsStart, errorsStart + ERRORS_PER_PAGE);

  return (
    <div className="page">
      <div className="section-header">
        <div>
          <h1>Отчёт #{report.id}</h1>
          <p className="text-muted">
            {composition?.title} — {composition?.composer}
          </p>
        </div>
        <button type="button" className="btn btn-outline" onClick={() => downloadReportPdf(report)}>
          Скачать PDF
        </button>
      </div>

      <div className="score-grid">
        <div className="card score-card">
          <span>Общий балл</span>
          <ScoreBadge score={report.total_score} />
        </div>
        <div className="card score-card">
          <span>Интонация</span>
          <strong>{report.intonation}</strong>
        </div>
        <div className="card score-card">
          <span>Ритм</span>
          <strong>{report.rhythm}</strong>
        </div>
        <div className="card score-card">
          <span>Артикуляция</span>
          <strong>{report.articulation}</strong>
        </div>
      </div>

      {!composition?.midi_path && (
        <p className="error-text">
          У произведения не загружен MIDI-эталон, поэтому точное сравнение с нотами недоступно. Отчёт может
          быть демонстрационным.
        </p>
      )}
      {hasAnalysisUnavailable && (
        <p className="error-text">
          Автоматический анализ не смог обработать запись. Проверьте аудиофайл или попробуйте загрузить другую
          запись.
        </p>
      )}

      <section className="section">
        <div className="section-header">
          <div>
            <h2>Ошибки</h2>
            {reportErrors.length > 0 && (
              <p className="text-muted">Всего найдено ошибок: {reportErrors.length}</p>
            )}
          </div>
        </div>
        {reportErrors.length === 0 ? (
          <p className="empty-text">Ошибок не обнаружено</p>
        ) : (
          <>
            <div className="table-wrap">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>Тип</th>
                    <th>Описание</th>
                    <th>Ожидалось</th>
                    <th>Факт</th>
                    <th>Время</th>
                  </tr>
                </thead>
                <tbody>
                  {visibleErrors.map((err) => (
                    <tr key={err.id}>
                      <td>{ERROR_TYPE_LABELS[err.type] || err.type}</td>
                      <td>{ERROR_DESCRIPTION_FALLBACKS[err.type] || err.description}</td>
                      <td>{err.expected_value}</td>
                      <td>{err.actual_value}</td>
                      <td>{err.time_sec != null ? `${err.time_sec}s` : '—'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {reportErrors.length > ERRORS_PER_PAGE && (
              <div className="pagination">
                <button
                  type="button"
                  className="btn btn-outline btn-sm"
                  onClick={() => setErrorsPage((value) => Math.max(1, value - 1))}
                  disabled={safeErrorsPage === 1}
                >
                  Назад
                </button>
                <span className="text-muted">
                  Страница {safeErrorsPage} из {errorsPageCount}
                </span>
                <button
                  type="button"
                  className="btn btn-outline btn-sm"
                  onClick={() => setErrorsPage((value) => Math.min(errorsPageCount, value + 1))}
                  disabled={safeErrorsPage === errorsPageCount}
                >
                  Вперёд
                </button>
              </div>
            )}
          </>
        )}
      </section>

      <section className="section">
        <h2>Рекомендации</h2>
        {report.recommendations?.length ? (
          <ul className="recommendation-list">
            {report.recommendations.map((rec) => (
              <li key={rec.id}>{rec.text}</li>
            ))}
          </ul>
        ) : (
          <p className="empty-text">Рекомендации появятся после анализа найденных ошибок.</p>
        )}
      </section>

      <Link to="/progress" className="btn btn-outline">
        ← К истории прогресса
      </Link>
    </div>
  );
}
