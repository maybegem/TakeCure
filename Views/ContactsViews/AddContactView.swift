import SwiftUI

struct AddContactView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var surname = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var group: DisclosureGroups = .doctors
    @State private var showImagePicker = false
    @State private var selectedImage: String?
    
    @Binding var contacts: [Contact]
    
    let imageOptions = ["Image", "Image1", "Image2", "Image3", "Image4", "Image5", "Image6", "Image7", "Image8", "Image9"]
    
    var body: some View {
        
        Button(action: {
            showImagePicker.toggle()
        }){
            if let selectedImage = selectedImage {
                Image(selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
            }else {
                Image(systemName: "person.crop.circle.badge.plus")
                    .padding(.top, 30)
                    .font(.system(size: 80))
                    .padding(.bottom, 30)
                    .foregroundColor(.gray)
            }
            
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(imageOptions: imageOptions, selectedImage: $selectedImage)
        }
        
            
        
        
        Form {
            Section(header: Text("Name")) {
                TextField("es. Steve", text: $name)
            }
            Section(header: Text("Surname")) {
                TextField("es. Jobs", text: $surname)
            }
            Section(header: Text("Phone Number")) {
                TextField("es. 321234456", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    
            }
            Section(header: Text("Email")) {
                TextField("es. mariorossi @icloud.com", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            Section(header: Text("Group")) {
                            Picker("Select Group", selection: $group) {
                                ForEach(DisclosureGroups.allCases, id: \.self) { group in
                                    Text(group.rawValue).tag(group)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
            
            
        }
        .navigationTitle("New Contact")
        .navigationBarItems(trailing: Button("Save") {
            let newContact = Contact(name: name, surname: surname, phoneNumber: phoneNumber, email: email, group: group, imageName: selectedImage)
            contacts.append(newContact)
            saveContactsToFile(contacts: contacts)
            dismiss()
        }.disabled(phoneNumber.isEmpty || name.isEmpty || surname.isEmpty))
        
    }
}

#Preview {
    AddContactView(contacts: .constant([Contact(name: "Mario", surname: "Rossi", phoneNumber: "123-456-7890", email: "mario.rossi@example.com", group: .caregivers)]))
}


