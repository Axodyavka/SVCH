import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { reportsApi } from '../api/reportsApi';
import { recommendationsApi } from '../api/recommendationsApi';

function ScoreBadge({ score }) {
  const cls = score >= 80 ? 'good' : score >= 60 ? 'medium' : 'low';
  return <span className={`score-badge ${cls}`}>{score}</span>;
}

export default function DashboardPage() {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  const isAdmin = user?.role === 'admin';
  const [recent, setRecent] = useState([]);
  const [recommendations, setRecommendations] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!isAuthenticated || isAdmin) {
      setLoading(false);
      return;
    }
    const load = async () => {
      try {
        const [recentData, recData] = await Promise.all([
          reportsApi.getRecent(),
          recommendationsApi.getAll(),
        ]);
        setRecent(recentData);
        setRecommendations(recData);
      } catch {
        /* ignore */
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [isAuthenticated, isAdmin]);

  return (
    <div className="page">
      <h1>Главная</h1>
      <p className="lead">
        {isAuthenticated && isAdmin
          ? 'Вы вошли как администратор. Используйте раздел управления библиотекой.'
          : isAuthenticated
          ? `Добро пожаловать, ${user?.login}! Загружайте записи и отслеживайте прогресс.`
          : 'Платформа для обучения музыке с анализом исполнения и рекомендациями.'}
      </p>

      {!isAuthenticated && (
        <div className="hero-actions">
          <Link to="/register" className="btn btn-primary">
            Начать обучение
          </Link>
          <Link to="/library" className="btn btn-outline">
            Библиотека произведений
          </Link>
        </div>
      )}

      {isAuthenticated && !isAdmin && (
        <>
          <section className="section">
            <div className="section-header">
              <h2>Последние отчёты</h2>
              <Link to="/progress">Вся история →</Link>
            </div>
            {loading ? (
              <p>Загрузка…</p>
            ) : recent.length === 0 ? (
              <p className="empty-text">Пока нет отчётов. <Link to="/upload">Загрузите запись</Link></p>
            ) : (
              <div className="card-grid">
                {recent.map((report) => (
                  <Link key={report.id} to={`/reports/${report.id}`} className="card card-link">
                    <h3>{report.recording?.composition?.title}</h3>
                    <p className="text-muted">{report.recording?.composition?.composer}</p>
                    <ScoreBadge score={report.total_score} />
                    <small>{new Date(report.created_at).toLocaleDateString('ru-RU')}</small>
                  </Link>
                ))}
              </div>
            )}
          </section>

          <section className="section">
            <h2>Рекомендации</h2>
            {recommendations.length === 0 ? (
              <p className="empty-text">Рекомендации появятся после первого анализа.</p>
            ) : (
              <ul className="recommendation-list">
                {recommendations.slice(0, 5).map((rec) => (
                  <li key={rec.id}>{rec.text}</li>
                ))}
              </ul>
            )}
          </section>
        </>
      )}
    </div>
  );
}
