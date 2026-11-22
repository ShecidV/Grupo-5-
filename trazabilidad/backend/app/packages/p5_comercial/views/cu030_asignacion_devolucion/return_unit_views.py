from typing import List

from pydantic import BaseModel, Field


class AssignReturnUnitsRequest(BaseModel):
    idunidades: List[int] = Field(..., min_length=1)
