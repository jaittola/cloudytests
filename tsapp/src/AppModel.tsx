import React from 'react';

export interface LogEntry {
    timestamp: Date;
    text: string;
}

export class AppModel {
    searchTerm: string = '';
    searchResultEntries: LogEntry[] = [];
    latestEntries: LogEntry[] = [];

    constructor(initialEntries?: LogEntry[]) {
        this.latestEntries = initialEntries || [];
    }
}

export interface UpdateSearch {
    kind: 'UpdateSearch';
    searchTerm: string;
}

export interface UpdateLogEntries {
    kind: 'UpdateLogEntries';
    entries: LogEntry[];
}

type Action =
    UpdateSearch
    | UpdateLogEntries;

export function appModelReducer(state: AppModel, action: Action): AppModel {
    console.log(`AppModelReducer with action ${action}`);

    switch (action.kind) {
        case 'UpdateSearch': {
            const newState = { ...state };
            newState.searchTerm = (action as UpdateSearch).searchTerm;
            newState.searchResultEntries =
                state.latestEntries
                    .filter((entry) => entry.text.includes(newState.searchTerm));

            return newState;
        }
        case 'UpdateLogEntries': {
            const ue = (action as UpdateLogEntries);
            const newState = { ...state };
            newState.latestEntries = ue.entries;
            return newState;
        }
    }
}

type AppModelAndDispatcher = [AppModel, React.Dispatch<Action>];
type ContextType = AppModelAndDispatcher | null;

export function isSaneCtx(ctx: ContextType): ctx is AppModelAndDispatcher {
    const [appModel, dispatcher] = (ctx as AppModelAndDispatcher);
    return (appModel !== undefined && dispatcher !== undefined);
}

export const AppContext = React.createContext<ContextType>(null);

export function useStateValue(): AppModelAndDispatcher {
    const ctx = React.useContext(AppContext);
    if (isSaneCtx(ctx)) {
        return ctx;
    } else {
        return [new AppModel(), () => {}];
    }
}
