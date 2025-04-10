# ChirpStack IoT Helm Chart

This Helm chart deploys the complete ChirpStack IoT stack with EMQX/Kafka as message brokers and TimescaleDB for time series analytics on Kubernetes.

## Recent Updates

- **2025-04-10**: Fixed Kafka KRaft mode configuration with proper NODE_ID setup and advertised listeners
- **2025-04-10**: Fixed Telegraf configuration by replacing tag processor with global_tags
- **2025-04-10**: Updated all storage classes to use "local-path" for improved compatibility across Kubernetes environments
- **2025-04-10**: Fixed YAML parsing issues in Telegraf ConfigMap by simplifying the configuration structure
- **2025-04-09**: Enhanced TimescaleDB schema with Amazon-specific fields
- **2025-04-08**: Added Amazon Rainforest Environmental Simulator for generating realistic environmental data

## Deployment Readiness Status

| Component | Status | Notes |
|-----------|--------|-------|
| ChirpStack Gateway Bridge | ✅ Ready | Configured for LoRa packet-forwarder protocols |
| ChirpStack Network Server | ✅ Ready | PostgreSQL and Redis dependencies configured |
| ChirpStack Application Server | ✅ Ready | Web interface and API available via NodePort 30080 |
| EMQX MQTT Broker | ✅ Ready | Configured for topic structure and persistence |
| Kafka | ✅ Ready | Configured with KRaft mode and predefined topics |
| PostgreSQL | ✅ Ready | Initialized with required databases |
| Redis | ✅ Ready | Configured for caching and queue management |
| Telegraf | ✅ Ready | Data collection from MQTT and Kafka sources |
| TimescaleDB | ✅ Ready | PostGIS extension enabled for geospatial queries |
| Sensor Map | ✅ Ready | Real-time geospatial visualization interface |
| Connectivity Fairy | ✅ Ready | Component monitoring with interactive interface |
| Geo-Enrichment Service | ✅ Ready | Location-based context for Amazon rainforest regions |
| Rainforest Simulator | ✅ Ready | Generates realistic environmental data for testing |

## Components

- **ChirpStack Gateway Bridge**: Converts LoRa packet-forwarder protocols into a standard protocol
- **ChirpStack Network Server**: LoRaWAN network-server implementation
- **ChirpStack Application Server**: Web-interface and API for device management
- **EMQX**: Scalable MQTT broker for IoT messaging
- **Kafka**: Distributed event streaming platform for high-throughput data pipelines
- **PostgreSQL**: Database for persistent storage
- **Redis**: Key-value store for temporary data and queues
- **Telegraf**: Data collection and processing agent
- **TimescaleDB**: Time series database with PostGIS extension for IoT data storage and geospatial analysis
- **Sensor Map**: Real-time geospatial visualization for IoT sensors
- **Connectivity Fairy**: User-friendly infrastructure monitoring with interactive visuals
- **Geo-Enrichment Service**: Provides location-based context for sensor data
- **Amazon Rainforest Simulator**: Specialized simulator for generating realistic environmental data from the Amazon rainforest ecosystem

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure (for PostgreSQL, Redis, and EMQX persistence)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/chirpstack-helm.git
cd chirpstack-helm
```

2. Create a Kubernetes namespace for ChirpStack (optional):
```bash
kubectl create namespace chirpstack
```

3. Install the Helm chart:
```bash
# Install with default values
helm install chirpstack . -n chirpstack

# Or with custom values.yaml file
helm install chirpstack . -f custom-values.yaml -n chirpstack

# Alternatively, use our deployment script for guided installation
./deploy.sh chirpstack chirpstack values.yaml
```

4. Check the deployment status:
```bash
kubectl get all -n chirpstack

# Or use our test-deployment.sh script for detailed status checking
./test-deployment.sh --namespace chirpstack --release chirpstack
```

5. Troubleshoot specific components if needed:
```bash
# Debug Kafka issues
./scripts/kafka-debug.sh chirpstack chirpstack

# Debug Telegraf issues
./scripts/telegraf-debug.sh chirpstack chirpstack
```

6. Access the ChirpStack components:

   **Method 1: Using NodePort (external access)**
   
   Services are configured with NodePort to allow direct access from outside the cluster:
   
   ```bash
   # Get the Node's external IP
   kubectl get nodes -o wide
   ```
   
   Access the components at:
   - ChirpStack Application Server: http://<node-external-ip>:30080
   - ChirpStack Network Server: http://<node-external-ip>:30000
   - ChirpStack Gateway Bridge: UDP://<node-external-ip>:31700
   - Sensor Map: http://<node-external-ip>:30180
   - Connectivity Fairy: http://<node-external-ip>:30280
   
   **Method 2: Using Ingress**
   - If using an ingress controller, access using the hostname specified in `values.yaml`
   
   **Method 3: Using Port Forwarding**
   - For local development, you can still use port forwarding:
   ```bash
   kubectl port-forward svc/chirpstack-chirpstack-application-server 8080:8080 -n chirpstack
   kubectl port-forward svc/chirpstack-sensor-map 8081:80 -n chirpstack
   kubectl port-forward svc/chirpstack-connectivity-fairy 8082:80 -n chirpstack
   ```
   Then visit http://localhost:8080 (Application Server), http://localhost:8081 (Sensor Map), or http://localhost:8082 (Connectivity Fairy) in your web browser.

## Configuration

The following table lists common configurable parameters for the chart and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgresql.enabled` | Enable PostgreSQL deployment | `true` |
| `redis.enabled` | Enable Redis deployment | `true` |
| `emqx.enabled` | Enable EMQX deployment | `true` |
| `kafka.enabled` | Enable Kafka deployment | `true` |
| `kafka.replicas` | Number of Kafka brokers | `3` |
| `chirpstack-gateway-bridge.enabled` | Enable ChirpStack Gateway Bridge | `true` |
| `chirpstack-network-server.enabled` | Enable ChirpStack Network Server | `true` |
| `chirpstack-application-server.enabled` | Enable ChirpStack Application Server | `true` |
| `chirpstack-application-server.service.type` | Service type (NodePort or ClusterIP) | `NodePort` |
| `chirpstack-application-server.service.nodePort` | NodePort for external access | `30080` |
| `chirpstack-application-server.ingress.enabled` | Enable ingress for Application Server | `true` |
| `chirpstack-application-server.ingress.host` | Hostname for Application Server ingress | `chirpstack.local` |
| `telegraf.enabled` | Enable Telegraf for data collection | `true` |
| `timescaledb.enabled` | Enable TimescaleDB | `true` |
| `timescaledb.config.postgresql.max_connections` | Max PostgreSQL connections | `100` |
| `timescaledb.config.timescaledb.compression_enabled` | Enable TimescaleDB compression | `true` |
| `connectivity-fairy.enabled` | Enable Connectivity Fairy monitoring | `true` |
| `connectivity-fairy.service.type` | Service type (NodePort or ClusterIP) | `NodePort` |
| `connectivity-fairy.service.nodePort` | NodePort for external access | `30280` |
| `sensor-map.enabled` | Enable Real-time Geospatial Sensor Map | `true` |
| `sensor-map.service.type` | Service type (NodePort or ClusterIP) | `NodePort` |
| `sensor-map.service.nodePort` | NodePort for external access | `30180` |
| `sensor-map.ingress.host` | Hostname for Sensor Map ingress | `sensor-map.local` |
| `geo-enrichment-service.enabled` | Enable Geo-enrichment Service | `true` |
| `geo-enrichment-service.locationData.importDefaultLocations` | Import default locations | `true` |
| `geo-enrichment-service.service.port` | Service port | `8080` |
| `rainforest-simulator.enabled` | Enable Amazon Rainforest Simulator | `true` |
| `rainforest-simulator.config.simulation.sensorCount` | Number of simulated sensors | `15` |
| `rainforest-simulator.config.simulation.intervalSeconds` | Interval between data publications (seconds) | `60` |

For detailed configuration options, refer to the `values.yaml` file.

## Persistence

This chart uses Persistent Volume Claims for PostgreSQL, Redis, EMQX, Kafka, and TimescaleDB to store data. All components are configured to use the "local-path" storage class by default for wide compatibility across different Kubernetes distributions. 

If you need to use a different storage class in your environment, you can modify the following values in your custom values file:

```yaml
# Global TimescaleDB storage class
timescaledb:
  persistence:
    storageClass: "your-storage-class"

# Component-specific storage classes
postgresql:
  storage:
    class: "your-storage-class"
redis:
  storage:
    class: "your-storage-class"
emqx:
  storage:
    class: "your-storage-class"
kafka:
  persistence:
    storageClass: "your-storage-class"
```

TimescaleDB requires persistent storage for optimal time series data management and will automatically create tables optimized for time series data.

## Upgrading

To upgrade the release:

```bash
helm upgrade chirpstack . -n chirpstack
```

## Amazon Rainforest Monitoring Focus

This Helm chart is specially enhanced for deployment in the Amazon rainforest region with:

1. **Ecosystem-Specific Classification**:
   - Specialized data tagging for várzea floodplains, terra firme forests, and other Amazon biomes
   - Automatic altitude-based ecosystem classification
   - Indigenous territory monitoring capabilities

2. **Environmental Monitoring Features**:
   - Deforestation risk assessment based on sensor data patterns
   - Carbon storage classification by forest type
   - Biodiversity monitoring prioritization

3. **Geospatial Context for Brazil**:
   - Predefined locations for major protected areas and research stations
   - Special consideration for indigenous lands including Yanomami territory
   - Integration with Brazilian conservation status classification

4. **Advanced Analytics for Amazon Protection**:
   - Specialized queries for detecting environmental changes and threats
   - Correlation of air quality, temperature and humidity for fire risk assessment
   - Hydrological system monitoring for major Amazon basin waterways

## Architecture

This Helm chart follows the ChirpStack architecture flow:

```
LoRa Gateway → Chirpstack Gateway Bridge → EMQX → Chirpstack Network Server → EMQX → ChirpStack Application Server
```

Supporting infrastructure:
- PostgreSQL (database for both Network Server and Application Server)
- Redis (for temporary data and queue management)
- Kafka (for high-throughput event streaming)
- Telegraf (for data collection and processing)
- TimescaleDB (for time series data storage and analysis)

Alternative data flow using Kafka:
```
LoRa Gateway → Chirpstack Gateway Bridge → Kafka → Chirpstack Network Server → Kafka → ChirpStack Application Server
```

Time Series data collection flow for IoT analytics with geospatial enrichment:
```
LoRa Gateway → Gateway Bridge → EMQX → Network Server → EMQX → Application Server
                                                                       ↓
                                                                   Telegraf 
                                                                       ↓
                                                                     Kafka 
                                                                       ↓
                                                                   Telegraf
                                                                       ↓
                                          Geo-Enrichment Service ← TimescaleDB → PostGIS 
                                                                       ↓
                                                                  Sensor Map
```

## Testing with LWNSimulator

This chart includes a LoRaWAN Network Simulator (LWNSimulator) component that can be enabled for testing your ChirpStack deployment without physical LoRa hardware.

To enable the simulator when installing the chart:

```bash
# Create a custom values file with LWNSimulator enabled
cat > test-values.yaml << EOL
lwnsimulator:
  enabled: true
  simulatedNodes: 5  # Number of simulated nodes
  gateway:
    eui: "b827ebfffe13cee5"  # Custom Gateway EUI
EOL

# Install with LWNSimulator enabled
helm install chirpstack . -f test-values.yaml -n chirpstack
```

The simulator will:
1. Register a virtual gateway with ChirpStack
2. Create simulated LoRaWAN devices
3. Send periodic uplink messages
4. Process downlink messages

This allows you to test the entire ChirpStack stack without physical hardware.

## Amazon Rainforest Environmental Simulator

This chart includes a specialized Amazon Rainforest Environmental Simulator for simulating sensor data specific to the Amazon ecosystem:

```bash
# Create a custom values file with the rainforest simulator enabled
cat > rainforest-values.yaml << EOL
rainforest-simulator:
  enabled: true
  config:
    simulation:
      sensorCount: 15  # Number of simulated sensors
      intervalSeconds: 60  # Data publishing frequency
EOL

# Install with the rainforest simulator enabled
helm install chirpstack . -f rainforest-values.yaml -n chirpstack
```

The Amazon Rainforest Simulator:
1. Creates virtual environmental sensors for the Amazon rainforest
2. Simulates various sensor types (air quality, temperature/humidity, rainfall)
3. Publishes real-world-like data based on actual Amazon ecosystem characteristics 
4. Includes specialized metadata for forest types, ecosystem zones, and conservation status
5. Follows the same data processing pipeline through MQTT → Telegraf → Kafka → TimescaleDB

Key features:
- **Ecosystem-specific data**: Simulates realistic readings for different Amazon forest types
- **Geographical accuracy**: Places sensors in valid coordinates within the central Amazon basin
- **Environmental context**: Adds rainforest-specific metadata like ecosystem zone and conservation status
- **Seasonal variations**: Simulates wet/dry season effects on environmental readings
- **Conservation metadata**: Includes protected areas, indigenous territories, and deforestation risk zones

The simulator is perfect for:
- Demonstrating the specialized Amazon monitoring capabilities
- Testing the time-series data pipeline without physical sensors
- Developing visualization and analytics for environmental monitoring
- Training machine learning models for Amazon forest characteristics

## Time Series Data Analytics

The chart includes components for advanced IoT data analytics:

1. **Telegraf**: Collects data from EMQX MQTT broker, processes it, and forwards to TimescaleDB
   - MQTT Input plugin subscribes to ChirpStack application events
   - Data is buffered through specialized Kafka topics for each sensor type
   - Output plugin formats and writes data to appropriate TimescaleDB tables

2. **Kafka Topic Routing**:
   - `realtime-gr-dss-airqualitysensor`: For air quality sensor data (CO2, CO, NO2, O3, PM10, PM2.5)
   - `realtime-gr-dss-temperaturehumiditysensor`: For temperature/humidity sensor data

3. **TimescaleDB**: Optimized PostgreSQL extension for time series data
   - Specialized hypertables for different sensor types:
     - `airqualitysensor`: Stores air quality metrics
     - `temperaturehumiditysensor`: Stores temperature, humidity, and pressure
   - Automatic chunking of data by time intervals (1 hour chunks)
   - Efficient storage with hypertables
   - Advanced time-based queries and aggregations
   - Compression for older data

4. **Data Flow Path**:
   ```
   Gateway → Gateway Bridge → EMQX → Network Server → EMQX → Application Server
                                 ↓
                              Telegraf 
                                 ↓
                               Kafka 
                                 ↓
                              Telegraf
                                 ↓
                            TimescaleDB
   ```

5. **Use Cases**:
   - Long-term storage of sensor data
   - Historical trend analysis
   - Device performance monitoring 
   - Anomaly detection
   - Custom dashboards (can be integrated with Grafana)

## Real-time Geospatial Sensor Map

The Sensor Map provides a powerful visualization tool for your IoT sensors, displaying their physical locations and real-time data on an interactive map:

1. **Interactive Map Interface**:
   - View all sensors geographically on an OpenStreetMap-based interface
   - Color-coded status indicators for different sensor conditions
   - Detailed popups with current readings and sensor information
   - Responsive design that works on desktop and mobile devices

2. **Multiple Visualization Modes**:
   - Standard marker view with clustering for dense sensor deployments
   - Heat map view for identifying critical areas and sensor density
   - Health heatmap with color-coded gradients to visualize sensor health status
   - Timeline slider for viewing historical data and trends
   - Filtering controls to focus on specific sensor types or conditions

3. **Real-time Data Integration**:
   - Live updates from Kafka streams via WebSocket connection
   - Integration with TimescaleDB for historical data access
   - Automatic scaling to handle thousands of sensor points
   - Efficient data caching and updates to minimize network traffic

4. **Key Features**:
   - Sensor type filtering (air quality, temperature/humidity)
   - Value-based filtering to highlight critical readings
   - Interactive health indicators with color-coded and pulsing markers
   - Health metric selection (AQI, temperature, humidity, battery, signal)
   - Health heatmap with red-yellow-green gradient visualization
   - Customizable heatmap settings (radius, blur, intensity)
   - Sensor timeline to view data over time
   - Responsive sidebar for detailed sensor information
   - Direct access via ingress at `sensor-map.local`

## Kubernetes Connectivity Fairy

The Connectivity Fairy provides a friendly, accessible way to monitor the health and connectivity between all components in your ChirpStack deployment:

1. **Cute Mascot Interface**: A visually appealing dashboard with a fairy mascot that makes infrastructure monitoring more approachable
   - Animated fairy character provides status updates
   - Friendly, non-technical language for status reporting
   - Color-coded connectivity status indicators

2. **Real-time Component Monitoring**:
   - Automatically detects and maps all ChirpStack components
   - Displays live connectivity status between services
   - Identifies networking issues between pods

3. **Features**:
   - Interactive visualization of your IoT infrastructure
   - Customizable scanning intervals
   - Theme and mascot options (fairy, wizard, robot, unicorn)
   - Quick troubleshooting guidance
   - Accessible via Ingress from any browser

## Security Considerations

### Production Security Best Practices

For production deployments, it's essential to override default security settings. The chart includes default values that should be changed for any non-development environment:

1. **Database Credentials**: Replace default PostgreSQL and TimescaleDB passwords
2. **JWT Secret Keys**: Replace the default JWT secret with a strong, unique value
3. **MQTT Authentication**: Configure secure user/password for EMQX
4. **TLS/SSL**: Enable TLS for all exposed services
5. **Resource Limits**: Adjust according to your workload
6. **Network Policies**: Restrict communication between components

### Secure Override Example

Create a `secure-values.yaml` file to override sensitive defaults:

```yaml
# Database credentials
global:
  postgresql:
    existingSecret: "chirpstack-db-credentials"  # Create this secret separately with your secure password

# TimescaleDB secure configuration
timescaledb:
  config:
    database:
      password: null  # Set to null to use a Kubernetes secret instead
    existingSecret: "timescaledb-credentials"  # Create this secret separately
    
# JWT secret for ChirpStack Application Server
chirpstack-application-server:
  config:
    application_server:
      external_api:
        jwt_secret: null  # Set to null to use a Kubernetes secret
      existingSecret: "chirpstack-jwt-secret"  # Create this secret separately

# EMQX secure configuration
emqx:
  config:
    adminPassword: null  # Set to null to use a Kubernetes secret
    adminPasswordSecret: "emqx-admin-credentials"  # Create this secret separately
  
  # Secure the MQTT broker
  mqtt:
    authentication:
      enabled: true
      mode: "password"  # Options: password, jwt, oauth
      passwordSecret: "mqtt-user-credentials"  # Create this secret separately
  
  # Enable TLS for MQTT
  tls:
    enabled: true
    certSecret: "emqx-tls-cert"  # Create this TLS secret separately
```

### Creating Required Kubernetes Secrets

Before installing the chart with secure overrides, create the necessary secrets:

```bash
# PostgreSQL credentials
kubectl create secret generic chirpstack-db-credentials \
  --from-literal=password=<your-secure-password> \
  -n chirpstack

# TimescaleDB credentials
kubectl create secret generic timescaledb-credentials \
  --from-literal=password=<your-secure-password> \
  -n chirpstack

# JWT secret for ChirpStack
kubectl create secret generic chirpstack-jwt-secret \
  --from-literal=jwt_secret=<your-secure-jwt-secret> \
  -n chirpstack

# EMQX admin credentials
kubectl create secret generic emqx-admin-credentials \
  --from-literal=admin-password=<your-secure-admin-password> \
  -n chirpstack

# MQTT user credentials
kubectl create secret generic mqtt-user-credentials \
  --from-literal=username=<mqtt-username> \
  --from-literal=password=<mqtt-secure-password> \
  -n chirpstack
```

### Installing with Secure Configuration

Install the chart with your secure values:

```bash
helm install chirpstack . -f secure-values.yaml -n chirpstack
```

### Customizing Domain Names

The default configuration uses `.local` domains which won't work in production. Configure proper domain names in your values overrides:

```yaml
# Domain name configuration
chirpstack-application-server:
  config:
    application_server:
      api:
        public_host: "chirpstack.example.com"  # Change to your domain
  ingress:
    host: "chirpstack.example.com"  # Change to your domain
    
sensor-map:
  ingress:
    hosts:
      - host: "sensor-map.example.com"  # Change to your domain
        
connectivity-fairy:
  ingress:
    hosts:
      - host: "monitoring.example.com"  # Change to your domain
```

This ensures that your application is accessible via proper domain names with valid TLS certificates.

### Security Audit Checklist

Before going to production, verify these security items:

- [ ] Database passwords are securely stored in Kubernetes secrets
- [ ] JWT secret is a strong, unique value stored in a Kubernetes secret
- [ ] MQTT broker has authentication enabled
- [ ] TLS is configured for public-facing services
- [ ] Ingress resources use proper TLS certificates
- [ ] Resource limits are set appropriately
- [ ] Network policies restrict unnecessary communication
- [ ] Sensitive environment variables use secretKeyRef not hardcoded values
- [ ] Access to TimescaleDB is restricted to necessary components only

## Data Flow Architecture

This ChirpStack IoT Platform implementation uses a well-defined data pipeline for sensor data:

### Complete End-to-End Flow

```
LoRa Devices/Gateways
       │
       ▼
┌────────────────┐                      ┌─────────────┐
│   ChirpStack   │                      │ ChirpStack  │
│ Gateway Bridge │─────────┐            │  Network    │
└────────────────┘         │            │   Server    │
                           │            └─────────────┘
                           │                   │
                           ▼                   ▼
                      ┌─────────┐        ┌─────────────┐
                      │  EMQX   │◀───────│ ChirpStack  │
                      │ Cluster │───────▶│  App Server │
                      └─────────┘        └─────────────┘
                           │
                           │
                           ▼
                  ┌───────────────┐
                  │   Telegraf    │
                  │    Source     │
                  └───────────────┘
                           │
                           ▼
                  ┌─────────────┐
                  │    Kafka    │
                  │   Cluster   │
                  └─────────────┘
                           │
                           ▼
                  ┌───────────────┐
                  │   Telegraf    │
                  │     Sink      │
                  └───────────────┘
                           │
                           ▼
                  ┌─────────────┐
                  │ TimescaleDB │
                  │   Database  │
                  └─────────────┘
```

### Data Pipeline Focus

The specific data pipeline segment we've optimized is:

```
┌─────────┐    ┌───────────────┐    ┌─────────────┐    ┌───────────────┐    ┌─────────────┐
│  EMQX   │    │   Telegraf    │    │    Kafka    │    │   Telegraf    │    │ TimescaleDB │
│ Cluster │───▶│    Source     │───▶│   Cluster   │───▶│     Sink      │───▶│   Database  │
└─────────┘    └───────────────┘    └─────────────┘    └───────────────┘    └─────────────┘
    MQTT            Processor           Message           Processor            Time-series
   Broker                                Queue                                  Storage
```

### Component Responsibilities

1. **EMQX Cluster**: Receives MQTT messages from IoT devices and gateways using the ChirpStack protocol.
2. **Telegraf Source** (3 nodes): Consumes MQTT messages from EMQX, processes them (data typing, enrichment), and publishes to specific Kafka topics.
3. **Kafka Cluster**: Serves as the central message broker, providing buffering and reliable delivery of sensor data.
4. **Telegraf Sink** (3 nodes): Consumes from Kafka topics, performs final processing, and stores data in TimescaleDB tables.
5. **TimescaleDB**: Provides time-series storage with PostGIS extensions for geospatial capabilities.

### Data Transformation

The Telegraf Source applies the following transformations to the data:
- Tags data with data type (air quality, temperature/humidity)
- Enriches with metadata from the geo-enrichment service
- Routes to the appropriate Kafka topic based on data type

The Telegraf Sink applies these transformations:
- Consumes from Kafka topics
- Performs final data formatting
- Stores in the appropriate hypertable in TimescaleDB

## EMQX Cluster Formation

By default, EMQX nodes will try to auto-cluster, but in some Kubernetes environments, this might not work reliably. A manual cluster formation script is provided in the `scripts` directory to join EMQX pods into a single cluster.

To use this script:

```bash
# After deploying the chart and waiting for all EMQX pods to be running
# 1. First check that all EMQX pods are Running
kubectl get pods -n chirpstack -l app=chirpstack-emqx

# 2. Run the clustering script
./chirpstack-helm/scripts/emqx-cluster.sh --namespace chirpstack --release chirpstack

# 3. Verify the cluster is formed properly
kubectl exec -it chirpstack-emqx-0 -n chirpstack -- emqx ctl cluster status
```

This ensures that all EMQX nodes form a single, cohesive cluster for reliable MQTT message delivery across your ChirpStack deployment.

## Geospatial Features with PostGIS and Geo-enrichment

This chart includes comprehensive support for geospatial data through:

1. **PostGIS Extensions**: Built into TimescaleDB for advanced geospatial queries
2. **Geo-enrichment Service**: Provides location-based context for sensor data
3. **Automated Spatial Triggers**: Automatically maintain geospatial columns

### PostGIS Capabilities

PostGIS enables:

1. **Precise Location-based Queries**: Find sensors within geographic areas, calculate distances, and create geofences
2. **Geospatial Analytics**: Analyze sensor data with geographical context
3. **Advanced Visualization**: Generate heatmaps and other geospatial visualizations

PostGIS support is automatically enabled in TimescaleDB. Here are some example queries:

```sql
-- Find all sensors within 10km of Manaus, Brazil
SELECT * FROM airqualitysensor
WHERE ST_DWithin(
  location,
  ST_SetSRID(ST_MakePoint(-60.0217, -3.1190), 4326)::geography,
  10000
);

-- Find sensors inside Anavilhanas National Park in the Amazon
SELECT * FROM temperaturehumiditysensor
WHERE ST_Contains(
  ST_GeomFromText('POLYGON((-60.9 -2.4, -60.5 -2.4, -60.5 -2.8, -60.9 -2.8, -60.9 -2.4))', 4326),
  ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
);

-- Find average temperature by Amazon rainforest ecosystem type
SELECT 
  ecosystem_zone, 
  AVG(temperature) as avg_temp,
  AVG(humidity) as avg_humidity
FROM 
  temperaturehumiditysensor
GROUP BY 
  ecosystem_zone;

-- Track air quality trends in different forest types
SELECT 
  time_bucket('1d', time) AS day,
  forest_type,
  AVG(co2) as avg_co2,
  AVG(pm25) as avg_pm25
FROM 
  airqualitysensor
WHERE 
  ecosystem_zone IN ('lowland_rainforest', 'varzea_floodplain')
GROUP BY 
  day, forest_type
ORDER BY 
  day;
  
-- Monitor indigenous territories for environmental changes
SELECT 
  nearest_location,
  AVG(temperature) as avg_temperature,
  AVG(humidity) as avg_humidity,
  MAX(pm25) as max_pm25
FROM 
  airqualitysensor
WHERE 
  conservation_status = 'indigenous_territory'
  AND time > now() - INTERVAL '30 days'
GROUP BY 
  nearest_location;
  
-- Identify potential deforestation hotspots (high temperature, low humidity, high particulates)
SELECT 
  time_bucket('6h', a.time) AS period,
  a.nearest_location,
  AVG(t.temperature) as avg_temp,
  AVG(t.humidity) as avg_humidity,
  AVG(a.pm10) as avg_pm10,
  AVG(a.pm25) as avg_pm25
FROM 
  airqualitysensor a
JOIN
  temperaturehumiditysensor t
ON
  a.time = t.time AND a.nearest_location = t.nearest_location
WHERE 
  a.forest_type = 'terra_firme'
  AND t.temperature > 32
  AND t.humidity < 70
GROUP BY 
  period, a.nearest_location
HAVING 
  AVG(a.pm25) > 35
ORDER BY 
  avg_pm25 DESC;
```

### Geo-enrichment Service

The chart includes a dedicated Geo-enrichment Service that:

1. **Provides Location Context**: Maintains a database of locations (industrial zones, urban areas, natural features)
2. **Enriches Sensor Data**: Automatically tags sensor data with the nearest location names, types and distances
3. **Offers Geospatial APIs**: Provides RESTful endpoints for geospatial queries from other components
4. **Integrates with Telegraf**: Enhances sensor data with location context during the processing pipeline

The service provides APIs for:
- `/api/locations`: Get all reference locations
- `/api/locations/nearby?lat=X&lon=Y&radius=Z`: Find locations near a specific point

### Automatic Spatial Data Processing

The system automatically processes spatial data:

1. **Auto-updating Geometry Columns**: Database triggers automatically populate and maintain `geography` columns
2. **Spatial Indexing**: Geospatial indexes improve query performance for location-based searches
3. **Enrichment Tags**: Sensor data is automatically enhanced with:
   - Nearest location name and type
   - Distance to nearest location
   - List of containing locations
   - Altitude zone classification
   - Location-specific properties (industry type, regulatory regions, etc.)

### Integration with Sensor Map

These capabilities are fully integrated with the Sensor Map component to enable:

1. **Geographic Filtering**: Filter sensors by location, proximity to areas of interest
2. **Contextual Visualization**: Show sensors with their surrounding geographic context
3. **Environmental Impact Analysis**: View sensor data in relation to geographical features
4. **Pattern Detection**: Identify patterns and trends based on geographical context

## Troubleshooting

If you encounter issues:

1. **Use the Connectivity Fairy Dashboard**:
   The easiest way to troubleshoot is to use the Connectivity Fairy dashboard.
   
   Access via NodePort:
   ```bash
   # Get a node's external IP
   kubectl get nodes -o wide
   ```
   Then visit http://<node-external-ip>:30280 in your browser
   
   Or access via Ingress:
   ```bash
   # Get the Ingress URL
   ```
   
2. **Common Issues and Solutions**:

   **Issue**: YAML parsing errors during Helm template generation or installation
   **Solution**: The Telegraf ConfigMap in this chart has been simplified to avoid YAML parsing issues with multi-line strings. If you customize this file, be careful with indentation and string formatting in TOML configuration blocks. Use triple double-quotes (`"""`) for multi-line strings instead of triple single-quotes (`'''`).
   
   **Issue**: TimescaleDB doesn't initialize properly
   **Solution**: Check that the PostGIS extension is available in your PostgreSQL image. The init scripts assume this extension is available for geospatial features.
   
   **Issue**: MQTT communication issues between components
   **Solution**: Verify that the EMQX broker is running and that the components are using the correct broker address. The default configuration uses `{{ .Release.Name }}-emqx:1883` as the broker address.
   
   **Issue**: Data not flowing from EMQX to Kafka
   **Solution**: Check the Telegraf Source deployment logs to verify it's properly subscribed to MQTT topics and publishing to Kafka. Make sure the MQTT topics in Telegraf Source match those used by ChirpStack.
   
   **Issue**: Data not flowing from Kafka to TimescaleDB
   **Solution**: Check the Telegraf Sink deployment logs to verify it's properly consuming from Kafka topics and storing in TimescaleDB. Verify that the topics in the sink configuration match those produced by the source.
   
   **Issue**: Data visible in Kafka but not in TimescaleDB
   **Solution**: This typically indicates an issue with the Telegraf Sink configuration. Check the mapping between Kafka topics and TimescaleDB tables in the sink configuration. Ensure the sink has proper database credentials and permissions.
   
3. **Checking Logs**:
   ```bash
   # Check logs for a specific component
   kubectl logs -f deployment/chirpstack-chirpstack-application-server -n chirpstack
   
   # Check Telegraf Source logs (EMQX to Kafka)
   kubectl logs -f deployment/chirpstack-telegraf-source -n chirpstack
   
   # Check Telegraf Sink logs (Kafka to TimescaleDB)
   kubectl logs -f deployment/chirpstack-telegraf-sink -n chirpstack
   
   # Check TimescaleDB initialization logs
   kubectl logs -f statefulset.apps/chirpstack-timescaledb -n chirpstack
   ```
   
4. **Verifying Data Flow**:
   ```bash
   # Step 1: Verify MQTT topics in EMQX
   kubectl exec -it chirpstack-emqx-0 -n chirpstack -- emqx_ctl topics list
   
   # Step 2: Check if Telegraf Source is receiving MQTT messages
   kubectl exec -it deployment/chirpstack-telegraf-source -n chirpstack -- cat /tmp/telegraf-source-debug.out | tail
   
   # Step 3: Verify messages in Kafka
   kubectl exec -it chirpstack-kafka-0 -n chirpstack -- /opt/bitnami/kafka/bin/kafka-console-consumer.sh \
     --bootstrap-server localhost:9092 \
     --topic realtime-gr-dss-airqualitysensor \
     --max-messages 1
   
   # Step 4: Check if Telegraf Sink is processing Kafka messages
   kubectl exec -it deployment/chirpstack-telegraf-sink -n chirpstack -- cat /tmp/telegraf-sink-debug.out | tail
   
   # Step 5: Verify data is being stored in TimescaleDB
   kubectl exec -it statefulset/chirpstack-timescaledb -n chirpstack -- \
     psql -U postgres -d iot_timeseries -c "SELECT * FROM airqualitysensor ORDER BY time DESC LIMIT 5;"
   ```
   
   This sequence follows the exact data flow: EMQX → Telegraf Source → Kafka → Telegraf Sink → TimescaleDB

5. **Debug Template Generation**:
   If you're customizing the chart and encounter issues, use the debug flag to get more detailed error information:
   ```bash
   helm template . --debug > /tmp/debug-output.txt 2>&1
   ```

6. **Advanced Component-Specific Debugging**:

   **ChirpStack Core Components**:
   ```bash
   # Check Application Server logs
   kubectl logs -f deployment/chirpstack-chirpstack-application-server -n chirpstack
   
   # Check Network Server logs
   kubectl logs -f deployment/chirpstack-chirpstack-network-server -n chirpstack
   
   # Verify connectivity between components
   kubectl exec -it deployment/chirpstack-chirpstack-network-server -n chirpstack -- ping chirpstack-postgresql
   kubectl exec -it deployment/chirpstack-chirpstack-network-server -n chirpstack -- ping chirpstack-redis
   kubectl exec -it deployment/chirpstack-chirpstack-network-server -n chirpstack -- ping chirpstack-emqx
   ```
   
   **Telegraf and Data Pipeline**:
   ```bash
   # Check Telegraf Source configuration
   kubectl exec -it deployment/chirpstack-telegraf-source -n chirpstack -- telegraf --config /etc/telegraf/telegraf.conf --once --test
   
   # Check Telegraf Source metrics
   kubectl exec -it deployment/chirpstack-telegraf-source -n chirpstack -- telegraf --config /etc/telegraf/telegraf.conf --once --output-filter json
   
   # Check Telegraf Sink configuration
   kubectl exec -it deployment/chirpstack-telegraf-sink -n chirpstack -- telegraf --config /etc/telegraf/telegraf.conf --once --test
   
   # Check running MQTT subscriptions in Telegraf Source
   kubectl exec -it deployment/chirpstack-telegraf-source -n chirpstack -- ps aux | grep mqtt
   
   # Verify Telegraf Source can reach EMQX
   kubectl exec -it deployment/chirpstack-telegraf-source -n chirpstack -- nc -zv chirpstack-emqx 1883
   
   # Verify Telegraf Sink can reach TimescaleDB
   kubectl exec -it deployment/chirpstack-telegraf-sink -n chirpstack -- nc -zv chirpstack-timescaledb 5432
   ```
   
   **Kafka and Message Flow**:
   ```bash
   # Check Kafka logs
   kubectl logs -f statefulset/chirpstack-kafka -n chirpstack -c kafka
   
   # List Kafka topics
   kubectl exec -it chirpstack-kafka-0 -n chirpstack -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
   
   # Check specific Kafka topics
   kubectl exec -it chirpstack-kafka-0 -n chirpstack -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic realtime-gr-dss-airqualitysensor
   
   # View sample data in Kafka
   kubectl exec -it chirpstack-kafka-0 -n chirpstack -- /opt/bitnami/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic realtime-gr-dss-airqualitysensor --from-beginning --max-messages 5
   
   # Check Kafka consumer groups (verify Telegraf Sink is consuming)
   kubectl exec -it chirpstack-kafka-0 -n chirpstack -- /opt/bitnami/kafka/bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group telegraf_timescale_consumers
   ```

   **TimescaleDB and Data Storage**:
   ```bash
   # Check TimescaleDB status
   kubectl exec -it statefulset/chirpstack-timescaledb -n chirpstack -- pg_isready -U postgres
   
   # Examine hypertables
   kubectl exec -it statefulset/chirpstack-timescaledb -n chirpstack -- psql -U postgres -d iot_timeseries -c "SELECT * FROM timescaledb_information.hypertables;"
   
   # Check data in tables
   kubectl exec -it statefulset/chirpstack-timescaledb -n chirpstack -- psql -U postgres -d iot_timeseries -c "SELECT count(*) FROM airqualitysensor;"
   kubectl exec -it statefulset/chirpstack-timescaledb -n chirpstack -- psql -U postgres -d iot_timeseries -c "SELECT * FROM airqualitysensor ORDER BY time DESC LIMIT 5;"
   ```
   
   **Sensor Map and Visualization**:
   ```bash
   # Check Sensor Map API logs
   kubectl logs -f deployment/chirpstack-sensor-map -n chirpstack -c sensor-map-api
   
   # Verify API endpoints
   kubectl exec -it deployment/chirpstack-sensor-map -n chirpstack -- curl -s http://localhost:3000/health
   kubectl exec -it deployment/chirpstack-sensor-map -n chirpstack -- curl -s http://localhost:3000/api/sensors/all | head -20
   ```

## License

This Helm chart is released under the MIT License.
