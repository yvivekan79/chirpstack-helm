# Sensor Map

This Helm chart deploys a real-time geospatial visualization tool for IoT sensors in a ChirpStack implementation. It provides an interactive map interface to view the physical location and status of all sensors connected to your IoT network.

## Features

- **Real-time Visualization**: See your IoT sensors displayed on an interactive map with their current readings and status.
- **Multiple Sensor Support**: Displays both air quality and temperature/humidity sensors with appropriate visualization.
- **Filtering Capabilities**: Filter sensors by type, value range, and status.
- **Heat Map View**: Toggle between marker view and heat map visualization to quickly identify sensor density and critical areas.
- **Health Indicators**: Color-coded and pulsing indicators show the health status of each sensor.
- **Interactive Health Heatmap**: Specialized heatmap that uses color gradients to visualize the health of your sensor network.
- **Health Metrics**: Analyze different aspects of sensor health including air quality, temperature, humidity, battery level, and signal strength.
- **Timeline Slider**: View historical data at different time points.
- **Status Indicators**: Color-coded indicators show the health and status of each sensor.
- **Responsive Design**: Works on desktop and mobile devices.

## Architecture

The Sensor Map consists of two main components:

1. **Frontend UI**: A web-based interactive map built with Leaflet.js, served by Nginx.
2. **Backend API**: A Node.js API server that connects to:
   - TimescaleDB for historical sensor data
   - Kafka for real-time updates
   - WebSockets for pushing live updates to connected clients

## Configuration

The following table lists the configurable parameters for the Sensor Map chart:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `nginx` |
| `image.tag` | Image tag | `alpine` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `config.ui.defaultCenter.lat` | Default map center latitude | `51.505` |
| `config.ui.defaultCenter.lng` | Default map center longitude | `-0.09` |
| `config.ui.defaultZoom` | Default map zoom level | `4` |
| `config.ui.updateInterval` | Update interval in milliseconds | `5000` |
| `config.ui.mapProvider` | Map tile provider | `openstreetmap` |
| `config.features.clustering` | Enable marker clustering | `true` |
| `config.features.heatmap` | Enable heat map view | `true` |
| `config.features.healthIndicators` | Enable health status indicators | `true` |
| `config.features.healthHeatmap` | Enable health heatmap visualization | `true` |
| `config.features.timeline` | Enable timeline slider | `true` |
| `config.database.host` | TimescaleDB host | `timescaledb` |
| `config.database.port` | TimescaleDB port | `5432` |
| `config.database.database` | TimescaleDB database name | `iot_timeseries` |
| `config.kafka.enabled` | Enable Kafka integration | `true` |
| `config.kafka.topics` | Kafka topics to subscribe to | `[]` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Kubernetes service port | `80` |
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.hosts[0].host` | Ingress hostname | `sensor-map.local` |

## Data Flow

The Sensor Map integrates with the existing ChirpStack IoT data pipeline:

```
IoT Devices → ChirpStack → EMQX/Kafka → Telegraf → TimescaleDB → Sensor Map
                                      ↓
                             Real-time updates via Kafka
                                      ↓
                               Sensor Map (WebSocket)
```

## Database Schema

The Sensor Map relies on two TimescaleDB tables that should be created in the `iot_timeseries` database:

1. `air_quality_sensors`:
   - device_id
   - device_name
   - latitude
   - longitude
   - aqi (Air Quality Index)
   - pm25 (PM2.5 particulate matter)
   - pm10 (PM10 particulate matter)
   - created_at (timestamp)

2. `temperature_humidity_sensors`:
   - device_id
   - device_name
   - latitude
   - longitude
   - temperature
   - humidity
   - created_at (timestamp)

## Usage

To access the Sensor Map:

1. Deploy the chart with the ChirpStack helm chart
2. Access the UI at: `http://sensor-map.local` (or the hostname specified in the ingress configuration)
3. The API is available at: `/api/sensors/all`, `/api/sensors/air-quality`, and `/api/sensors/temperature-humidity`

For WebSocket real-time updates, connect to: `ws://sensor-map.local/api/ws`

### Health Heatmap Features

The Health Heatmap provides advanced visualization of your sensor network's health:

1. **Toggle Health View**: Use the toggle switch in the header to enable/disable health indicators for markers
2. **Health Heatmap Mode**: Select "Health Heat Map" from the view type dropdown
3. **Health Metrics**: Choose from different health metrics:
   - Air Quality Index
   - Temperature
   - Humidity
   - Battery Level
   - Signal Strength
4. **Customizable Visualization**: Use the heatmap controls to adjust:
   - Heat Radius: Size of the heat effect around each sensor
   - Heat Blur: Smoothness of the heatmap gradient
   - Heat Intensity: Strength of the heat effect

The heatmap uses a color gradient that shows:
- Red areas: Critical/unhealthy conditions
- Yellow areas: Warning/moderate conditions
- Green areas: Good/healthy conditions

This visualization helps quickly identify problem areas in your sensor network without having to check each sensor individually.