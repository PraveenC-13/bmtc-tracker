CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE route (
    route_id        SERIAL PRIMARY KEY,
    route_number    TEXT NOT NULL UNIQUE,
    source          TEXT,
    destination     TEXT,
    path            GEOGRAPHY(LINESTRING)
);

CREATE TABLE stops (
    stop_id         SERIAL PRIMARY KEY.
    route_id        INT NOT NULL REFERENCES routes(routes_id) ON DELETE CASCADE,
    stop_name       TEXT NOT NULL,
    stop_order      INT NOT NULL,
    location        GEOGRAPHY(POINT) NOT NULL,
    UNIQUE (route_id, stop_order),
);

CREATE INDEX idx_stops_route_order ON stops(route_id, stop_order);

CREATE TABLE devices (
    device_id       UUID PRIMARY KEY,
    created_at      TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE location_pings (
    id              BIGSERIAL PRIMARY KEY,
    device_id       UUID NOT NULL REFERENCES(device_id),
    route_id        INT NOT NULL REFERENCES(route_id),
    latitude        DOUBLE PRECISION NOT NULL,
    longitude       DOUBLE PRECISION NOT NULL,
    speed_mps       REAL,
    heading         REAL,
    recorded_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_pings_route_times on location_pings(route_id, recorded_at)
