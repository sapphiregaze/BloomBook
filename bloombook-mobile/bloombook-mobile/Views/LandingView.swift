import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("LandingBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.leading, 15)
                    
                    Spacer(minLength: 450)
                    
                    NavigationLink(destination: MapView()) {
                        Text("Get Started")
                            .foregroundColor(Color(hex: 0xECD7BC))
                            .padding(.vertical, 15)
                            .padding(.horizontal, 75)
                            .background(Color(hex: 0x4E7470))
                            .cornerRadius(25)
                            .font(.headline)
                    }
                    Spacer()
                    
                }.padding()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LandingView()
}
