from app.models import TelemetryReading
from app.rules import evaluate


def test_no_alerts_for_normal_reading():
    reading = TelemetryReading(
        vehicle_id="VIN1",
        speed_kmph=80,
        engine_rpm=2500,
        coolant_temp_c=90,
    )
    assert evaluate(reading) == []


def test_overspeed_alert():
    reading = TelemetryReading(
        vehicle_id="VIN1",
        speed_kmph=150,
        engine_rpm=2500,
        coolant_temp_c=90,
    )
    codes = [a.code for a in evaluate(reading)]
    assert "OVERSPEED" in codes


def test_multiple_alerts_including_dtc():
    reading = TelemetryReading(
        vehicle_id="VIN1",
        speed_kmph=150,
        engine_rpm=7000,
        coolant_temp_c=120,
        dtc_codes=["P0128", "P0300"],
    )
    codes = [a.code for a in evaluate(reading)]
    assert "OVERSPEED" in codes
    assert "ENGINE_REDLINE" in codes
    assert "OVERHEAT" in codes
    assert codes.count("DTC_PRESENT") == 2


def test_critical_severity_present_on_overheat():
    reading = TelemetryReading(
        vehicle_id="VIN1",
        speed_kmph=80,
        engine_rpm=2500,
        coolant_temp_c=130,
    )
    severities = {a.severity for a in evaluate(reading)}
    assert "critical" in severities
