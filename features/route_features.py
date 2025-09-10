"""
Route Feature Class Definition for Chalk Feature Store
Defines route-level features for the Last Mile Durations ML model
"""

from chalk.features import features
from datetime import datetime


@features
class Route:
    """
    Route feature class for Last Mile Durations ML model
    
    Represents route-level features that affect collection and overall route performance:
    - Collection: Total shipments affecting loading complexity
    - Travel: Route composition affecting travel patterns  
    - Overall: Route characteristics affecting entire duration
    """
    
    # Primary identifier
    route_uid: str
    
    # Route composition features affecting collection and overall performance
    composition_total_shipments: int         # Total parcels in route
    composition_count_containers: int        # Total bags/containers  
    composition_count_loose_shipments: int   # Loose parcels requiring individual handling
    
    # Route timing context
    target_start_at_local: datetime          # Planned route start time
    route_date: str                          # Route date for temporal features
    
    # Geographic context
    collection_pitstop_uid: str              # Collection pitstop identifier
    collection_pitstop_postcode: str         # Pitstop postcode for spatial features
    
    # Route metadata
    courier_uid: str                         # Links to Courier feature class
    transport_type: str                      # Route-level transport type
    
    # Spatial features affecting collection and handover
    avg_population_density: float            # Population density per square km
    density_tier: str                        # Categorical: "low", "medium", "high"
    
    # Time-based features
    time_of_day: int                         # Hour of day (0-23) from route target_start_at_local (overall component)