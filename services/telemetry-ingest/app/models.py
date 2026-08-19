from datetime import datetime

from pydantic import BaseModel, Field


class TelemetryReading(BaseModel):
    vehicle_id: str = Field(..., min_length=1, max_length=64)
    speed_kmph: float = Field(..., ge=0, le=400)
    engine_rpm: int = Field(..., ge=0, le=12000)
    coolant_temp_c: float = Field(..., ge=-40, le=200)
    dtc_codes: list[str] = Field(default_factory=list)
    recorded_at: datetime | None = None


class TelemetryAck(BaseModel):
    status: str
    vehicle_id: str
    received_at: datetime
