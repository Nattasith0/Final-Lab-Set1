CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'member',
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'TODO' CHECK (
        status IN ('TODO', 'IN_PROGRESS', 'DONE')
    ),
    priority VARCHAR(10) DEFAULT 'medium' CHECK (
        priority IN ('low', 'medium', 'high')
    ),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS logs (
    id SERIAL PRIMARY KEY,
    service VARCHAR(50) NOT NULL,
    level VARCHAR(10) NOT NULL CHECK (
        level IN ('INFO', 'WARN', 'ERROR')
    ),
    event VARCHAR(100) NOT NULL,
    user_id INTEGER,
    ip_address VARCHAR(45),
    method VARCHAR(10),
    path VARCHAR(255),
    status_code INTEGER,
    message TEXT,
    meta JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_logs_service ON logs (service);

CREATE INDEX IF NOT EXISTS idx_logs_level ON logs (level);

CREATE INDEX IF NOT EXISTS idx_logs_created_at ON logs (created_at DESC);

INSERT INTO
    users (
        username,
        email,
        password_hash,
        role
    )
VALUES (
        'alice',
        'alice@lab.local',
        '$2b$10$B6F4vixrIJR3FbfnmGB2Ces3rD3rLYUVe/1dAU.VA0HUXAJIKhhU2',
        'member'
    ),
    (
        'bob',
        'bob@lab.local',
        '$2b$10$mykVt7uU5VBVFn2SVA5rA.efmMhsyVY2b6wDxn49G9ygJhrigvQYK',
        'member'
    ),
    (
        'admin',
        'admin@lab.local',
        '$2b$10$hjjbapEIf7XqyH7r0ZCC6eT3zcb5G/MhLXuXf7feYler/dkVqWo5q',
        'admin'
    ) ON CONFLICT (username) DO
UPDATE
SET
    email = EXCLUDED.email,
    password_hash = EXCLUDED.password_hash,
    role = EXCLUDED.role;