# Power BI Dashboard Build Guide

## Load data
1. Open Power BI Desktop → **Get data → Text/CSV** → select `data/retail_orders.csv`.
2. Set `order_date` to Date; set `sales`, `cost`, `profit`, `unit_price` to Decimal Number; set `discount_pct` to Decimal Number; set `quantity` and `ship_days` to Whole Number.
3. In Power Query, review null `customer_id` values and nonpositive quantities. Keep raw rows for transparency; use a cleaned reference query or flag bad rows rather than silently deleting them.

## Create DAX measures
```DAX
Total Revenue = SUM(retail_orders[sales])
Total Profit = SUM(retail_orders[profit])
Profit Margin % = DIVIDE([Total Profit], [Total Revenue], 0)
Order Lines = DISTINCTCOUNT(retail_orders[order_id])
Units Sold = SUM(retail_orders[quantity])
Average Discount % = AVERAGE(retail_orders[discount_pct])
Loss-Making Lines = CALCULATE(COUNTROWS(retail_orders), retail_orders[profit] < 0)
```

## Suggested one-page report
- KPI cards: Total Revenue, Total Profit, Profit Margin %, Order Lines, Units Sold.
- Line chart: Month (from `order_date`) by Total Revenue and Total Profit.
- Clustered bar chart: Region by Total Revenue / Total Profit.
- Bar chart: Product by Total Profit; show top 10 by revenue in a separate visual.
- Column chart: Discount band by Profit Margin %. Create a calculated column with bands 0%, 1–10%, 11–20%, 21–30%.
- Slicers: Date, Region, Category, Segment, Ship Mode.
- Detail table: order_id, product, sales, cost, profit, discount_pct; conditional-format negative profit.

## Business questions to answer
1. Which months show the highest and lowest revenue?
2. Which regions drive revenue and which have the strongest margin?
3. Which products contribute most to profit?
4. Do larger discounts correlate with weaker profit margins?
5. Which order lines are loss-making and deserve investigation?

Do not report a business conclusion until you validate it against the imported data and filters.
