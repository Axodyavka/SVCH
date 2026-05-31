import { useState, useEffect, useRef } from 'react';
import { notificationsApi } from '../api/notificationsApi';

function NotificationBell() {
  const [open, setOpen] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const ref = useRef(null);

  const load = async () => {
    try {
      const data = await notificationsApi.getAll();
      setNotifications(data.notifications);
      setUnreadCount(data.unreadCount);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    load();
    const interval = setInterval(load, 60000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const handleClick = (e) => {
      if (ref.current && !ref.current.contains(e.target)) {
        setOpen(false);
      }
    };
    document.addEventListener('click', handleClick);
    return () => document.removeEventListener('click', handleClick);
  }, []);

  const handleRead = async (id, link) => {
    await notificationsApi.markRead(id);
    setOpen(false);
    load();
    if (link) window.location.hash = `#${link}`;
  };

  const handleReadAll = async () => {
    await notificationsApi.markAllRead();
    load();
  };

  return (
    <div className="notification-bell" ref={ref}>
      <button
        type="button"
        className="btn-icon"
        onClick={() => setOpen((v) => !v)}
        title="Уведомления"
      >
        Уведомления
        {unreadCount > 0 && <span className="badge">{unreadCount}</span>}
      </button>
      {open && (
        <div className="notification-dropdown">
          <div className="notification-header">
            <strong>Уведомления</strong>
            {unreadCount > 0 && (
              <button type="button" className="link-btn" onClick={handleReadAll}>
                Прочитать все
              </button>
            )}
          </div>
          {notifications.length === 0 ? (
            <p className="empty-text">Нет уведомлений</p>
          ) : (
            <ul className="notification-list">
              {notifications.map((n) => (
                <li key={n.id} className={n.is_read ? 'read' : 'unread'}>
                  <button type="button" onClick={() => handleRead(n.id, n.link)}>
                    <span>{n.title}</span>
                    <small>{new Date(n.created_at).toLocaleString('ru-RU')}</small>
                  </button>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </div>
  );
}

export default NotificationBell;
