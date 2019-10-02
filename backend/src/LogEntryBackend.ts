import { Request, Response } from 'express';
import pgPromise, { QueryFile } from 'pg-promise';

const dbEnv = process.env.DB_URI;
if (dbEnv === null || dbEnv === undefined) {
    console.error('You must define DB_URI environment variable.');
    console.error('For example, export DB_URI="postgresql://user:secret@localhost:5432/databasename"');
    process.exit(1);
}

const pg = pgPromise();
const db = pg(dbEnv as string);

const queries = {
    list: new QueryFile('../sql/query-log-entries.sql'),
    insert: new QueryFile('../sql/insert-log-entry.sql'),
    search: new QueryFile('../sql/search-log-entries.sql'),
};

function requireString(val: any): string {
    if (val === null || val === undefined) {
        throw new Error('Missing required value');
    }
    return val.toString();
}

class LogEntryBackend {
    async saveLogEntry(req: Request, res: Response) {
        try {
            await db.none(queries.insert, { text: requireString(req.body.text) });
            this.getLatestEntries(res);
        } catch (e) {
            console.error('SUCH FAIL', e);
            res.sendStatus(400);
        }
    }

    async getLatestEntries(res: Response) {
        try {
            const entries = await db.query(queries.list, { limit: 100 });
            res.send(entries);
        } catch (e) {
            console.error('SUCH FAIL IN QUERY', e);
            res.sendStatus(500);
        }
    }

    async search(req: Request, res: Response) {
        try {
            const results = await db.query(queries.search, {
                term: `%${requireString(req.query.term)}%`,
                limit: 100,
            });
            res.send(results);
        } catch (e) {
            console.error('SUCH FAIL IN SEARCH', e);
            res.sendStatus(400);
        }
    }

    async health(res: Response) {
        try {
            await db.query('SELECT 1');
            res.sendStatus(200);
        } catch (e) {
            console.error('HEALTH CHECK FAILED', e);
            res.sendStatus(500);
        }
    }
}

export const logEntryBackend = new LogEntryBackend();
export default logEntryBackend;
