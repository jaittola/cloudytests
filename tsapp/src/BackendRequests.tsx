import { LogEntry } from './AppModel';

enum Method {
    Get = 'GET',
    Put = 'PUT',
}

interface BackendUrl {
    method: Method;
    url: string;
}

class PutUrl implements BackendUrl {
    method = Method.Put;
    constructor(public url: string) {}
}

class GetUrl implements BackendUrl {
    method = Method.Get;
    constructor(public url: string) {}
}

const backendBaseUrl = 'http://localhost:8000/api/1/';
const saveNewEntryUrl = new PutUrl(`${backendBaseUrl}/save`);
const getLatestEntriesUrl = new GetUrl(`${backendBaseUrl}/get-latest`);

export async function saveNewEntryToBackend(entry: string): Promise<LogEntry[]> {
    return new Promise((resolve) => {
        setTimeout(() => resolve([
            { timestamp: new Date(2011, 2, 1, 12, 0, 0), text: 'A very old log entry' },
            { timestamp: new Date(), text: 'My first log entry' },
            { timestamp: new Date(), text: entry },
        ]), 5000);
    });
}
