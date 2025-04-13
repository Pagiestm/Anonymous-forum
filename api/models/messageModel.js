import db from '../config/db.js';

class MessageModel {
  static async getAll() {
    return new Promise((resolve, reject) => {
      db.query('SELECT * FROM messages ORDER BY created_at DESC', (err, results) => {
        if (err) reject(err);
        else resolve(results);
      });
    });
  }

  static async create(pseudo, content) {
    return new Promise((resolve, reject) => {
      db.query(
        'INSERT INTO messages (pseudo, content) VALUES (?, ?)',
        [pseudo, content],
        (err, result) => {
          if (err) reject(err);
          else resolve({ id: result.insertId, pseudo, content });
        }
      );
    });
  }
}

export default MessageModel;
