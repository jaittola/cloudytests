SELECT log_entries_text AS text,
       log_entries_timestamp AS timestamp
FROM log_entries
ORDER BY log_entries_timestamp DESC
LIMIT ${limit};
