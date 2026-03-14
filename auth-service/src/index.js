const express = require('express');
const app = express();
app.use(express.json());
app.use('/api/auth', require('./routes/auth'));
app.listen(3001, () => console.log('Auth service running on 3001'));