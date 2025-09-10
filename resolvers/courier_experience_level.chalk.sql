-- resolves: CourierExperienceLevel
-- source: postgres
-- count: 1

SELECT
  courier_uid,
  COUNT(*) as total_routes,
  -- Calculate experience band based on route count
  CASE
    WHEN COUNT(*) BETWEEN 1 AND 5 THEN 'novice'       -- Routes 1-5: New couriers
    WHEN COUNT(*) BETWEEN 6 AND 20 THEN 'intermediate' -- Routes 6-20: Growing experience
    WHEN COUNT(*) >= 21 THEN 'experienced'            -- Routes 21+: Experienced couriers
    ELSE 'unknown'                                     -- Edge case handling
  END as experience_level
FROM public.routes
WHERE
  (livemode IS NULL OR livemode = 'live')
  AND state IN ('ended')  -- Only completed routes count toward experience
GROUP BY courier_uid
