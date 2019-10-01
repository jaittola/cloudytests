CREATE TABLE IF NOT EXISTS log_entries (
    log_entries_id SERIAL PRIMARY KEY,
    log_entries_text VARCHAR NOT NULL,
    log_entries_timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);
