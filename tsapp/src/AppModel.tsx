import React from 'react';
import LogEntry from '../../common-ts/src/LogEntry';

export class AppModel {
    searchTerm: string = '';
    searchResultEntries: LogEntry[] = [];
    latestEntries: LogEntry[] = [];
}

export interface UpdateSearch {
    kind: 'UpdateSearch';
    searchTerm: string;
}

export interface UpdateLogEntries {
    kind: 'UpdateLogEntries';
    entries: LogEntry[];
}

export interface UpdateSearchResults {
    kind: 'UpdateSearchResults';
    entries: LogEntry[];
}

type Action =
    UpdateSearch
    | UpdateLogEntries
    | UpdateSearchResults;

export function appModelReducer(state: AppModel, action: Action): AppModel {
    switch (action.kind) {
        case 'UpdateSearch': {
            const newState = { ...state };
            newState.searchTerm = (action as UpdateSearch).searchTerm;
            return newState;
        }
        case 'UpdateLogEntries': {
            const ue = (action as UpdateLogEntries);
            const newState = { ...state };
            newState.latestEntries = ue.entries;
            return newState;
        }
        case 'UpdateSearchResults': {
            const usr = action as UpdateSearchResults;
            const newState = { ...state };
            newState.searchResultEntries = usr.entries;
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
        return [new AppModel(), () => { }];
    }
}
