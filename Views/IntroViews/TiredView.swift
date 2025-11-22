import SwiftUI

struct TiredView: View {
    @State private var note: String = ""
    @FocusState private var noteFieldIsFocused: Bool
    @State var showintro : Bool = loadIntroFromFile()
    var body: some View {
            VStack{
                Text("🫠")
                    .font(.system(size: 100))
                Text("Keep going,")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Text("it will get better")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                Text("What is affecting your mood?")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                Divider().padding([.leading,.trailing], 30)
                TextField("Note", text: $note, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(5...12)
                    .background(Color(red: 242/255, green: 242/255, blue: 242/255)).opacity(0.8)
                    .focused($noteFieldIsFocused)
                    .onSubmit{
                        validate(name: note)
                    }
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .padding()
            }
            .padding(.bottom, 60)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ContentView()) {
                        Text("Done")
                    }.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).onAppear{
                        showintro = false
                        saveIntroToFile(intro: showintro)
                        print("Da adesso non vedrò più la intro, ho salvato la variabile")
                    }
                }
            }
        
        Text("Thank you!")
        .bold()
        .foregroundColor(.black)
        .padding(.bottom, 200)
    }
}

#Preview {
    TiredView()
}
