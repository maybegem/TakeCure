import SwiftUI

struct ContactListView: View {
    @Binding var contacts: [Contact]
    let title: String

    var filteredContacts: [Contact] {
        contacts.filter { $0.group.rawValue == title } // Filtro i contatti qui
    }

    var body: some View {
        List {
            ForEach(filteredContacts) { contact in
                NavigationLink(destination: ContactDetailView(contacts: $contacts, contact: contact)) {
                    HStack {
                        if let imageName = contact.imageName {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.trailing, 20)
                        }else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(contact.name) \(contact.surname)")
                                .font(.headline).padding(.top, 3)
                            
                            Text(contact.phoneNumber)
                                .font(.subheadline)
                                .foregroundColor(.black).padding(.bottom, 3)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}

#Preview {
    ContactListView(contacts: .constant([
        Contact(name: "Mario", surname: "Rossi", phoneNumber: "123-456-7890", email: "mario.rossi@example.com", group: .doctors),
        Contact(name: "Anna", surname: "Bianchi", phoneNumber: "456-789-1230", email: "anna.bianchi@example.com", group: .caregivers)
    ]), title: "Doctors")
}
