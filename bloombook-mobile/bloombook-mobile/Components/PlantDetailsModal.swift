import SwiftUI

class PlantDetailView: ObservableObject {
    @Published var selectedPlant: Plant?
    
    func selectPlant(_ plant: Plant) {
        selectedPlant = plant
    }
    
    func deselectPlant() {
        selectedPlant = nil
    }
}

struct PlantDetailsModal: View {
    var plant: Plant
    
    var body: some View {
        VStack {
            Text("Details")
                .font(.title)
                .foregroundColor(Color(hex: 0x283D3B))
                .padding(.bottom)
            Text("ID: \(plant.id)")
                .foregroundColor(Color(hex: 0x283D3B))
                .padding(.horizontal)
            Text("Latitude: \(plant.latitude)\nLongitude: \(plant.longitude)")
                .foregroundColor(Color(hex: 0x283D3B))
                .padding(.horizontal)
            Text("Information")
                .font(.title)
                .foregroundColor(Color(hex: 0x283D3B))
                .padding()
            Text("\(plant.data)")
                .foregroundColor(Color(hex: 0x283D3B))
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: 0xECD7BC))
        .cornerRadius(25)
        .shadow(radius: 5)
        .padding(.vertical, 100)
        .zIndex(10.0)
    }
}

