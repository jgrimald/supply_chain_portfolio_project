
WITH cleaned_supply AS(
	SELECT "Product type" AS product_type,
	"SKU" AS sku,
	"Price" AS price,
	"Availability" AS availability,
	"Number of products sold" AS number_of_products_sold,
	"Revenue generated" AS revenue_generated,
	"Customer demographics" AS customer_demographics,
	"Stock levels" AS stock_levels,
	"Lead times" AS lead_times,
	"Order quantities" AS order_quantities,
	"Shipping times" AS shipping_times,
	"Shipping carriers" AS shipping_carriers,
	"Shipping costs" AS shipping_costs,
	"Supplier name" AS supplier_name,
	"Lead time" AS lead_time,
	"Production volumes" AS production_volumes,
	"Manufacturing lead time" AS manufacturing_lead_time,
	"Manufacturing costs" AS manufacturing_costs,
	"Inspection results" AS inspection_results,
	"Defect rates" AS defect_rates,
	"Transportation modes" AS transportation_modes,
	"Routes" AS routes,
	"Costs" AS costs
	
	FROM supply_chain_analysis
	),

standardized_pricing AS(
	SELECT 
	sku,
	(revenue_generated/NULLIF(number_of_products_sold, 0)) AS revenue_per_unit,
	(lead_times/NULLIF(number_of_products_sold, 0)) AS lead_per_unit,
	(shipping_times/NULLIF(number_of_products_sold, 0)) AS ship_time_per_unit,
	(shipping_costs/NULLIF(number_of_products_sold, 0)) AS ship_cost_per_unit,
	(manufacturing_lead_time/NULLIF(number_of_products_sold, 0)) AS man_lead_per_unit,
	(manufacturing_costs/NULLIF(number_of_products_sold, 0)) AS man_cost_per_unit,
	(costs/NULLIF(number_of_products_sold, 0)) AS total_cost_per_unit,
	((revenue_generated/NULLIF(number_of_products_sold, 0)) - (costs/NULLIF(number_of_products_sold, 0))) AS total_net_per_unit
	FROM cleaned_supply
),

sku_aggregation AS(
	    SELECT
        sku,

        SUM(number_of_products_sold) AS total_units_sold,
        SUM(revenue_generated) AS total_revenue,
        SUM(costs) AS total_cost,

        SUM(revenue_generated - costs) AS total_profit,

        AVG(revenue_generated::float / NULLIF(number_of_products_sold, 0)) AS avg_revenue_per_unit,

        AVG(
            (revenue_generated - costs)::float / NULLIF(number_of_products_sold, 0)
        ) AS avg_net_per_unit

    FROM cleaned_supply
    GROUP BY sku
	)

/*SELECT 
	sku,
	total_profit,
	total_revenue,

	RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM sku_aggregation;*/

/*SELECT
	sku,
	total_profit,
	total_units_sold,

	(total_profit * 0.6 + total_units_sold * 0.4) AS sku_score
FROM sku_aggregation;*/

/*SELECT
	sku,
	total_profit,

	CASE
		WHEN total_profit <0 THEN 'LOSS'
		WHEN total_profit < 1000 THEN 'LOW PROFIT'
		WHEN total_profit <5000 THEN 'MEDIUM PROFIT'
		ELSE 'HIGH PROFIT'
	END AS profit_segment
from sku_aggregation;*/

SELECT
	sa.*,
	cs.product_type,
	cs.supplier_name,

	
	RANK() OVER (ORDER BY total_profit DESC) AS profit_rank,

	CASE
		WHEN total_profit <0 THEN 'LOSS'
		WHEN total_profit < 5000 THEN 'LOW'
		ELSE 'HIGH'
	END AS profit_segment,

	SUM(sa.total_profit) OVER () AS total_profit_all,

	(sa.total_profit::float / NULLIF(SUM(sa.total_profit) OVER (), 0))AS profit_contribution,
	
	SUM(sa.total_profit) OVER (ORDER BY sa.total_profit DESC) / NULLIF(SUM(sa.total_profit) OVER (), 0) AS cumulative_profit_pct


	
FROM sku_aggregation sa
JOIN cleaned_supply cs USING (sku)