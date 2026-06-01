import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { reportsApi } from '../api/reportsApi';
import { downloadReportPdf } from '../utils/reports';

function ScoreBadge({ score }) {
  const cls = score >= 80 ? 'good' : score >= 60 ? 'medium' : 'low';
  return <span className={`score-badge ${cls}`}>{score}</span>;
}

export default function ReportPage() {
  const { id } = useParams();
  const [report, setReport] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

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
  }, [id]);

  if (loading) return <div className="page"><p>Загрузка…</p></div>;
  if (error || !report) return <div className="page"><p className="error-text">{error}</p></div>;

  const composition = report.recording?.composition;

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

      <section className="section">
        <h2>Ошибки</h2>
        {report.errors?.length === 0 ? (
          <p className="empty-text">Ошибок не обнаружено</p>
        ) : (
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
                {report.errors?.map((err) => (
                  <tr key={err.id}>
                    <td>{err.type}</td>
                    <td>{err.description}</td>
                    <td>{err.expected_value}</td>
                    <td>{err.actual_value}</td>
                    <td>{err.time_sec != null ? `${err.time_sec}s` : '—'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
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
