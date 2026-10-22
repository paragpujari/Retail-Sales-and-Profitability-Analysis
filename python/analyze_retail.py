"""Reproducible data-quality checks and analysis for the retail portfolio."""
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "retail_orders.csv"
OUT = ROOT / "outputs"
OUT.mkdir(exist_ok=True)
df = pd.read_csv(DATA, parse_dates=["order_date"])

# Basic QA report
qa = pd.DataFrame({
    "check": ["row_count", "duplicate_order_ids", "missing_customer_ids", "nonpositive_quantity", "negative_sales", "missing_profit"],
    "result": [len(df), df.order_id.duplicated().sum(), df.customer_id.isna().sum(), (df.quantity <= 0).sum(), (df.sales < 0).sum(), df.profit.isna().sum()]
})
qa.to_csv(OUT / "data_quality_report.csv", index=False)

# Analysis tables
monthly = df.assign(month=df.order_date.dt.to_period("M").dt.to_timestamp()).groupby("month", as_index=False).agg(revenue=("sales","sum"), profit=("profit","sum"), order_lines=("order_id","nunique"))
monthly["profit_margin_pct"] = (monthly.profit / monthly.revenue * 100).round(2)
monthly.to_csv(OUT / "monthly_kpis.csv", index=False)
region = df.groupby("region", as_index=False).agg(revenue=("sales","sum"), profit=("profit","sum"), orders=("order_id","nunique"))
region["profit_margin_pct"] = (region.profit / region.revenue * 100).round(2)
region.sort_values("revenue", ascending=False).to_csv(OUT / "regional_kpis.csv", index=False)
product = df.groupby(["category","product"], as_index=False).agg(revenue=("sales","sum"), profit=("profit","sum"), units_sold=("quantity","sum"))
product.sort_values("profit", ascending=False).to_csv(OUT / "product_profitability.csv", index=False)

df["discount_band"] = pd.cut(df.discount_pct, bins=[-0.001,0,0.10,0.20,0.301], labels=["0%","1-10%","11-20%","21-30%"])
discount = df.groupby("discount_band", observed=False, as_index=False).agg(order_lines=("order_id","count"), revenue=("sales","sum"), profit=("profit","sum"))
discount["profit_margin_pct"] = (discount.profit / discount.revenue * 100).round(2)
discount.to_csv(OUT / "discount_impact.csv", index=False)

# Charts suitable for report/dashboard previews
plt.figure(figsize=(10,5)); plt.plot(monthly.month, monthly.revenue, marker="o"); plt.title("Monthly Revenue Trend"); plt.xlabel("Month"); plt.ylabel("Revenue"); plt.xticks(rotation=45); plt.tight_layout(); plt.savefig(OUT/"monthly_revenue.png", dpi=150); plt.close()
plt.figure(figsize=(8,5)); r=region.sort_values("revenue"); plt.barh(r.region, r.revenue); plt.title("Revenue by Region"); plt.xlabel("Revenue"); plt.tight_layout(); plt.savefig(OUT/"revenue_by_region.png", dpi=150); plt.close()
print("Analysis complete. See outputs/ for KPI tables, QA report, and charts.")
