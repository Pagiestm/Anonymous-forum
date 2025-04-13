import MessageService from '../services/messageService.js';

export const getAllMessages = async (req, res) => {
  try {
    const messages = await MessageService.getMessages();
    res.json(messages);
  } catch (err) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

export const postMessage = async (req, res) => {
  const { pseudo, content } = req.body;

  if (!pseudo || !content) {
    return res.status(400).json({ error: 'Champs manquants' });
  }

  try {
    const message = await MessageService.createMessage(pseudo, content);
    res.status(201).json(message);
  } catch (err) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};
