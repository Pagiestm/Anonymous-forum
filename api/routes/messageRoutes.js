import express from 'express';
import { getAllMessages, postMessage } from '../controllers/messageController.js';

const router = express.Router();

router.get('/', getAllMessages);
router.post('/', postMessage);

export default router;
