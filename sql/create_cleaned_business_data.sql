-- SQL: create_cleaned_business_data.sql
-- Creates the cleaned_business_data table used by the data-quality pipeline.

CREATE TABLE IF NOT EXISTS cleaned_business_data (
    event_id TEXT PRIMARY KEY,
    category TEXT,
    summary TEXT,
    found_at DATE,
    confidence REAL,
    company_name TEXT,
    company_domain TEXT,
    domain_company TEXT,
    name_clean TEXT,
    domain_match BOOLEAN,
    Event_Count_x INTEGER,
    Strategic_Theme TEXT,
    Event_Count_y INTEGER,
    Percentage REAL
);
