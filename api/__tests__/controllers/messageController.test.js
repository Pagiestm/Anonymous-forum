// Mock the database module
jest.mock(
  '../../config/db.js',
  () => ({
    query: jest.fn(),
    execute: jest.fn(),
  }),
  { virtual: true }
);

import { getAllMessages, postMessage } from '../../controllers/messageController.js';
import MessageService from '../../services/messageService.js';

// Mock the MessageService
jest.mock('../../services/messageService.js');

describe('MessageController', () => {
  // Setup mock request and response objects
  let mockReq;
  let mockRes;
  let originalConsoleError;

  beforeAll(() => {
    // Store the original console.error
    originalConsoleError = console.error;
    // Replace console.error with a mock function to suppress logs during tests
    console.error = jest.fn();
  });

  afterAll(() => {
    // Restore the original console.error after tests
    console.error = originalConsoleError;
  });

  beforeEach(() => {
    // Reset mocks before each test
    jest.clearAllMocks();

    // Setup fresh mocks for each test
    mockReq = {
      body: {},
    };

    mockRes = {
      json: jest.fn().mockReturnThis(),
      status: jest.fn().mockReturnThis(),
    };
  });

  describe('getAllMessages', () => {
    it('devrait retourner tous les messages avec un statut 200', async () => {
      // Arrange
      const mockMessages = [
        { id: 1, pseudo: 'Alice', content: 'Bonjour!' },
        { id: 2, pseudo: 'Bob', content: 'Salut!' },
      ];
      MessageService.getMessages.mockResolvedValue(mockMessages);

      // Act
      await getAllMessages(mockReq, mockRes);

      // Assert
      expect(MessageService.getMessages).toHaveBeenCalledTimes(1);
      expect(mockRes.json).toHaveBeenCalledWith(mockMessages);
    });

    it('devrait retourner une erreur 500 si la récupération échoue', async () => {
      // Arrange
      const mockError = new Error('Erreur de base de données');
      MessageService.getMessages.mockRejectedValue(mockError);

      // Act
      await getAllMessages(mockReq, mockRes);

      // Assert
      expect(MessageService.getMessages).toHaveBeenCalledTimes(1);
      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Erreur serveur' });
      // Verify error was logged
      expect(console.error).toHaveBeenCalledWith(
        'Erreur lors de la récupération des messages:',
        mockError
      );
    });
  });

  describe('postMessage', () => {
    it('devrait créer un message et retourner un statut 201', async () => {
      // Arrange
      const pseudo = 'Alice';
      const content = 'Mon message de test';
      const createdMessage = { id: 1, pseudo, content, created_at: new Date() };

      mockReq.body = { pseudo, content };
      MessageService.createMessage.mockResolvedValue(createdMessage);

      // Act
      await postMessage(mockReq, mockRes);

      // Assert
      expect(MessageService.createMessage).toHaveBeenCalledWith(pseudo, content);
      expect(mockRes.status).toHaveBeenCalledWith(201);
      expect(mockRes.json).toHaveBeenCalledWith(createdMessage);
    });

    it('devrait retourner une erreur 400 si le pseudo est manquant', async () => {
      // Arrange
      mockReq.body = { content: 'Un message sans pseudo' };

      // Act
      await postMessage(mockReq, mockRes);

      // Assert
      expect(MessageService.createMessage).not.toHaveBeenCalled();
      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Champs manquants' });
    });

    it('devrait retourner une erreur 400 si le contenu est manquant', async () => {
      // Arrange
      mockReq.body = { pseudo: 'Alice' };

      // Act
      await postMessage(mockReq, mockRes);

      // Assert
      expect(MessageService.createMessage).not.toHaveBeenCalled();
      expect(mockRes.status).toHaveBeenCalledWith(400);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Champs manquants' });
    });

    it('devrait retourner une erreur 500 si la création échoue', async () => {
      // Arrange
      const mockError = new Error('Erreur de base de données');
      mockReq.body = { pseudo: 'Alice', content: 'Message test' };

      MessageService.createMessage.mockRejectedValue(mockError);

      // Act
      await postMessage(mockReq, mockRes);

      // Assert
      expect(MessageService.createMessage).toHaveBeenCalledTimes(1);
      expect(mockRes.status).toHaveBeenCalledWith(500);
      expect(mockRes.json).toHaveBeenCalledWith({ error: 'Erreur serveur' });
      // Verify error was logged
      expect(console.error).toHaveBeenCalledWith("Erreur lors de l'envoi du message:", mockError);
    });
  });
});
