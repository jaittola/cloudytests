import bodyParser from 'body-parser';
import cors from 'cors';
import express from 'express';
import logEntryBackend from './LogEntryBackend';

const app = express();
const port = 8000;
const frontendUri = process.env.FRONTEND_URI || 'http://localhost:3000';

app.use(bodyParser.json());
app.use(cors({ origin: frontendUri, optionsSuccessStatus: 200 }));

app.get('/', (_req, res) => res.redirect(frontendUri));
app.put('/api/1/save', (req, res) => logEntryBackend.saveLogEntry(req, res));
app.get('/api/1/get-latest', (_req, res) => logEntryBackend.getLatestEntries(res));
app.get('/api/1/search', (req, res) => logEntryBackend.search(req, res));
app.get('/health', (_req, res) => logEntryBackend.health(res));

app.listen(port, () => console.log(`Listening to port ${port}`));
