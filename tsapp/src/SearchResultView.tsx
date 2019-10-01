import React from 'react';
import { useStateValue } from './AppModel';
import { searchLogEntries } from './BackendRequests';
import { LogEntryTableRow } from './LogEntries';

export function SearchResultView(props: { title: string }) {
    const [appModel, dispatcher] = useStateValue();
    const searchTerm = appModel.searchTerm;

    React.useEffect(() => {
        const fetchData = async () => {
            const trimmedSearch = searchTerm.trim();
            const searchResults = (trimmedSearch !== '') ? await searchLogEntries(searchTerm) : [];
            dispatcher({ kind: 'UpdateSearchResults', entries: searchResults });
        };
        fetchData();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [searchTerm]);

    const sortedEntries = appModel.searchResultEntries
        .slice(0)
        .sort((first, second) => first.timestamp.getDate() - second.timestamp.getDate());
    return <div>
        <h3>
            {props.title}
        </h3>
        <table>
            <tbody>
                {sortedEntries.map((entry, idx) => LogEntryTableRow(entry, idx))}
            </tbody>
        </table>
    </div>;
}
