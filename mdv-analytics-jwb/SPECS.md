# JWB Construction Dashboard - Specs

## Phases
1. **ETL & Property Timeline Design**
   - Google Sheets data ingestion
   - Manual JSON timeline structuring
   - Basic Gantt chart by project

2. **Financial Reporting**
   - Revenue, Cost, Profit visuals
   - Based on Salesforce + Excel sheets
   - Filters by month, property, status

3. **Sheets Integration**
   - Direct link to Google Sheets for real-time sync
   - Scheduled Power Query refresh

4. **Upload System ETL**
   - File ingestion with metadata tracking
   - Status monitor (uploaded, transformed, loaded)

5. **Dashboard Expansion**
   - Add pages: Milestone view, QA timeline, Contractor performance

## Stack
- Power BI Pro
- Google Sheets API
- Manual Excel / Salesforce exports (via shared drive)

## Visual Style
- Consistent with MDV branding (Segoe UI, Hex: 252423)
- Page size: 16:9
- Color-coded status (Gray: Planned, Blue: Ongoing, Green: Done)

## Contacts
- Timeline source: Jorge
- Financial tracking: Carla / Delsy
