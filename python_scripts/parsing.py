import zipfile
import json
import os
import csv
from tqdm import tqdm

# -----------------------------
# Paths
# -----------------------------
ZIP_PATH = r"C:\Firmable_DQ\input_data\Datasets-2025-08-08.zip"
OUTPUT_FOLDER = r"C:\Firmable_DQ\output"
OUT_CSV = os.path.join(OUTPUT_FOLDER, "parsed_news_events.csv")

# Ensure output folder exists
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# -----------------------------
# Flatten JSON function
# -----------------------------
def flatten_event(item, included):
    """Flatten a single event JSON object and extract company info."""
    a = item.get("attributes", {})
    company = None
    for inc in included:
        if inc.get("type") == "company":
            company = inc.get("attributes", {})
            break
    return {
        "event_id": item.get("id"),
        "category": a.get("category"),
        "summary": a.get("summary"),
        "award": a.get("award"),
        "product": a.get("product"),
        "location": a.get("location"),
        "effective_date": a.get("effective_date"),
        "found_at": a.get("found_at"),
        "confidence": a.get("confidence"),
        "company_name": company.get("company_name") if company else None,
        "company_domain": company.get("domain") if company else None,
    }

# -----------------------------
# CSV fieldnames
# -----------------------------
fieldnames = [
    "event_id",
    "category",
    "summary",
    "award",
    "product",
    "location",
    "effective_date",
    "found_at",
    "confidence",
    "company_name",
    "company_domain",
]

# -----------------------------
# Parse JSON/JSONL files from ZIP and write CSV
# -----------------------------
total_rows = 0
sample_record = None

with zipfile.ZipFile(ZIP_PATH, "r") as z, open(OUT_CSV, "w", newline="", encoding="utf-8") as out_f:
    writer = csv.DictWriter(out_f, fieldnames=fieldnames)
    writer.writeheader()

    # List all JSON/JSONL files (skip __MACOSX or hidden files)
    json_files = [f for f in z.namelist() if f.lower().endswith((".json", ".jsonl")) and "__macosx" not in f.lower()]
    print(f"Found {len(json_files)} JSON/JSONL files in zip.")

    for file in tqdm(json_files, desc="Processing JSON files"):
        with z.open(file) as f:
            for raw in f:
                try:
                    line = raw.decode("utf-8").strip()
                except Exception:
                    continue
                if not line:
                    continue
                try:
                    data = json.loads(line)
                except json.JSONDecodeError:
                    continue

                # Some JSONs have 'data' as a list of events
                for item in data.get("data", []):
                    row = flatten_event(item, data.get("included", []))
                    if sample_record is None:
                        sample_record = row
                    writer.writerow(row)
                    total_rows += 1

print("Sample record:", sample_record if sample_record else "(none)")
print("Total parsed rows:", total_rows)
print(f" CSV saved to: {OUT_CSV}")
