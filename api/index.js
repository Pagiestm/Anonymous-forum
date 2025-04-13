import express from 'express';
import cors from 'cors';
import messageRoutes from './routes/messageRoutes.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/messages', messageRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API en écoute sur le port ${PORT}`);
});
