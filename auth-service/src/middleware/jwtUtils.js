const jwt = require('jsonwebtoken');
const SECRET = process.env.JWT_SECRET || 'supersecret';

function signToken(payload) {
  return jwt.sign(payload, SECRET, { expiresIn: '1h' });
}
function verifyToken(token) {
  return jwt.verify(token, SECRET);
}
module.exports = { signToken, verifyToken };