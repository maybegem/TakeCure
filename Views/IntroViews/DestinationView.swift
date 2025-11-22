import SwiftUI

struct DestinationView: View {
    @Environment(\.dismiss) var dismiss
    
    var username : String
    @State var showintro : Bool = loadIntroFromFile()
    var body: some View {
        
        ZStack {
            // Colore di sfondo
            Color(red: 168/255, green: 239/255, blue: 255/255)
                .ignoresSafeArea()
            
            
            VStack {
                Text("Hi, \(username.capitalized)")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Text("How are you feeling today?")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black).padding(.bottom)
                
                VStack(spacing:60){
                    
                    HStack {
                        NavigationLink(destination: HappyView()) {
                            Text("😁")
                            
                        }
                        .font(.system(size: 80)).padding(.trailing,50)
                        
                        NavigationLink(destination: SadView()) {
                            Text("☹️")
                        }
                        .font(.system(size: 80))
                    }
                    
                    HStack {
                        NavigationLink(destination: TiredView()) {
                            Text("🫠")
                        }
                        .font(.system(size: 80)).padding(.trailing,50)
                        
                        NavigationLink(destination: OkView()) {
                            Text("😅")
                        }
                        .font(.system(size: 80))
                    }
                }
                .padding(.bottom, 90)
                
                NavigationLink(destination: ContentView()) {
                    Text("Skip")
                    
                    
                }.onDisappear{
                    showintro = false
                    saveIntroToFile(intro: showintro)
                    print("Da adesso non vedrò più la intro, ho salvato la variabile")
                }
                .frame(width: 70, height: 30, alignment: .center)
                .padding(.bottom, 1)
                .background(Color(red: 234/255, green: 233/255, blue: 233/255))
                .foregroundColor(.blue)
                .cornerRadius(40)
            }
        }
    }
}

#Preview {
    DestinationView(username: "Pippo")
}
