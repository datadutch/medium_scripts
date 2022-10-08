use role securityadmin; 
create user johndoe password = 'johndoe';
create user janedoe password = 'janedoe';
use role sysadmin;
create warehouse if not exists public;
alter warehouse public suspend;
grant usage on warehouse public to role public;

use warehouse public;
select count(*) from "SNOWFLAKE_SAMPLE_DATA"."TPCDS_SF100TCL"."CATALOG_RETURNS";

show warehouses;

select CR_ORDER_NUMBER, CR_RETURN_QUANTITY from "SNOWFLAKE_SAMPLE_DATA"."TPCDS_SF100TCL"."CATALOG_RETURNS" limit 1000;

-- query history
use role accountadmin;
select 
  query_id
, warehouse_name
, warehouse_size
, total_elapsed_time
, bytes_scanned
, rows_produced
, partitions_scanned
, partitions_total
, compilation_time
, execution_time
, start_time
, queued_provisioning_time
, credits_used_cloud_services
, query_load_percent
from snowflake. account_usage.query_history 
where query_id in 
(
'01a75140-0201-73cd-0000-000156d220fd'
    , '01a75141-0201-73cd-0000-000156d22125'
)
order by start_time;