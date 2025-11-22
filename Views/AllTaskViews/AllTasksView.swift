import SwiftUI

struct AllTasksView: View {
    @Binding var tasks: [Task]
    
    @State private var isEditing = false
    @State private var selectedTasks = Set<UUID>() //set univoco di tasks
    @State private var showHistory = false
    @State private var showDeleteAlert = false
    @State private var tasksToDeleteCount = 0 // Tengo traccia di quante task elimino, alla selezione
    
    var groupedTasksByDate: [(date: Date, tasks: [Task])] {
        let grouped = Dictionary(grouping: tasks) { task in
            Calendar.current.startOfDay(for: task.date)
        }
        
        return grouped
            .filter { date, tasks in
                tasks.contains { !$0.isCompleted }
            }
            .sorted(by: { $0.key < $1.key })
            .map { (key, value) in (date: key, tasks: value) }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                List(selection: $selectedTasks) {
                    ForEach(groupedTasksByDate, id: \.date) { dateGroup in
                        Section(header: Text(dateGroup.date.formatted(date: .complete, time: .omitted)).font(.headline)) {
                            ForEach(dateGroup.tasks.filter { !$0.isCompleted && $0.date > Date() }) { task in
                                HStack {
                                    TaskCircleView(task: task)
                                    VStack(alignment: .leading) {
                                        Text(task.isMedicine ? "\(task.medicineName)" : "\(task.appointment)")
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
                .padding(.bottom, 1)
                .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "Done" : "Edit") {
                            withAnimation {
                                isEditing.toggle()
                                selectedTasks.removeAll()
                            }
                        }
                    }
                    if isEditing {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                tasksToDeleteCount = selectedTasks.count
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
                                    showHistory.toggle()
                                }
                            }) {
                                Text("History")
                            }
                        }
                    }
                }
                .navigationTitle("All Tasks")
                .alert(isPresented: $showDeleteAlert) {
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
            
            // HistoryView if showHistory is true
            if showHistory {
                GeometryReader { geometry in
                    HistoryView(tasks: $tasks, showHistory: $showHistory)
                        .frame(width: geometry.size.width)
                        .background(Color(.systemBackground))
                        .shadow(radius: 5)
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.3), value: showHistory)
                }
            }
        }
    }
    
    func toggleTaskSelection(_ task: Task) {
        if selectedTasks.contains(task.id) {
            selectedTasks.remove(task.id)
        } else {
            selectedTasks.insert(task.id)
        }
    }
    
    func deleteSelectedTasks() {
        tasks.removeAll { task in
            selectedTasks.contains(task.id)
        }
        selectedTasks.removeAll()
        saveTasksToFile(tasks: tasks)
    }
    
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
    AllTasksView(tasks: .constant([Task(medicineName: "Example", dosage: "500 mg", frequency: Frequency.recurringIntervals.rawValue)]))
}
