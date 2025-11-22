import SwiftUI

struct ModalView: View {
    var onClose: () -> Void
    var date: Date
    
    @Binding var tasks: [Task]
    @State private var showingPopOver = false
    @State private var showMedicineForm = false
    @State private var showAppointmentForm = false
    
    @State private var showAlert = false
    @State private var taskToComplete: Task?

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    let filteredTasks = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
                    
                    Rectangle()
                        .frame(width: 40, height: 5)
                        .foregroundColor(Color.gray)
                        .cornerRadius(10)
                        .padding(10)
                    
                    HStack {
                        Text(filteredTasks.count == 1 ? "Task of " : "Tasks of ")
                            .font(.title).padding(.top, 20).fontWeight(.regular)
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                            .font(.largeTitle).padding(.top).fontWeight(.medium)
                    }
                    
                    if !filteredTasks.isEmpty {
                        List {
                            ForEach(filteredTasks, id: \.id) { task in
                                HStack {
                                    TaskCircleView(task: task)
                                    VStack(alignment: .leading) {
                                        if task.isMedicine {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(task.medicineName)
                                                        .font(.headline)
                                                    Text(task.dosage)
                                                        .font(.subheadline)
                                                    Text(task.date.formatted(date: .omitted, time: .shortened))
                                                }
                                                Spacer()
                                                Button(action: {
                                                    
                                                    taskToComplete = task
                                                    showAlert = true
                                                }) {
                                                    Image(task.isCompleted ? "completoverde" : "incompleto")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 30)
                                                }
                                            }
                                        } else {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(task.appointment)
                                                        .font(.headline)
                                                    Text(task.appointmentNote)
                                                        .font(.subheadline)
                                                    Text(task.date.formatted(date: .omitted, time: .shortened))
                                                }
                                                Spacer()
                                                Button(action: {
                                                 
                                                    taskToComplete = task
                                                    showAlert = true
                                                }) {
                                                    Image(task.isCompleted ? "completoverde" : "incompleto")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 30)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deleteTask)
                        }
                        .listStyle(PlainListStyle())
                    } else {
                        Spacer()
                        Text("The list of events is empty!")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }
                }
                Spacer()
                
                HStack(alignment: .center) {
                    if Calendar.current.isDateInToday(date) || date > Date() {
                        Button("+ Add") {
                            showingPopOver = true
                        }
                        .frame(width: 70, height: 30, alignment: .center)
                        .padding(.bottom, 1)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .actionSheet(isPresented: $showingPopOver) {
                            ActionSheet(
                                title: Text("Select a type of adding"),
                                message: Text("Depending on your choice, the fields will change"),
                                buttons: [
                                    .cancel(),
                                    .default(Text("💊 Medicine"), action: {
                                        showMedicineForm = true
                                    }),
                                    .default(Text("🏩 Appointment"), action: {
                                        showAppointmentForm = true
                                    })
                                ]
                            )
                        }
                    } else {
                        Text("")
                    }
                }
                .padding()
                
                NavigationLink(destination: MedicineFormView(dates: [Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()), minute: Calendar.current.component(.minute, from: Date()), second: 0, of: date)!.addingTimeInterval(60)], tasks: $tasks, showMedicineForm: $showMedicineForm), isActive: $showMedicineForm) {
                    EmptyView()
                }

                NavigationLink(destination: AppointmentFormView(date:Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()), minute: Calendar.current.component(.minute, from: Date()), second: 0, of: date)!.addingTimeInterval(60),showAppointmentForm: $showAppointmentForm, tasks: $tasks), isActive: $showAppointmentForm) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            tasks = loadTasksFromFile()
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Confirm Completion"),
                  message: Text(taskToComplete?.isCompleted == true ?
                                "Are you sure you want to mark this task as incomplete?" :
                                "Are you sure you want to mark this task as completed?"),
                  primaryButton: .default(Text(taskToComplete?.isCompleted == true ? "Mark Incomplete" : "Confirm")) {
                      if let taskToComplete = taskToComplete, let index = tasks.firstIndex(where: { $0.id == taskToComplete.id }) {
                          tasks[index].isCompleted.toggle()
                          saveTasksToFile(tasks: tasks)
                      }
                  },
                  secondaryButton: .cancel(Text("Cancel")) {
                      taskToComplete = nil
                  })
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        let filteredTasks = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        let indicesToDelete = offsets.map { offset in
            tasks.firstIndex(where: { $0.id == filteredTasks[offset].id })!
        }

        // Cancello le notifiche per ogni task eliminata
        indicesToDelete.forEach { index in
            let task = tasks[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: task.notificationIdentifiers)
            tasks.remove(at: index)
        }

        saveTasksToFile(tasks: tasks)
    }

}

#Preview {
    ModalView(onClose: {}, date: Date(), tasks: .constant([Task(medicineName: "ciao", dosage: "500", frequency: Frequency.oneTime.rawValue, date: Date())]))
}
