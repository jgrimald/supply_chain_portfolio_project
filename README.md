# Supply Chain Margin Optimization Analysis

**Tools: ** PostgreSQL, Power BI
**Context: ** Independent porfolio project analyzing a small business supply chain dataset to identify margin improvement opportunities across SKUs, suppliers, logistics, and product categories.

**Business Problem**

A small business operating across multiple product categories and supplier relationships needed a clearer picture of where profit was actually being generated - and where it was being eroded. The goal was to move beyond top-line revenue and identify specific, actionable levers across the supply chain that could improve overall margin.

**Approach**

The analysis was built in two layers: SQL for data modeling and aggregation, and Power BI for executive-ready visualization and strategic output.

**SQL** was used to clean and standardize the raw supply chain dataset, then engineer four purpose-built analytical tables

**- SKU Profitability table** - normalized revenue, cost, and profit per unit across all SKUs; applied window functions to rank SKUs by profit, segment them into performance tiers (High/Low/Loss), and calculate each SKU's contribution to total profit an cumulative profit percentage
**- Logistics Table** - aggregated weighted shipping cost, shipping time, and a composite logistics burden score by carrier, transportation mode, and route
**- Supplier Table** - calculated total profit, weighted average defect rate, average lead time, and unit manufacturing cost by supplier
**- Product Type Table** - summarized revenue, cost per unit, revenue per unit, defect rate, and total units sold by product category

Each table was built using CTEs for readability and reusability, with ```NULLIF``` guards throughout to prevent divide-by-zero errors on sparse data.

**Dashboard**

The Power BI report contains five pages, each addressing a distinct strategic question.

**Page 1 - Executive Overview**

**Key finding:** Profit is concentrated among a subset of SKUs, driven more by sales volume than by unit margin. While 57% of SKUs fall into the high-profit segment, a meaningful share of the portfolio contributes inefficiently - indicating clear opportunities to optimize SKU focus.

**Page 2 - SKU Performance**

**Key finding:** There is no strong relationship between units sold and total profit across SKUs, meaning volume alone is not the driver of profitability. Several high-profit SKUs perform well despite relatively low sales volumes, pointing to strong unit economics. Haircare SKUs in particular (SKU2, SKU51, SKU24, SKU79) show high profit with comparatively low unit sales - targeted efforts to grow these SKUs represent the highest-leverage opportunity in the portfolio. Conversely, moderate-to-high volume SKUs with weak margins are diluting overall performance and are candidates for rationalization.

**Page 3 - Supplier Analysis**

**Key finding:** Supplier performance reveals a clear cost-quality tradeoff. Supplier 1 is the most strategically valuable - high profit contribution and low defect rates. Supplier 4 offers strong quality and lead times but at a significant cost premium, best used selectively for quality-critical needs. Supplier 2 is balanced and suitable for scaling to reduce concentration risk. Suppliers 3 and 5 combine higher defect rates with lower profit contribution and represent high-risk, low-return relationships that warrant reduction or replacement.

| Supplier | Profit | Defect Rate | Recommendation |
|----------|--------|-------------|----------------|
| Supplier 1 | High | Low | Prioritize - primary partner |
| Supplier 2 | Moderate | Moderate | Expand — reduce concentration risk |
| Supplier 4 | Moderate | Low | Selective - quality-critical use only |
| Supplier 3 | Low | High | Reduce exposure |
| Supplier 5 | Low | High | Reduce exposure |

**Page 4 - Logistics Analysis**

**Key finding:** A cost-speed tradeoff exists across carriers. Carrier B delivers the fastest shipping times at premium cost; Carrier A is slower but significantly cheaper. Route A carries the highest logistics burden while Route C is the most efficient. Current operations are disproportionately reliant on Carrier B, reflecting a bias toward speed over cost efficiency. The recommended approach is to align carrier selection with route-level need - reserving Carrier B for time-sensitive deliveries and shifting high-burden, low-urgency routes to lower-cost carriers.

**Page 5 - Product Type Strategy**

**Key finding:** Clear segmentation exists between volume-driven and margin-driven categories. Skincare generates the majority of total profit through high volume and low unit cost. Cosmetics deliver the highest profit per unit and the lowest defect rates - the strongest margin efficiency in the portfolio. Haircare underperforms on both margin and quality. The optimal strategy is to maintain skincare as the volume engine, scale cosmetics to capture higher unit margins, and reduce reliance on haircare to improve overall portfolio profitability.

**Strategic Recommendations**
Based on the full analysis, five priorities emerge:

**Concentrate SKU investment on high-margin haircare SKUs** (SKU2, SKU51, SKU24, SKU79) - these have proven unit economics and room to scale

**Rationalize underperforming SKUs with moderate-to-high volume but weak margins** - they dilute overall profitability without proportional revenue contribution

**Shift supplier concentration toward Supplier 1 and Supplier 2** - reduce or eliminate exposure to Suppliers 3 and 5, which combine high defect rates with low profit contribution

**Rebalance logistics carrier usage** - move appropriate routes from Carrier B to Carrier A where delivery speed is not a constraint, reducing logistics burden on high-cost routes

**Scale cosmetics as a strategic growth category** - superior unit economics and defect rates make it the highest-quality, highest-margin segment in the portfolio

