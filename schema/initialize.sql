SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'curveball';
DROP DATABASE IF EXISTS curveball;
DROP USER IF EXISTS developer;

CREATE DATABASE curveball;
CREATE USER developer WITH PASSWORD 'password';
ALTER USER developer WITH SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE curveball TO developer;

