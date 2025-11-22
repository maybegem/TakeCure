import SwiftUI

struct ContactView: View {
    @State private var contacts: [Contact] = []

    var body: some View {
        NavigationView {
            ZStack {
                
                GGradient(lightBlue: true).ignoresSafeArea()
                
                VStack(alignment:.center){
                    VStack(spacing:5) {
                        Text("")
                        Text("")
                        Text("")
                        Image("doctor").background(.clear).opacity(0.08).scaleEffect(0.5).frame(width: 200, height: 300)
                        Text("Contacts")
                            .font(.title).bold()
                    
                    }
                
                
                    VStack(){
                       
                        ForEach(DisclosureGroups.allCases, id: \.self) { group in
                            NavigationLink(destination: ContactListView(contacts: $contacts, title: group.rawValue)) { 
                                Text(group.rawValue)
                                    .frame(maxWidth: .infinity).padding([.top,.bottom],9)
                                    .background(Color.white.opacity(0.6))
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .cornerRadius(20)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal,80)
                            }
                        }


                    
                    
                    
                    
                }
                    
                 Spacer()
            }
                .navigationTitle("")
                .navigationBarItems(trailing: NavigationLink(destination: AddContactView(contacts: $contacts)) {
                    Image(systemName: "plus")
                })
            }
        }.onAppear{
            contacts = loadContactsFromFile()
            print("Loaded contacts: \(contacts)")
        }
    }
}

#Preview {
    ContactView()
}
