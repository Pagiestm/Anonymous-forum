import MessageModel from '../models/messageModel.js';

class MessageService {
  static async getMessages() {
    return await MessageModel.getAll();
  }

  static async createMessage(pseudo, content) {
    return await MessageModel.create(pseudo, content);
  }
}

export default MessageService;
