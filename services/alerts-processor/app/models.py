from pydantic import BaseModel, Field


class TelemetryReading(BaseModel):
    vehicle_id: str = Field(..., min_length=1, max_length=64)
    speed_kmph: float = Field(..., ge=0, le=400)
    engine_rpm: int = Field(..., ge=0, le=12000)
    coolant_temp_c: float = Field(..., ge=-40, le=200)
    dtc_codes: list[str] = Field(default_factory=list)


class Alert(BaseModel):
    code: str
    severity: str
    message: str


class AlertReport(BaseModel):
    vehicle_id: str
    alert_count: int
    alerts: list[Alert]
