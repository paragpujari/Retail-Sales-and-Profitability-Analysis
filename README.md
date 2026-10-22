# Retail Sales & Profitability Analysis

**Portfolio project | SQL Server + Excel + Python + Power BI**

## Business objective
Analyze retail order-line data to understand revenue and profit trends, regional performance, product profitability, discount impact, and potential data-quality issues. The repository is designed to demonstrate an end-to-end Data Analyst workflow: understand the data, validate it, analyze KPIs, communicate findings, and build an interactive dashboard.

## Dataset
- `data/retail_orders.csv` — 1,200 synthetic order-line records covering 2024–2025.
- `data/data_dictionary.csv` — field definitions and data-quality notes.
- Data is synthetic and created for this portfolio; it does not represent a real company or customer. A few deliberate data-quality issues (missing customer IDs and zero quantities) are included for validation practice.

## Project workflow
1. **Business understanding:** define revenue, profit, margin, order count, units sold and loss-making lines.
2. **Data quality:** inspect missing identifiers, duplicates, invalid quantities, negative values and null metrics.
3. **SQL analysis:** run the queries in `sql/retail_analysis.sql` in SQL Server after importing the CSV as `dbo.retail_orders`.
4. **Python analysis:** create a virtual environment, install dependencies and run the script to produce QA results, KPI tables and charts.
5. **Excel analysis:** use `excel/Retail_Sales_Analysis.xlsx` for filtering, summary review and PivotTable practice.
6. **Power BI:** follow `powerbi/POWER_BI_DASHBOARD_GUIDE.md` to build an interactive report.
7. **Recommendations:** write a short executive summary based on verified results, not assumptions.

## Run the Python analysis
```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
python python/analyze_retail.py
```
Outputs are written to `outputs/` (created when the script runs).

## KPIs
- **Revenue:** sum of net sales after discounts.
- **Profit:** net sales minus estimated product cost.
- **Profit margin:** total profit divided by total revenue.
- **Order lines:** distinct order-line identifiers.
- **Units sold:** sum of quantity.
- **Loss-making lines:** rows with profit below zero.

## Repository structure
```text
Retail-Sales-Profitability-Analysis/
├── data/       # synthetic CSV and data dictionary
├── sql/        # SQL Server analysis queries
├── python/     # reproducible QA, KPI tables and chart generation
├── excel/      # workbook with raw data and KPI summaries
├── powerbi/    # dashboard build guide and DAX measures
├── docs/       # add screenshots and final business insights here
└── requirements.txt
```

## Deliverables checklist
- [x] Synthetic dataset and data dictionary
- [x] SQL analysis and data-quality queries
- [x] Python analysis script
- [x] Excel workbook with KPI sheets
- [x] Power BI build guide and DAX measures
- [ ] Build and save the `.pbix` dashboard in Power BI Desktop
- [ ] Add dashboard screenshots to `docs/`
- [ ] Write a one-page executive summary with measured findings

## Important
This repository includes a dashboard build guide, not a prebuilt Power BI `.pbix` file. Review outputs and complete the remaining checklist before describing the dashboard as finished on your resume.
