const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();
const pool = require('../db/db');
const { signToken, verifyToken } = require('../middleware/jwtUtils');
const axios = require('axios');
const LOG_URL = process.env.LOG_SERVICE_URL || 'http://log-service:3003';

router.post('/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        const result = await pool.query('SELECT * FROM users WHERE username=$1', [username]);
        const user = result.rows[0];
        if (!user) {
            await axios.post(`${LOG_URL}/api/logs`, { event_type: 'login_fail', username, detail: 'user not found' });
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        const match = await bcrypt.compare(password, user.password_hash);
        if (!match) {
            await axios.post(`${LOG_URL}/api/logs`, { event_type: 'login_fail', username, detail: 'wrong password' });
            return res.status(401).json({ error: 'Invalid credentials' });
        }
        const token = signToken({ id: user.id, username: user.username, role: user.role });
        await axios.post(`${LOG_URL}/api/logs`, { event_type: 'login_success', username, detail: 'login ok' });
        res.json({ token });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/verify', (req, res) => {
    const auth = req.headers.authorization;
    if (!auth) return res.status(401).json({ error: 'No token' });
    try {
        const payload = verifyToken(auth.replace('Bearer ', ''));
        res.json({ valid: true, payload });
    } catch {
        res.status(401).json({ valid: false });
    }
});

router.get('/me', (req, res) => {
    const auth = req.headers.authorization;
    if (!auth) return res.status(401).json({ error: 'No token' });
    try {
        const payload = verifyToken(auth.replace('Bearer ', ''));
        res.json(payload);
    } catch {
        res.status(401).json({ error: 'Invalid token' });
    }
});

module.exports = router;