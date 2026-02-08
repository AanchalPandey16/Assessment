-- ads daily data
create table ads_daily (
    date date,
    platform_id text,
    brand_id text,
    product_id text,
    ad_spend numeric(10,2),
    clicks int,
    impressions int
);

set datestyle = 'MDY';

\copy ads_daily
from 'C:/Users/AANCHAL/Pictures/Infytrix/Data/ads_daily.csv'
delimiter ','
csv header;

select count(*) from ads_daily;

-- product master data
create table product_master (
    product_id text,
    category text,
    price_band text
);


\copy product_master 
from 'C:/Users/AANCHAL/Pictures/Infytrix/Data/product_master.csv' 
delimiter ',' 
csv header;

select count(*) from product_master;

-- Sales data
create table sales_daily (
    date date,
    platform_id text,
    brand_id text,
    product_id text,
    units_sold int,
    revenue numeric(12,2)
);

set datestyle = 'MDY';

\copy sales_daily 
from 'C:/Users/AANCHAL/Pictures/Infytrix/Data/sales_daily.csv' 
delimiter ',' 
csv header;

select count(*) from sales_daily;