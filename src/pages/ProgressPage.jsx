import { useState, useEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from 'recharts';
import { reportsApi } from '../api/reportsApi';
import { downloadProgressPdf } from '../utils/reports';

const SORT_OPTIONS = [
  { value: 'date_desc', label: 'Сначала новые' },
  { value: 'date_asc', label: 'Сначала старые' },
  { value: 'score_desc', label: 'По баллу ↓' },
  { value: 'score_asc', label: 'По баллу ↑' },
];

const REPORTS_PER_PAGE = 8;

export default function ProgressPage() {
  const didInitFilters = useRef(false);
  const [reports, setReports] = useState([]);
  const [chartData, setChartData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [sort, setSort] = useState(localStorage.getItem('reportSort') || 'date_desc');
  const [dateFrom, setDateFrom] = useState(localStorage.getItem('reportDateFrom') || '');
  const [dateTo, setDateTo] = useState(localStorage.getItem('reportDateTo') || '');
  const [page, setPage] = useState(Number(localStorage.getItem('reportPage')) || 1);

  useEffect(() => {
    localStorage.setItem('reportSort', sort);
  }, [sort]);

  useEffect(() => {
    localStorage.setItem('reportDateFrom', dateFrom);
    localStorage.setItem('reportDateTo', dateTo);
  }, [dateFrom, dateTo]);

  useEffect(() => {
    if (didInitFilters.current) {
      setPage(1);
    } else {
      didInitFilters.current = true;
    }
  }, [sort, dateFrom, dateTo]);

  useEffect(() => {
    localStorage.setItem('reportPage', String(page));
  }, [page]);

  useEffect(() => {
    const handleReset = () => {
      setSort('date_desc');
      setDateFrom('');
      setDateTo('');
      setPage(1);
    };
    window.addEventListener('app-settings-reset', handleReset);
    return () => window.removeEventListener('app-settings-reset', handleReset);
  }, []);

  useEffect(() => {
    const load = async () => {
      try {
        setLoading(true);
        const params = { sort };
        if (dateFrom) params.dateFrom = dateFrom;
        if (dateTo) params.dateTo = dateTo;
        const [list, progress] = await Promise.all([
          reportsApi.getAll(params),
          reportsApi.getProgress(),
        ]);
        setReports(list);
        setChartData(
          progress.map((r, i) => ({
            name: `#${i + 1}`,
            total: r.total_score,
            intonation: r.intonation,
            rhythm: r.rhythm,
            articulation: r.articulation,
            date: new Date(r.created_at).toLocaleDateString('ru-RU'),
          })),
        );
      } catch {
        /* ignore */
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [sort, dateFrom, dateTo]);

  const pageCount = Math.max(1, Math.ceil(reports.length / REPORTS_PER_PAGE));
  const safePage = Math.min(page, pageCount);
  const pageStart = (safePage - 1) * REPORTS_PER_PAGE;
  const visibleReports = reports.slice(pageStart, pageStart + REPORTS_PER_PAGE);

  useEffect(() => {
    if (page > pageCount) {
      setPage(pageCount);
    }
  }, [page, pageCount]);

  return (
    <div className="page">
      <div className="section-header">
        <h1>Прогресс</h1>
        <button type="button" className="btn btn-outline" onClick={() => downloadProgressPdf(reports)}>
          Скачать PDF
        </button>
      </div>

      <div className="filters">
        <select value={sort} onChange={(e) => setSort(e.target.value)}>
          {SORT_OPTIONS.map((o) => (
            <option key={o.value} value={o.value}>
              {o.label}
            </option>
          ))}
        </select>
        <input type="date" value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} />
        <input type="date" value={dateTo} onChange={(e) => setDateTo(e.target.value)} />
      </div>

      {chartData.length > 0 && (
        <section className="section chart-section">
          <h2>График прогресса</h2>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis domain={[0, 100]} />
              <Tooltip />
              <Legend />
              <Line type="monotone" dataKey="total" name="Общий" stroke="#4f46e5" />
              <Line type="monotone" dataKey="intonation" name="Интонация" stroke="#16a34a" />
              <Line type="monotone" dataKey="rhythm" name="Ритм" stroke="#ca8a04" />
            </LineChart>
          </ResponsiveContainer>
        </section>
      )}

      <section className="section">
        <h2>История отчётов</h2>
        {loading ? (
          <p>Загрузка…</p>
        ) : reports.length === 0 ? (
          <p className="empty-text">Нет отчётов</p>
        ) : (
          <div className="table-wrap">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Произведение</th>
                  <th>Балл</th>
                  <th>Дата</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {visibleReports.map((r) => (
                  <tr key={r.id}>
                    <td>{r.recording?.composition?.title}</td>
                    <td>{r.total_score}</td>
                    <td>{new Date(r.created_at).toLocaleDateString('ru-RU')}</td>
                    <td>
                      <Link to={`/reports/${r.id}`} className="btn btn-outline btn-sm">
                        Открыть
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            {reports.length > REPORTS_PER_PAGE && (
              <div className="pagination">
                <button
                  type="button"
                  className="btn btn-outline btn-sm"
                  onClick={() => setPage((value) => Math.max(1, value - 1))}
                  disabled={safePage === 1}
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
        )}
      </section>
    </div>
  );
}
