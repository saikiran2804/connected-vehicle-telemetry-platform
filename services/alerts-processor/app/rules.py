from .models import Alert, TelemetryReading

OVERSPEED_LIMIT_KMPH = 120.0
REDLINE_RPM = 6500
COOLANT_WARN_C = 110.0


def evaluate(reading: TelemetryReading) -> list[Alert]:
    alerts: list[Alert] = []

    if reading.speed_kmph > OVERSPEED_LIMIT_KMPH:
        alerts.append(
            Alert(
                code="OVERSPEED",
                severity="warning",
                message=f"Speed {reading.speed_kmph} km/h exceeds limit {OVERSPEED_LIMIT_KMPH}",
            )
        )

    if reading.engine_rpm > REDLINE_RPM:
        alerts.append(
            Alert(
                code="ENGINE_REDLINE",
                severity="critical",
                message=f"RPM {reading.engine_rpm} above redline {REDLINE_RPM}",
            )
        )

    if reading.coolant_temp_c > COOLANT_WARN_C:
        alerts.append(
            Alert(
                code="OVERHEAT",
                severity="critical",
                message=f"Coolant temp {reading.coolant_temp_c}C above {COOLANT_WARN_C}C",
            )
        )

    for dtc in reading.dtc_codes:
        alerts.append(
            Alert(
                code="DTC_PRESENT",
                severity="info",
                message=f"Diagnostic trouble code reported: {dtc}",
            )
        )

    return alerts
