import { array, date, field, string, succeed } from 'jsonous';
import { LogEntry } from '../../common-ts/src/LogEntry';

const backendBaseUrl = process.env.REACT_APP_BACKEND || 'http://localhost:8000/api/1/';
const saveNewEntryUrl = `${backendBaseUrl}save`;
const getLatestEntriesUrl = `${backendBaseUrl}get-latest`;
const searchUrl = `${backendBaseUrl}search?term=`;

export async function saveNewEntryToBackend(entry: string): Promise<LogEntry[]> {
    return fetch(saveNewEntryUrl,
        {
            method: 'PUT',
            headers: [['Content-Type', 'application/json']],
            body: JSON.stringify({ text: entry }),
        })
        .then((response) => parseLogEntry(response.text()));
}

export async function getLogEntries(): Promise<LogEntry[]> {
    return fetch(getLatestEntriesUrl)
        .then((response) => parseLogEntry(response.text()));
}

export async function searchLogEntries(searchTerm: string): Promise<LogEntry[]> {
    return fetch(`${searchUrl}${encodeURIComponent(searchTerm)}`)
    .then((response) => parseLogEntry(response.text()));
}

async function parseLogEntry(jsonPromise: Promise<string>): Promise<LogEntry[]> {
    return jsonPromise
        .then((jsonString) => array(logEntryDecoder)
            .decodeJson(jsonString)
            .getOrElse(() => { throw new Error('Invalid JSON input'); }));
}

const logEntryDecoder =
    succeed({})
        .assign('text', field('text', string))
        .assign('timestamp', field('timestamp', date));
