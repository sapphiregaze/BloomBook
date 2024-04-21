import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var manager = LocationManager()
    
    @State private var isShowingCamera = false
    @State private var image: UIImage?

    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $manager.region, showsUserLocation: true)
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
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()

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
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MapView()
}
