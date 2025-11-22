import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var isVisible = false
    @State private var showSplash = true
    @State private var showIntro = loadIntroFromFile()
    
    var body: some View {
        VStack {
            if showSplash {
                VStack {
                    Image("IntroImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .scaleEffect(scale)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.5)) {
                                scale = 1.2
                            }
                        }
                }
            } else {
                if showIntro {
                    IntroView()
                        
                } else {
                    ContentView()
                }
            }
        }
        .onAppear {
            // Dopo 2 secondi va via
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false 
                }
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    SplashView()
}
