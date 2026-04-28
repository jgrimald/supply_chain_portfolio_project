
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

logistics_aggregation AS (
	SELECT
		shipping_carriers,
		transportation_modes,
		routes,

		/* cost efficiency */
		SUM(shipping_costs * order_quantities) / NULLIF(SUM(order_quantities), 0) AS weighted_shipping_cost,

		/* time efficiency */
		SUM(shipping_times * order_quantities) / NULLIF(SUM(order_quantities), 0) AS weighted_shipping_time,

		/* shipment volume */
		SUM(order_quantities) AS shipment_count,

		/* optimization metric */
		(SUM(shipping_costs) + SUM(shipping_times)) / NULLIF(SUM(order_quantities), 0) AS logistics_burden

	FROM cleaned_supply
	GROUP BY
		shipping_carriers,
		transportation_modes,
		routes
)

SELECT * 
FROM logistics_aggregation
