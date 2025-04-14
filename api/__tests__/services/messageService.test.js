// Mock the database module
jest.mock(
  '../../config/db.js',
  () => ({
    query: jest.fn(),
    execute: jest.fn(),
  }),
  { virtual: true }
);

import MessageService from '../../services/messageService.js';
import MessageModel from '../../models/messageModel.js';

jest.mock('../../models/messageModel.js');

describe('MessageService', () => {
  it('devrait retourner tous les messages', async () => {
    const fakeMessages = [{ id: 1, pseudo: 'Alice', content: 'Salut !' }];
    MessageModel.getAll.mockResolvedValue(fakeMessages);

    const result = await MessageService.getMessages();
    expect(result).toEqual(fakeMessages);
    expect(MessageModel.getAll).toHaveBeenCalled();
  });

  it('devrait créer un message', async () => {
    const pseudo = 'Bob';
    const content = 'Hello !';
    const fakeResult = { id: 1, pseudo, content };

    MessageModel.create.mockResolvedValue(fakeResult);

    const result = await MessageService.createMessage(pseudo, content);
    expect(result).toEqual(fakeResult);
    expect(MessageModel.create).toHaveBeenCalledWith(pseudo, content);
  });
});
