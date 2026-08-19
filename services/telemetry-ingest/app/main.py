from datetime import UTC, datetime

from fastapi import FastAPI, Response, status
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest

from .models import TelemetryAck, TelemetryReading

app = FastAPI(title="Telemetry Ingest", version="0.1.0")

_latest_readings: dict[str, TelemetryReading] = {}

TELEMETRY_RECEIVED = Counter(
    "telemetry_received_total",
    "Total telemetry readings received",
    ["vehicle_id"],
)
LAST_SPEED = Gauge(
    "telemetry_last_speed_kmph",
    "Most recent recorded speed per vehicle",
    ["vehicle_id"],
)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post(
    "/telemetry",
    response_model=TelemetryAck,
    status_code=status.HTTP_201_CREATED,
)
def ingest(reading: TelemetryReading) -> TelemetryAck:
    received_at = datetime.now(UTC)
    if reading.recorded_at is None:
        reading.recorded_at = received_at
    _latest_readings[reading.vehicle_id] = reading
    TELEMETRY_RECEIVED.labels(vehicle_id=reading.vehicle_id).inc()
    LAST_SPEED.labels(vehicle_id=reading.vehicle_id).set(reading.speed_kmph)
    return TelemetryAck(
        status="accepted",
        vehicle_id=reading.vehicle_id,
        received_at=received_at,
    )


@app.get("/telemetry/{vehicle_id}/latest", response_model=TelemetryReading)
def latest(vehicle_id: str) -> TelemetryReading | Response:
    reading = _latest_readings.get(vehicle_id)
    if reading is None:
        return Response(status_code=status.HTTP_404_NOT_FOUND)
    return reading


@app.get("/metrics")
def metrics() -> Response:
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
