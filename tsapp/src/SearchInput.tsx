import React from 'react';
import { useStateValue } from './AppModel';

export function SearchInput(props: { placeholderValue: string }) {
    const [appModel, dispatcher] = useStateValue();

    return (
        <input
            type="text"
            placeholder={props.placeholderValue}
            value={appModel.searchTerm}
            onChange={(e) => dispatcher({ kind: 'UpdateSearch', searchTerm: e.target.value })} />
    );
}
