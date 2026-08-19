from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

from .models import AlertReport, TelemetryReading
from .rules import evaluate

app = FastAPI(title="Alerts Processor", version="0.1.0")

ALERTS_RAISED = Counter(
    "alerts_raised_total",
    "Total alerts raised by severity",
    ["severity"],
)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/evaluate", response_model=AlertReport)
def evaluate_reading(reading: TelemetryReading) -> AlertReport:
    alerts = evaluate(reading)
    for alert in alerts:
        ALERTS_RAISED.labels(severity=alert.severity).inc()
    return AlertReport(
        vehicle_id=reading.vehicle_id,
        alert_count=len(alerts),
        alerts=alerts,
    )


@app.get("/metrics")
def metrics() -> Response:
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
