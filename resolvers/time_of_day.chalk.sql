-- resolves: route_start_hour_of_day (Overall component) - RECOMMENDED PRIMARY
-- source: postgres
-- count: 1
-- table: public.routes
-- performance_target: <10ms
-- caching: 10s staleness acceptable

SELECT
    uid as route_uid,
    EXTRACT(HOUR FROM target_start_at AT TIME ZONE 'Europe/London') as route_start_hour_of_day
FROM public.routes
WHERE uid = ${route.route_uid}
    AND target_start_at IS NOT NULL

---

-- resolves: delivery_outcome_hour_of_day (Travel/Handover components) - CORRECTED WITH ALL ATTEMPT EVENTS
-- source: postgres
-- count: 1
-- table: public.shipment_workflow_events + public.route_shipments
-- performance_target: <10ms
-- caching: 10s staleness acceptable
-- NOTE: Includes ALL delivery attempts (successful AND failed) matching DBT lm_attempt_events logic

SELECT
    swe.shipment_uid,
    rs.route_uid,
    EXTRACT(HOUR FROM swe.occurred_at AT TIME ZONE 'Europe/London') as delivery_outcome_hour_of_day
FROM public.shipment_workflow_events swe
JOIN public.route_shipments rs ON swe.shipment_uid = rs.shipment_uid
WHERE swe.shipment_uid = ${shipment.shipment_uid}
    AND swe.event_name IN (
        'eartmgtsltm', 'delivery_delivery', 'delivery_complete', 'delivery_delivered',
        'delivery_failed', 'delivery_deliveryfailed', 'lm_delivery_failed',
        'handed_to_customer', 'left_in_safe_place', 'handed_to_neighbour'
    )
    AND swe.occurred_at IS NOT NULL
ORDER BY swe.occurred_at DESC
LIMIT 1


-- BigQuery fallback (if PostgreSQL experiences issues)
-- resolves: route_start_hour_of_day
-- source: bigquery
-- count: 1
-- performance_target: 50-75ms
-- NOTE: Use only if PostgreSQL direct access has operational issues

-- SELECT
--     route_uid,
--     EXTRACT(HOUR FROM target_start_at_local) as route_start_hour_of_day
-- FROM `relaytech-production.reports.routes_performance`
-- WHERE route_uid = ${route_uid}
--     AND target_start_at_local IS NOT NULL

---

-- BigQuery fallback for delivery outcomes
-- resolves: delivery_outcome_hour_of_day
-- source: bigquery
-- count: 1
-- performance_target: 50-75ms

-- SELECT
--     shipment_uid,
--     route_uid,
--     EXTRACT(HOUR FROM lm_delivery_outcome_at_local) as delivery_outcome_hour_of_day
-- FROM `relaytech-production.reports.attempts_performance`
-- WHERE shipment_uid = ${shipment_uid}
--     AND route_uid = ${route_uid}
--     AND lm_delivery_outcome_at_local IS NOT NULL