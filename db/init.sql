CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'member'
);

CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'todo',
    owner_id INTEGER REFERENCES users (id),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS logs (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(50),
    username VARCHAR(50),
    detail TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO
    users (username, password_hash, role)
VALUES (
        'alice',
        '$2b$10$nTXuak.MROW1r2gGm1fde./LZuVLWb798mxGU8.J.gjCIJEMlKBja',
        'member'
    ),
    ('bob', '$2b$10$nTXuak.MROW1r2gGm1fde./LZuVLWb798mxGU8.J.gjCIJEMlKBja', 'member'),
    ('admin', '$2b$10$nTXuak.MROW1r2gGm1fde./LZuVLWb798mxGU8.J.gjCIJEMlKBja', 'admin') ON CONFLICT DO NOTHING;