import SwiftUI

struct AppointmentFormView: View {
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var appointment: String = ""
    @State private var appointmentNote: String = ""
    @State var date: Date
    @Binding var showAppointmentForm: Bool
    @Binding var tasks: [Task]
    
    var body: some View {
        ZStack {
            GGradient(lightBlue: true).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Image("FotoPillole")
                        .resizable()
                        .scaledToFit()
                        
                    VStack(alignment: .leading) {
                        Text("Appointment")
                            .font(.subheadline)
                        Divider()
                        TextField("Enter your appointment", text: $appointment)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    VStack(alignment: .leading) {
                        Text("Appointment Note")
                            .font(.subheadline)
                        Divider()
                        TextField("Enter your appointment note", text: $appointmentNote, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .trailing, .top, .bottom], 4)
                            .lineLimit(5...7)
                            .frame(maxWidth: UIScreen.main.bounds.size.width)
                    }
                    
                    // Date Picker
                    VStack(alignment: .leading) {
                        Text("Date")
                            .font(.subheadline)
                        Divider()
                        
                        DatePicker("", selection: $date, in: Date()..., displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Appointment")
            .navigationBarItems(trailing: Button("Save") {
                saveMedicine()
            }.disabled(appointment.isEmpty || appointmentNote.isEmpty)
            
            )
            
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveMedicine() {
        
        if date <= Date() {
            errorMessage = "The date must not be earlier than the current date!"
            showErrorAlert = true
            return // Esci dalla funzione se la data è nel passato
        }

        do {
            
            let newTask = Task(appointment: appointment, appointmentNote: appointmentNote, date: date)
            tasks.append(newTask) 
            
            
            try saveTasksToFile(tasks: tasks)
            print("Appointment: \(appointment), \nAppointment note: \(appointmentNote), \nDate: \(date)")
            showAppointmentForm = false
            
            scheduleNotification(title: appointment, for: newTask, at: date)
        } catch {
            
            errorMessage = "Si è verificato un errore durante il salvataggio dell'appuntamento: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
}


#Preview {
    AppointmentFormView(date: Date(), showAppointmentForm: .constant(false), tasks: .constant([Task(medicineName: "ciao", dosage: "500", frequency: Frequency.oneTime.rawValue, date: Date())]))
}
 
