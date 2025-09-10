"""
Delivery Feature Class Definition for Chalk Feature Store
Defines delivery/attempt-level features for the Last Mile Durations ML model
"""

from chalk.features import features
from datetime import datetime


@features
class Delivery:
    """
    Delivery feature class for Last Mile Durations ML model

    Represents parcel/attempt-level features that affect handover and travel performance:
    - Handover: Building access, customer interaction, parcel characteristics
    - Travel: Time-of-day traffic patterns, remaining parcel burden
    - Context: Sequence position, route progression, delivery attempt timing (includes failures)
    """

    # Primary identifiers
    shipment_uid: str  # Individual parcel identifier
    route_uid: str  # Links to Route feature class
    attempt_uid: str  # Individual delivery attempt identifier

    # Parcel characteristics affecting handover
    parcel_weight_grams: float  # Parcel weight impacting carrying and handling
    parcel_dimensions_cm: str  # Parcel dimensions (if available)

    # Address and building features affecting handover
    destination_address_contains_flat: bool  # Building type classification
    building_type_handover_complexity: str  # Derived building complexity
    estimated_floor_number: int  # Floor level affecting climb time
    delivery_note_safe_place_available: bool  # Safe place delivery option

    # Temporal context affecting customer availability and traffic patterns
    time_of_day: int  # Hour (0-23) from delivery attempt timing (includes failed attempts)
    lm_delivery_outcome_at_local: datetime  # Actual delivery outcome time (successful or failed)

    # Route context affecting handover efficiency
    sequence_number: int  # Position in delivery sequence
    remaining_parcels_burden: int  # Parcels remaining in route

    # Spatial context
    destination_postcode: str  # For spatial feature lookups
    destination_outcode: str  # Outcode for area-level features

    # Spatial context (linked from Route features)
    avg_population_density: float  # Population density affecting building access

    # To be added in future implementations:
    # customer_availability_probability: float # Time-based availability patterns
