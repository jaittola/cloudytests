import React from 'react';
import { useStateValue } from './AppModel';
import { saveNewEntryToBackend } from './BackendRequests';

export function NewLogEntryView() {
    const [, dispatcher] = useStateValue();
    const [logEntryText, setLogEntryText] = React.useState('');

    async function createLogEntry() {
        const trimmed = logEntryText.trim();
        if (trimmed !== '') {
            try {
                const newLatestEntries = await saveNewEntryToBackend(trimmed);
                dispatcher({
                    kind: 'UpdateLogEntries',
                    entries: newLatestEntries,
                });
                setLogEntryText('');
            } catch (e) {
                console.error('Saving log entry failed', e);
            }
        }
    }

    function saveOnEnter(key: string) {
        if (key === 'Enter') {
            createLogEntry();
        }
    }

    return (
        <>
            <div>
                <span>Enter new log entry: </span>
                <input type="text"
                    placeholder="new entry"
                    value={logEntryText}
                    onChange={(e) => setLogEntryText(e.target.value)}
                    onKeyUp={(e) => saveOnEnter(e.key)} />
                <button
                    onClick={createLogEntry}
                    disabled={logEntryText.trim().length === 0}>
                    Save
                </button>
            </div>
        </>
    );
}
