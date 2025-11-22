import SwiftUI

struct HistoryView: View {
    @Binding var tasks: [Task]
    
    @State private var isEditing = false
    @State private var selectedTasks = Set<UUID>()
    @Binding var showHistory: Bool
    @State private var showDeleteAlert = false
    @State private var tasksToDeleteCount = 0 // Stessa cosa di alltasksview

    var green = Color(red: 0, green: 0.70, blue: 0)
    var groupedTasksByDate: [(date: Date, tasks: [Task])] {
        // Raggruppo i task per data
        let grouped = Dictionary(grouping: tasks) { task in
            Calendar.current.startOfDay(for: task.date)
        }
        
        // Filtro solo le date e i task precedenti alla data corrente
        return grouped
            .filter { $0.key < Date() }
            .map { (key: $0.key, tasks: $0.value.filter { $0.date < Date() }) }
            .filter { !$0.tasks.isEmpty }
            .sorted(by: { $0.date < $1.date })
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    // Frase informativa
                    Text("Here you will see all the history, starting from the scheduled time of the medication.")
                        .font(.subheadline).bold().opacity(0.6).multilineTextAlignment(.center)
                        .padding()
                    
                    HStack {
                        Text("•  Completed").font(.subheadline).bold().foregroundStyle(green)
                        Text("• Not completed").font(.subheadline).bold().foregroundStyle(.red)
                    }
                    
                    List(selection: $selectedTasks) {
                        ForEach(groupedTasksByDate, id: \.date) { dateGroup in
                            Section(header: Text(dateGroup.date.formatted(date: .complete, time: .omitted)).font(.headline)) {
                                ForEach(dateGroup.tasks) { task in
                                    HStack {
                                        TaskCircleView(task: task)
                                        VStack(alignment: .leading) {
                                            Text(task.isMedicine ? "\(task.medicineName)" : "\(task.appointment)")
                                                .foregroundStyle(task.isCompleted ? green : Color.red)
                                                .font(.headline)
                                            Text("Due: \(task.date.formatted(date: .numeric, time: .standard))")
                                                .font(.subheadline)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        if isEditing {
                                            toggleTaskSelection(task)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(isEditing ? "Done" : "Edit") {
                                withAnimation {
                                    isEditing.toggle()
                                    selectedTasks.removeAll() //Resetto la selezione appena esco
                                }
                            }
                        }
                        if isEditing {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    tasksToDeleteCount = selectedTasks.count // Faccio andare avanti il counter di selezione
                                    showDeleteAlert = true
                                }) {
                                    Image(systemName: "trash")
                                }
                                .disabled(selectedTasks.isEmpty)
                            }
                        }
                        if !isEditing {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    withAnimation {
                                        showHistory.toggle() // Cambio scheda con animazione
                                    }
                                }) {
                                    Text("< Back")
                                }
                            }
                        }
                    }
                    .navigationTitle("History")
                    .alert(isPresented: $showDeleteAlert) { // Alert quando si tenta di eliminare i task
                        Alert(
                            title: Text("Delete Tasks"),
                            message: Text(tasksToDeleteCount == 1
                                          ? "Are you sure you want to delete this task?"
                                          : "Are you sure you want to delete these \(NumberFormatter.localizedString(from: NSNumber(value: tasksToDeleteCount), number: .spellOut)) tasks?"),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteSelectedTasks()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
            }
        }
    }
    
    // Funzione per aggiungere o togliere un task dalla selezione
    func toggleTaskSelection(_ task: Task) {
        if selectedTasks.contains(task.id) {
            selectedTasks.remove(task.id)
        } else {
            selectedTasks.insert(task.id)
        }
    }
    
    // Funzione per eliminare le task selezionate
    func deleteSelectedTasks() {
        tasks.removeAll { task in
            selectedTasks.contains(task.id)
        }
        selectedTasks.removeAll() //Resetto la selezione appena
        saveTasksToFile(tasks: tasks)
    }
    
    // Funzione per eliminare una singola task
    func deleteTask(at offsets: IndexSet) {
        let filteredTasks = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
        let indicesToDelete = offsets.compactMap { offset in
            tasks.firstIndex(where: { $0.id == filteredTasks[offset].id })
        }

        indicesToDelete.forEach { index in
            let task = tasks[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: task.notificationIdentifiers)
            tasks.remove(at: index)
        }
        saveTasksToFile(tasks: tasks)
    }
}

#Preview {
    HistoryView(tasks: .constant([Task(medicineName: "Example", dosage: "500 mg", frequency: Frequency.recurringIntervals.rawValue)]), showHistory: .constant(false))
}
