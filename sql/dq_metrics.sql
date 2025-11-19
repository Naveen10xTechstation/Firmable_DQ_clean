-- SQL: dq_metrics.sql
-- Calculates table- and column-level data quality metrics for cleaned_business_data.

-- Example: record counts and completeness per column
CREATE TABLE IF NOT EXISTS dq_run_log (
    run_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Table-level metrics
CREATE TABLE IF NOT EXISTS dq_table_metrics (
    run_id INTEGER,
    table_name TEXT,
    row_count INTEGER,
    distinct_event_ids INTEGER,
    duplicate_event_ids INTEGER,
    PRIMARY KEY (run_id, table_name)
);

-- Column-level metrics
CREATE TABLE IF NOT EXISTS dq_column_metrics (
    run_id INTEGER,
    table_name TEXT,
    column_name TEXT,
    non_null_count INTEGER,
    null_count INTEGER,
    completeness REAL,
    distinct_count INTEGER,
    PRIMARY KEY (run_id, table_name, column_name)
);

-- Example INSERT queries to compute metrics from cleaned_business_data
-- 1) table-level metrics
INSERT INTO dq_table_metrics (run_id, table_name, row_count, distinct_event_ids, duplicate_event_ids)
SELECT
    (SELECT COALESCE(MAX(run_id), 0) + 1 FROM dq_run_log) as run_id,
    'cleaned_business_data' as table_name,
    COUNT(*) as row_count,
    COUNT(DISTINCT event_id) as distinct_event_ids,
    COUNT(*) - COUNT(DISTINCT event_id) as duplicate_event_ids
FROM cleaned_business_data;

-- 2) column-level metrics (example for a few columns)
INSERT INTO dq_column_metrics (run_id, table_name, column_name, non_null_count, null_count, completeness, distinct_count)
SELECT
    (SELECT COALESCE(MAX(run_id), 0) FROM dq_run_log) as run_id,
    'cleaned_business_data' as table_name,
    col.column_name,
    SUM(CASE WHEN col.value IS NOT NULL AND col.value != '' THEN 1 ELSE 0 END) as non_null_count,
    SUM(CASE WHEN col.value IS NULL OR col.value = '' THEN 1 ELSE 0 END) as null_count,
    1.0 * SUM(CASE WHEN col.value IS NOT NULL AND col.value != '' THEN 1 ELSE 0 END) / COUNT(*) as completeness,
    COUNT(DISTINCT col.value) as distinct_count
FROM (
    SELECT event_id, company_name as value, 'company_name' as column_name FROM cleaned_business_data
    UNION ALL
    SELECT event_id, company_domain as value, 'company_domain' as column_name FROM cleaned_business_data
    UNION ALL
    SELECT event_id, category as value, 'category' as column_name FROM cleaned_business_data
) col
GROUP BY col.column_name;
