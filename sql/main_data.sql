CREATE TABLE IF NOT EXISTS events_clean (
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
    strategic_theme TEXT,
    event_count INTEGER DEFAULT 1
);
