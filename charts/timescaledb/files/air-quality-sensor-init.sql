-- Table: public.air_quality_data

-- DROP TABLE IF EXISTS public.air_quality_data;

CREATE TABLE IF NOT EXISTS public.air_quality_data
(
    "time" timestamp without time zone NOT NULL,
    tag_id bigint,
    telemetry_pm25_unit text,
    telemetry_pm25_value double precision,
    telemetry_tvoc_unit text,
    telemetry_tvoc_value double precision,
    uuid text
);

-- Create TimescaleDB hypertable for time series data
SELECT create_hypertable('air_quality_data', 'time', chunk_time_interval => INTERVAL '7d', if_not_exists => TRUE);

-- Create time index for time-based queries
CREATE INDEX IF NOT EXISTS air_quality_data_time_idx
    ON public.air_quality_data USING btree
    ("time" DESC NULLS FIRST);

-- Table: public.air_quality_data_tag

-- DROP TABLE IF EXISTS public.air_quality_data_tag;

CREATE TABLE IF NOT EXISTS public.air_quality_data_tag
(
    tag_id bigint NOT NULL,
    host text,
    CONSTRAINT air_quality_data_tag_pkey PRIMARY KEY (tag_id)
);

COMMENT ON COLUMN public.air_quality_data_tag.host
    IS 'tag';

-- Table: public.air_quality_metadata

-- DROP TABLE IF EXISTS public.air_quality_metadata;

CREATE TABLE IF NOT EXISTS public.air_quality_metadata
(
    "time" timestamp without time zone NOT NULL,
    tag_id bigint,
    description text,
    name text,
    type text,
    uuid text,
    -- Add PostGIS geospatial column for location
    location geography(Point, 4326)
);

-- Create TimescaleDB hypertable for metadata
SELECT create_hypertable('air_quality_metadata', 'time', chunk_time_interval => INTERVAL '7d', if_not_exists => TRUE);

-- Create time index for time-based queries
CREATE INDEX IF NOT EXISTS air_quality_metadata_time_idx
    ON public.air_quality_metadata USING btree
    ("time" DESC NULLS FIRST);

-- Create spatial index for location-based queries
CREATE INDEX IF NOT EXISTS air_quality_metadata_location_idx
    ON public.air_quality_metadata USING GIST (location);

-- Table: public.air_quality_metadata_tag

CREATE TABLE IF NOT EXISTS public.air_quality_metadata_tag
(
    tag_id bigint NOT NULL,
    host text,
    CONSTRAINT air_quality_metadata_tag_pkey PRIMARY KEY (tag_id)
);

COMMENT ON COLUMN public.air_quality_metadata_tag.host
    IS 'tag';

-- Helper function to add or update a sensor with geospatial data
CREATE OR REPLACE FUNCTION add_or_update_air_quality_sensor(
    p_uuid TEXT,
    p_name TEXT,
    p_description TEXT,
    p_type TEXT, 
    p_latitude DOUBLE PRECISION,
    p_longitude DOUBLE PRECISION
) RETURNS VOID AS $$
BEGIN
    INSERT INTO public.air_quality_metadata 
        ("time", uuid, name, description, type, location)
    VALUES 
        (NOW(), p_uuid, p_name, p_description, p_type, 
         ST_SetSRID(ST_MakePoint(p_longitude, p_latitude), 4326)::geography)
    ON CONFLICT (uuid) 
    DO UPDATE SET
        name = p_name,
        description = p_description,
        type = p_type,
        location = ST_SetSRID(ST_MakePoint(p_longitude, p_latitude), 4326)::geography;
END;
$$ LANGUAGE plpgsql;

-- Sample queries for reference:

-- Find all sensors within 1km of a point
-- SELECT uuid, name, ST_AsText(location) FROM air_quality_metadata
-- WHERE ST_DWithin(
--   location,
--   ST_SetSRID(ST_MakePoint(-73.982, 40.719), 4326)::geography,
--   1000
-- );

-- Create a geofence and find sensors inside it
-- SELECT uuid, name, ST_AsText(location) FROM air_quality_metadata
-- WHERE ST_Contains(
--   ST_GeomFromText('POLYGON((-74.0 40.7, -73.9 40.7, -73.9 40.8, -74.0 40.8, -74.0 40.7))', 4326),
--   ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
-- );