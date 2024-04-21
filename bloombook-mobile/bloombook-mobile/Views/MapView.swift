import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var manager = LocationManager()
    
    @State private var isShowingCamera = false
    @State private var image: UIImage?
    
    @State private var plants: [Plant] = []
    @State private var reloadMap = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: plants) { plant in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: plant.latitude, longitude: plant.longitude))
                }
                .ignoresSafeArea(.all)
                .zIndex(-1.0)
                
                HStack {
                    Spacer()
                    
                    Button("➤ Re-center") {
                        if let currentLocation = manager.getLocation() {
                            manager.setCustomLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                        }
                    }
                    .foregroundColor(Color(hex: 0xECD7BC))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                    .background(Color(hex: 0x4E7470))
                    .cornerRadius(50)
                    .font(.headline)
                    
                    ForEach(0..<4) { _ in
                        Spacer()
                    }

                    Button("Take Photo") {
                        self.isShowingCamera.toggle()
                    }
                    .foregroundColor(Color(hex: 0xECD7BC))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                    .background(Color(hex: 0x4E7470))
                    .cornerRadius(50)
                    .font(.headline)
                    .sheet(isPresented: $isShowingCamera) {
                        CameraCaptureModal(isShowingCamera: self.$isShowingCamera, image: self.$image)
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.vertical, 40)

            }
            .onAppear {
                requestData(from: "http://100.105.23.103:8080/weed", method: .GET) { result in
                    switch result {
                    case .success(let data):
                        if let responseData = String(data: data, encoding: .utf8) {
                            do {
                                let plants = try JSONDecoder().decode([Plant].self, from: responseData.data(using: .utf8)!)
                                self.plants = plants
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        } else {
                            print("Invalid response data format")
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            .onChange(of: reloadMap) { _ in
                manager.reloadMapView()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MapView()
}
