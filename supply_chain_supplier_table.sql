
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

supplier_aggregation AS (
	SELECT
	supplier_name,

	SUM(number_of_products_sold) AS total_units_sold,
	SUM(revenue_generated - costs) AS total_profit,

	/* weighted defect rate */
	SUM(defect_rates::float * production_volumes) / NULLIF(SUM(production_volumes), 0) AS avg_defect_rate,

	/* weighted lead time */
	sum(lead_time * order_quantities) / NULLIF(SUM(order_quantities), 0) AS avg_lead_time,

	/* unit manufacturing cost */
	SUM(manufacturing_costs) / NULLIF(SUM(number_of_products_sold),0) AS avg_manufacturing_cost_per_unit

	FROM cleaned_supply
	GROUP BY supplier_name
)

SELECT
	supplier_name,
	total_units_sold,
	total_profit,
	avg_defect_rate,
	avg_lead_time,
	avg_manufacturing_cost_per_unit

FROM supplier_aggregation