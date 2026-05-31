import { Navigate } from 'react-router-dom';
import { useSelector } from 'react-redux';

function PrivateRoute({ children, musicianOnly = false }) {
  const { isAuthenticated, user } = useSelector((state) => state.auth);
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }
  if (musicianOnly && user?.role === 'admin') {
    return <Navigate to="/library" replace />;
  }
  return children;
}

export default PrivateRoute;
