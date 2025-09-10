-- Chalk SQL Resolver: Courier Transport Vehicle Type
-- Resolves vehicle type for couriers affecting all route components
-- Source: Direct postgres query to public.couriers table
--
-- resolves: Courier
-- source: postgres
-- count: 1

select
    uid as courier_uid,
    vehicle_type as courier_transport_vehicle_type
from public.couriers
where uid = ${courier.courier_uid}