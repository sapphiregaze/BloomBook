import MapKit

@MainActor final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 0, longitude: 0),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
        //If we are authorized then we request location just once, to center the map
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        //If we don´t, we request authorization
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func setCustomLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.region = coordinateRegion
        }

    
    func getLocation() -> (latitude: Double, longitude: Double)? {
        guard let location = locationManager.location else {
            print("Location not available")
            return nil
        }
        return (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func reloadMapView() {
        region = region
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
            if let location = locations.last {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        }
    }
}
