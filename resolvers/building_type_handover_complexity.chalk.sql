-- Building Type Handover Complexity Resolver (PostgreSQL Optimized)
-- Direct PostgreSQL access for <10ms serving performance
-- Enhanced regex patterns for improved accuracy over simple DBT macro

-- resolves: HandoverFeatures.building_type_handover_complexity
-- source: postgres
-- count: 1
-- timeout: 50ms
-- cache_duration: 168h  -- 7 days (building type is stable)

SELECT
    uid as address_uid,

    -- Enhanced building type classification with improved regex patterns
    CASE
        -- Explicit flat/apartment indicators
        WHEN LOWER(CONCAT(COALESCE(property, ''), ' ', COALESCE(street, ''))) ~ '\y(flat|apartment|maisonette|studio|penthouse|unit [0-9]+|apt [0-9]+|floor [0-9]+)\y' THEN 1

        -- Explicit house indicators
        WHEN LOWER(CONCAT(COALESCE(property, ''), ' ', COALESCE(street, ''))) ~ '\y(house|bungalow|cottage|villa|detached|semi-detached|terraced)\y' THEN 0

        -- Property number patterns: simple numbers = house (e.g., "123", "45A")
        WHEN property ~ '^[0-9]+[A-Za-z]?$' THEN 0

        -- Sub-divided property patterns: likely flats (e.g., "12/3", "45B", "Unit 6")
        WHEN property ~ '[0-9]+/[0-9]+|[0-9]+[A-Za-z]$|^[A-Za-z]+ [0-9]+$' THEN 1

        -- Complex property descriptions suggesting multi-unit (e.g., "The Mansions", "Court")
        WHEN LOWER(COALESCE(property, '')) ~ '\y(court|mansions|towers|heights|gardens apartment|lodge apartment)\y' THEN 1

        -- Street name indicators for flat-heavy areas
        WHEN LOWER(COALESCE(street, '')) ~ '\y(court|mews|close|square|gardens)\y' AND property ~ '[0-9]+[A-Za-z]' THEN 1

        -- Default assumption: standalone properties are houses
        ELSE 0
    END as building_type_handover_complexity,

    -- Metadata for tracking and model enhancement
    JSON_BUILD_OBJECT(
        'classification_method', 'enhanced_postgresql_regex',
        'address_text', CONCAT(COALESCE(property, ''), ' ', COALESCE(street, '')),
        'property_pattern', property,
        'data_source', 'postgres_addresses',

        -- Complexity scoring for handover duration prediction
        'handover_complexity_score', CASE
            WHEN LOWER(CONCAT(COALESCE(property, ''), ' ', COALESCE(street, ''))) ~ '\y(tower|high rise|block)\y' THEN 4  -- High-rise complex
            WHEN LOWER(CONCAT(COALESCE(property, ''), ' ', COALESCE(street, ''))) ~ '\y(flat|apartment|maisonette)\y' THEN 2  -- Standard flat
            WHEN property ~ '[0-9]+[A-Za-z]$' THEN 1  -- Converted property
            ELSE 0  -- Standard house
        END,

        -- Address quality indicators
        'address_quality', JSON_BUILD_OBJECT(
            'property_present', property IS NOT NULL AND property != '',
            'street_present', street IS NOT NULL AND street != '',
            'complete_address', property IS NOT NULL AND street IS NOT NULL
        ),

        'last_updated', CURRENT_TIMESTAMP
    ) as building_metadata

FROM public.addresses
WHERE address_uid = ${handover.address_uid}
    AND property IS NOT NULL
    AND street IS NOT NULL