const bcrypt = require('bcrypt');

async function main() {
  console.log('alice123:', await bcrypt.hash('alice123', 10));
  console.log('bob456:', await bcrypt.hash('bob456', 10));
  console.log('adminpass:', await bcrypt.hash('adminpass', 10));
}
main();