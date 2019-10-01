import React from 'react';
import './App.css';
import { AppContext, AppModel, appModelReducer } from './AppModel';
import { getLogEntries } from './BackendRequests';
import { LogEntriesView } from './LogEntries';
import { NewLogEntryView } from './NewLogEntry';
import { SearchInput } from './SearchInput';
import { SearchResultView } from './SearchResultView';

const App: React.FC = () => {
  const reducer = React.useReducer(appModelReducer, new AppModel());

  React.useEffect(() => {
    const fetchData = async () => {
      const logEntries = await getLogEntries();
      const [, dispatcher] = reducer;
      dispatcher({ kind: 'UpdateLogEntries', entries: logEntries });
    };
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <AppContext.Provider value={reducer}>
      <div className="App">
        <h1>
          This is the log book
        </h1>

        <LogEntriesView title="Latest log entries" entrySelector={(model) => model.latestEntries} />

        <h3>New entry</h3>

        <NewLogEntryView />

        <h3>Search</h3>

        <SearchInput placeholderValue="Enter search term" />

        <SearchResultView title="Search results" />

      </div>
    </AppContext.Provider>
  );
};

export default App;
