import React from 'react';
import './App.css';
import { AppContext, AppModel, appModelReducer } from './AppModel';
import { LogEntriesView } from './LogEntries';
import { NewLogEntryView } from './NewLogEntry';
import { SearchInput } from './SearchInput';

const App: React.FC = () => {
  const initialAppModel = new AppModel([
    { timestamp: new Date(2011, 2, 1, 12, 0, 0), text: 'A very old log entry' },
    { timestamp: new Date(), text: 'My first log entry' },
  ]);

  const reducer = React.useReducer(appModelReducer, initialAppModel);

  return (
    <AppContext.Provider value={reducer}>
      <div className="App">
        <h1>
          This is the log book
        </h1>

        <LogEntriesView title="Latest log entries" entrySelector={(model) => model.latestEntries} />

        <h3>New entry</h3>

        <NewLogEntryView/>

        <h3>Search</h3>

        <SearchInput placeholderValue="Enter search term" />

        <LogEntriesView title="Search results" entrySelector={(model) => model.searchResultEntries} />

      </div>
    </AppContext.Provider>
  );
};

export default App;
