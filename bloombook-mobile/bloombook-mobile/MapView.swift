import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var manager = LocationManager()
    
    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        Text("Latitude: \(manager.region.center.latitude)")
        Text("Longitude: \(manager.region.center.longitude)")
        Button("Go to Current Location") {
            if let currentLocation = manager.getLocation() {
                manager.setCustomLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            }
        }
        .padding()
    }
}

#Preview {
    MapView()
}
