import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var manager = LocationManager()
    
    @State private var isShowingCamera = false
    @State private var image: UIImage?
    
    @StateObject private var plantDetailView = PlantDetailView()
    @State private var plants: [Plant] = []
    @State private var reloadMap = false
    
    func reload() {
        requestData(from: "http://100.105.23.103:8080/weed/", method: .GET) { result in
            switch result {
            case .success(let data):
                if let responseData = String(data: data, encoding: .utf8) {
                    do {
                        let plants = try JSONDecoder().decode([Plant].self, from: responseData.data(using: .utf8)!)
                        self.plants = plants
                        self.reloadMap = true
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
    
    func recenter() {
        reload()
        if let currentLocation = manager.getLocation() {
            manager.setCustomLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: plants) { plant in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: plant.latitude, longitude: plant.longitude)) {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                            .frame(width: 100, height: 100)
                            .padding(15)
                            .zIndex(10.0)
                            .onTapGesture {
                                plantDetailView.selectPlant(plant)
                            }
                        }
                }
                .ignoresSafeArea(.all)
                .zIndex(-1.0)
                .onTapGesture {
                    plantDetailView.deselectPlant()
                }
                
                
                if let selectedPlant = plantDetailView.selectedPlant {
                    PlantDetailsModal(plant: selectedPlant)
                        .environmentObject(plantDetailView)
                        .padding()
                }

                HStack {
                    Spacer()
                    
                    Button("➤ Re-center") {
                        recenter()
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
                        CameraCaptureModal(isShowingCamera: self.$isShowingCamera, image: self.$image, onPhotoCapture: { capturedImage in
                                recenter()
                                let currentLatitude = manager.region.center.latitude
                                let currentLongitude = manager.region.center.longitude
                                uploadPhoto(from: "http://100.105.23.103:8080/upload/", image: capturedImage, latitude: currentLatitude, longitude: currentLongitude) { result in
                                    switch result {
                                        case .success(let data):
                                            print("Upload successful. Response data: \(data)")
                                            recenter()
                                        case .failure(let error):
                                            print("Error uploading photo: \(error)")
                                    }
                                }
                        })
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.vertical, 40)

            }
            .onAppear {
                reload()
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
