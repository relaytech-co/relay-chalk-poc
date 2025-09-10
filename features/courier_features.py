"""
Courier Feature Class Definition for Chalk Feature Store
Defines courier-level features for the Last Mile Durations ML model
"""

from chalk.features import features
from enum import Enum


class VehicleType(Enum):
    """Enum for courier vehicle types"""

    CAR = "car"
    MOPED = "moped"
    E_BIKE = "ebike"
    VAN = "van"


@features
class Courier:
    """
    Courier feature class for Last Mile Durations ML model

    Represents courier-level features that affect all route components:
    - Collection: Bag capacity and loading efficiency
    - Travel: Speed profiles and routing capabilities
    - Handover: Parking proximity and delivery approach
    - Overall: Route characteristics and performance patterns
    """

    # Primary identifier
    courier_uid: str

    # Vehicle characteristics affecting all components
    courier_transport_vehicle_type: VehicleType  # Values: "car", "moped"

    # Experience metrics affecting all route components
    courier_experience_level: str  # Values: "novice", "intermediate", "experienced"
    courier_route_index: int  # Route count (capped at 100 for ML features)

    # Performance patterns (to be added in future resolvers)
    # courier_pitstop_familiarity_score: float
    # courier_outcode_experience: int
