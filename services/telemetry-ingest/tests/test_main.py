from app.main import app
from fastapi.testclient import TestClient

client = TestClient(app)


def test_health():
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok"}


def test_ingest_and_fetch_latest():
    payload = {
        "vehicle_id": "VIN123",
        "speed_kmph": 88.5,
        "engine_rpm": 2200,
        "coolant_temp_c": 90.0,
        "dtc_codes": ["P0128"],
    }
    resp = client.post("/telemetry", json=payload)
    assert resp.status_code == 201
    assert resp.json()["status"] == "accepted"

    latest = client.get("/telemetry/VIN123/latest")
    assert latest.status_code == 200
    assert latest.json()["speed_kmph"] == 88.5


def test_ingest_rejects_invalid_speed():
    payload = {
        "vehicle_id": "VIN123",
        "speed_kmph": -5,
        "engine_rpm": 2200,
        "coolant_temp_c": 90.0,
    }
    resp = client.post("/telemetry", json=payload)
    assert resp.status_code == 422


def test_latest_unknown_vehicle_returns_404():
    resp = client.get("/telemetry/UNKNOWN/latest")
    assert resp.status_code == 404


def test_metrics_exposed():
    resp = client.get("/metrics")
    assert resp.status_code == 200
    assert "telemetry_received_total" in resp.text
