-- to see row count
select count(*) from ads_daily;
select count(*) from product_master;
select count(*) from sales_daily;

-- date ranges 
select min(date), max(date) from ads_daily;
select min(date), max(date) from sales_daily;
-- one month of data ( Jan )


-- aggregating ads_daily dataset 
-- total ads performance for one product on one platform in one day
create table ads_daily_agg as
select 
	date,
	product_id,
	platform_id,
	sum(ad_spend) as ad_spend,
	sum(clicks) as clicks,
	sum(impressions) as impressions
from ads_daily
group by date, platform_id, product_id;

select count(*) from ads_daily_agg;


-- make final table
create table final_data as
select
	s.date,
	s.platform_id,
	s.brand_id,
	s.product_id,
	s.units_sold,
	s.revenue,
	p.category,
	p.price_band,
	coalesce(a.ad_spend, 0) as ad_spend,
	coalesce(a.clicks, 0) as clicks,
	coalesce(a.impressions, 0) as impressions
from sales_daily as s
left join ads_daily_agg as a
	on s.date = a.date
	and s.platform_id = a.platform_id
	and s.product_id = a.product_id
left join product_master as p
	on s.product_id = p.product_id;

select count(*) from final_data;

-- derived metrics
create table category_metrics as 
select 
	category,
	round(sum(revenue) / nullif(sum(ad_spend), 0), 2) as roas,
	round(sum(clicks)::numeric / nullif(sum(impressions), 0), 2) as ctr,
	round(sum(revenue) / nullif(sum(units_sold), 0),2) as avg_sp
from final_data
where category in (
	'Nutrition',
    'Fragrance',
    'PersonalCare',
    'BabyCare',
    'Skincare',
    'Haircare'
)
group by category
order by category;

-- plsql cmd to save files 
\copy final_data to 'C:/Users/AANCHAL/Pictures/Infytrix/Data/final_data.csv' delimiter ',' csv header;
\copy category_metrics to 'C:/Users/AANCHAL/Pictures/Infytrix/Data/category_metrics.csv' delimiter ',' csv header;

-- row level missing category analysis
select
    count(*) as total_rows,
    count(*) filter (where category is null) as missing_rows,
    round(
        count(*) filter (where category is null)::numeric
        / count(*) * 100,
        2
    ) as missing_percentage
from final_data;
-- 35.68% of data is missing 


-- revenue impact on unmapped products
select
    round(
        sum(revenue) filter (where category is null)
        / sum(revenue) * 100,
        2
    ) as revenue_pct_unmapped
from final_data;
-- 32.64% of revenue is from unmapped products

	