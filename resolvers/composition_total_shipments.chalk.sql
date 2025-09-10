-- resolves: RouteFeatures.composition_total_shipments
-- source: postgres
-- count: 1
-- description: Total number of shipments assigned to route for collection organization and loading efficiency analysis

SELECT
    r.uid as route_uid,
    r.total_shipments as composition_total_shipments
FROM public.routes r
WHERE r.uid = ${route.route_uid}
    AND r.livemode IS NULL OR r.livemode = 'live'  -- exclude test routes
