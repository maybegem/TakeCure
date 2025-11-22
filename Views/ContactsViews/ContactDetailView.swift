import SwiftUI

struct ContactDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var contacts: [Contact]
    @State var contact: Contact
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var showImagePicker = false
    @State private var selectedImage: String?
    let imageOptions = ["Image", "Image1", "Image2", "Image3", "Image4", "Image5", "Image6", "Image7", "Image8", "Image9"]

    var body: some View {
        VStack {
          
            Button(action: {
                if isEditing{
                    showImagePicker.toggle()
                }
            }){
                if let imageName = selectedImage ?? contact.imageName, !imageName.isEmpty{
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 30)
                        .padding(.bottom, 30)
                }else {
                    Image(systemName: "person.circle.fill")
                        .padding(.top, 30)
                        .font(.system(size: 80))
                        .padding(.bottom, 30)
                        .foregroundColor(.gray)
                }
            }.sheet(isPresented: $showImagePicker) {
                ImagePicker(imageOptions: imageOptions, selectedImage: $selectedImage){
                    contact.imageName = nil
                }
            }

            // Call Button
            Button(action: {
                if let url = URL(string: "tel://\(contact.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.white)
                    Text("Call \(contact.name) \(contact.surname)")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(25)
                .padding(.horizontal, 10)
            }

           
            Form {
                Section(header: Text("Name").font(.headline)) {
                    if isEditing {
                        TextField("e.g. Steve", text: $contact.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(contact.name.isEmpty ? "No name provided" : contact.name)
                    }
                }
                
                Section(header: Text("Surname").font(.headline)) {
                    if isEditing {
                        TextField("e.g. Jobs", text: $contact.surname)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(contact.surname.isEmpty ? "No surname provided" : contact.surname)
                    }
                }
                
                Section(header: Text("Phone Number").font(.headline)) {
                    if isEditing {
                        TextField("e.g. 321234456", text: $contact.phoneNumber)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(contact.phoneNumber.isEmpty ? "No phone number provided" : contact.phoneNumber)
                    }
                }
                
                Section(header: Text("Email").font(.headline)) {
                    if isEditing {
                        TextField("e.g. mariorossi@icloud.com", text: $contact.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(contact.email.isEmpty ? "No email provided" : contact.email)
                    }
                }
                
                Section(header: Text("Group").font(.headline)) {
                    if isEditing {
                        Picker("Select Group", selection: $contact.group) {
                            ForEach(DisclosureGroups.allCases, id: \.self) { group in
                                Text(group.rawValue).tag(group)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    } else {
                        Text(contact.group.rawValue)
                    }
                }
                
                
                Section(header: Text("")) {
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Text("Delete Contact")
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Contact"),
                            message: Text("Are you sure you want to delete this contact?"),
                            primaryButton: .destructive(Text("Delete")) {
                                if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
                                    contacts.remove(at: index)
                                    saveContactsToFile(contacts: contacts)
                                    dismiss()
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .padding([.top, .leading, .trailing])
        }
        .navigationTitle("Contact's Details")
        .navigationBarItems(trailing: Button(action: {
            if isEditing {
                if let selectedImage = selectedImage{
                    contact.imageName = selectedImage
                }
                if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
                    contacts[index] = contact  // Aggiorno il contatto esistente
                }
                saveContactsToFile(contacts: contacts)
            }
            isEditing.toggle()
        }) {
            Text(isEditing ? "Done" : "Edit")
                .fontWeight(.bold)
        }.disabled(contact.phoneNumber.isEmpty))
        .padding(.bottom, 20) 
        .onDisappear {
            
            saveContactsToFile(contacts: contacts)
        }
    }
}

#Preview {
    ContactDetailView(
        contacts: .constant([Contact(name: "Giuseppe", surname: "Asaro", phoneNumber: "", email: "", group: .doctors)]),
        contact: Contact(name: "Giuseppe", surname: "Asaro", phoneNumber: "", email: "", group: .doctors)
    )
}
