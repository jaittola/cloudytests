import React from 'react';
import { AppModel, LogEntry, useStateValue } from './AppModel';

interface LogEntriesViewProps {
    title: string;
    entrySelector: (model: AppModel) => LogEntry[];
}

const LogEntryTableRow: React.FC<LogEntry> = ({ timestamp, text }, idx: number) =>
    <tr key={`log-entry-${idx}`}>
        <td>{timestamp.toISOString()}</td>
        <td>{text}</td>
    </tr>;

export function LogEntriesView({ title, entrySelector }: LogEntriesViewProps) {
    const [appModel] = useStateValue();
    const sortedEntries = entrySelector(appModel)
        .slice(0)
        .sort((first, second) => first.timestamp.getDate() - second.timestamp.getDate());
    return <div>
        <h3>
            {title}
        </h3>
        <table>
            <tbody>
                {sortedEntries.map((entry, idx) => LogEntryTableRow(entry, idx))}
            </tbody>
        </table>
    </div>;
}
