import SwiftUI

struct IntroView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var username: String = ""
    @FocusState private var nameFieldIsFocused: Bool
    @State private var navigateToDestinationView = false

    var body: some View {
        NavigationView {
            ZStack {
                    // Colore di sfondo
                    Color(red: 168/255, green: 239/255, blue: 255/255)
                        .ignoresSafeArea() // Riempie l'intera area della schermata
                    
                    // Testo centrato
                    VStack (spacing: 20){
                        
                        Text("Welcome to TakeCure,")
                        //  .font(.title).bold()
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.top, 200)
                        
                        
                        Text("the app designed")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .lineLimit(20)
                        Text("to help you manage your self-care")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .lineLimit(20)
                            .padding(.bottom, 70)
                        
                        VStack{
                            Text("Insert your nickname here:")
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                            Divider().padding([.leading,.trailing], 30)
                            
                            TextField(
                                "es. Gloria",
                                text: $username
                            )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($nameFieldIsFocused)
                            .onSubmit{
                                validate(name: username)
                            }
                            .textInputAutocapitalization(.never)
                            .padding(.horizontal)
                            .disableAutocorrection(true)
                            .padding(.bottom, 100)
                        }
                       
                        NavigationLink(destination: DestinationView(username: username)) {
                            Text("Confirm")
                                .bold()
                                .padding(.bottom, 200)
                        }.disabled(username.isEmpty)
                    }
            }
        }
        
        }
    }

func validate(name: String) {
    if name.isEmpty {
        print("Nome non valido: campo vuoto.")
    } else {
        print("Nome valido: \(name)")
    }
    
}

#Preview {
    IntroView()
}
