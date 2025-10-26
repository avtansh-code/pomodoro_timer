import SwiftUI

struct LaunchScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark ?
                    [Color(red: 139/255, green: 0/255, blue: 0/255),
                     Color(red: 45/255, green: 27/255, blue: 27/255)] :
                    [Color(red: 1.0, green: 0.39, blue: 0.28),
                     Color(red: 1.0, green: 0.53, blue: 0.33)]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Tomato Timer Icon
                ZStack {
                    // Main circle
                    Circle()
                        .fill(Color.white.opacity(0.95))
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                    
                    // Timer arc
                    Circle()
                        .trim(from: 0, to: 0.75)
                        .stroke(
                            colorScheme == .dark ?
                                Color(red: 139/255, green: 0/255, blue: 0/255).opacity(0.3) :
                                Color(red: 1.0, green: 0.39, blue: 0.28).opacity(0.3),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))
                    
                    // Clock hand
                    Rectangle()
                        .fill(
                            colorScheme == .dark ?
                                Color(red: 139/255, green: 0/255, blue: 0/255).opacity(0.5) :
                                Color(red: 1.0, green: 0.39, blue: 0.28).opacity(0.5)
                        )
                        .frame(width: 4, height: 60)
                        .offset(y: -30)
                    
                    // Center dot
                    Circle()
                        .fill(
                            colorScheme == .dark ?
                                Color(red: 139/255, green: 0/255, blue: 0/255).opacity(0.5) :
                                Color(red: 1.0, green: 0.39, blue: 0.28).opacity(0.5)
                        )
                        .frame(width: 12, height: 12)
                    
                    // Tomato stem/leaf
                    VStack(spacing: -10) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.9))
                            .rotationEffect(.degrees(-20))
                    }
                    .offset(y: -110)
                }
                
                VStack(spacing: 12) {
                    // App name
                    Text("FocusFlow")
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    // Tagline
                    Text("Stay Focused, Stay Productive")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}

#Preview("Dark Mode") {
    LaunchScreenView()
        .preferredColorScheme(.dark)
}
