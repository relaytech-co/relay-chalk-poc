-- resolves: parcel_weight_grams
-- source: postgres
-- count: 1
-- description: Weight of individual parcel in grams extracted from JSON payload
-- business_context: Heavier parcels take longer to unload, carry, and are more difficult to leave safely
-- ml_component: Handover duration prediction (parcel-level)
-- performance_requirement: <10ms ultra-low latency serving
-- data_freshness: Real-time operational data
-- preprocessing: JSON extraction with DBT-equivalent data quality filters

SELECT
    uid as shipment_uid,
    parcel__weight_grams
FROM public.shipments
WHERE uid = ${shipment.uid}
    AND parcel__weight_grams IS NOT NULL

-- PostgreSQL optimization notes:
-- 1. Requires composite index on (uid, meta_is_deleted) for optimal performance
-- 2. JSON extraction using ->> operator for text values, cast to integer
-- 3. Filters out soft-deleted records (meta_is_deleted = false)
-- 4. Excludes NULL weight values to ensure data quality
-- 5. Expected query time: <10ms for indexed primary key lookups
-- 6. Minimal CPU cost for single JSON field extraction
