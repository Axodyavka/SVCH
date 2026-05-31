import pdfMake from 'pdfmake/build/pdfmake';
import pdfFonts from 'pdfmake/build/vfs_fonts';

pdfMake.vfs = pdfFonts.pdfMake?.vfs || pdfFonts.vfs;

const scoreColor = (score) => {
  if (score >= 80) return '#16a34a';
  if (score >= 60) return '#ca8a04';
  return '#dc2626';
};

export function downloadReportPdf(report) {
  const title = report.recording?.composition?.title || 'Отчёт';
  const composer = report.recording?.composition?.composer || '';

  const doc = {
    content: [
      { text: 'Отчёт об исполнении', style: 'header' },
      { text: `${title} — ${composer}`, style: 'subheader' },
      { text: `Дата: ${new Date(report.created_at).toLocaleString('ru-RU')}`, margin: [0, 0, 0, 16] },
      {
        columns: [
          { text: `Общий балл: ${report.total_score}`, style: 'score' },
          { text: `Интонация: ${report.intonation}` },
          { text: `Ритм: ${report.rhythm}` },
          { text: `Артикуляция: ${report.articulation}` },
        ],
        margin: [0, 0, 0, 16],
      },
      { text: 'Ошибки', style: 'section' },
      {
        table: {
          widths: ['*', '*', '*', 60],
          body: [
            ['Тип', 'Ожидалось', 'Факт', 'Время'],
            ...(report.errors || []).map((e) => [
              e.type,
              e.expected_value,
              e.actual_value,
              e.time_sec != null ? `${e.time_sec}s` : '—',
            ]),
          ],
        },
        margin: [0, 0, 0, 16],
      },
      { text: 'Рекомендации', style: 'section' },
      {
        ul: (report.recommendations || []).map((r) => r.text),
      },
    ],
    styles: {
      header: { fontSize: 18, bold: true, margin: [0, 0, 0, 8] },
      subheader: { fontSize: 14, margin: [0, 0, 0, 8] },
      section: { fontSize: 14, bold: true, margin: [0, 8, 0, 8] },
      score: { bold: true, color: scoreColor(report.total_score) },
    },
  };

  pdfMake.createPdf(doc).download(`report-${report.id}.pdf`);
}

export function downloadProgressPdf(reports) {
  const rows = reports.map((r) => [
    r.recording?.composition?.title || '—',
    String(r.total_score),
    String(r.intonation),
    String(r.rhythm),
    String(r.articulation),
    new Date(r.created_at).toLocaleDateString('ru-RU'),
  ]);

  const doc = {
    content: [
      { text: 'История прогресса', style: 'header' },
      { text: `Записей: ${reports.length}`, margin: [0, 0, 0, 16] },
      {
        table: {
          widths: ['*', 40, 50, 40, 60, 70],
          body: [
            ['Произведение', 'Балл', 'Инт.', 'Ритм', 'Арт.', 'Дата'],
            ...rows,
          ],
        },
      },
    ],
    styles: {
      header: { fontSize: 18, bold: true, margin: [0, 0, 0, 8] },
    },
  };

  pdfMake.createPdf(doc).download('progress-history.pdf');
}
