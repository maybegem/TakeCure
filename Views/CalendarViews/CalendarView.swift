import SwiftUI

struct CalendarView: View {
    
    @State private var currentDate = Date()
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State var showingModal = false
    @State var showingAllTasks = false // Stato per mostrare tutte le attività
    @State var calendarDate = CalendarDate()
    @State private var calendarOffset: CGFloat = 0
    @Binding var tasks: [Task] 
    
    var body: some View {
        ZStack {
            GGradient(lightBlue: true).ignoresSafeArea()
            
            VStack(spacing: 5) {
                
                VStack(spacing: 5) {
                    
                    Text(calendarDate.selectedDate.year())
                        .font(.largeTitle).bold()
                    
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                calendarDate.selectedMonth -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .padding()
                        }
                        
                        Spacer()
                        
                        Text(calendarDate.selectedDate.month())
                            .font(.title).bold()
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                calendarDate.selectedMonth += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .padding()
                        }
                    }
                    
                    
                    HStack {
                        ForEach(days, id: \.self) { day in
                            Text(day)
                                .font(.headline)
                                .frame(width: UIScreen.main.bounds.size.width / 9)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.size.height / 3, alignment: .bottom)
                
                
                Divider()
                    .background(.gray)
                    .padding([.trailing, .leading], 25)
                
                
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(calendarDate.fetchDates()) { value in
                            ZStack {
                                if value.day != -1 {
                                    VStack {
                                        ZStack {
                                            if Calendar.current.isDate(value.date, inSameDayAs: Date()) {
                                                Text("\(value.day)")
                                                    .foregroundColor(.red)
                                                    .fontWeight(.bold)
                                            } else if value.date < Date() {
                                                Text("\(value.day)")
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text("\(value.day)")
                                                    .foregroundColor(.black)
                                            }
                                            
                                            let tasksForDate = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: value.date) }
                                            
                                            if !tasksForDate.isEmpty {
                                                HStack(spacing: 2) {
                                                    if tasksForDate.contains(where: { $0.isMedicine }) {
                                                        Circle()
                                                            .foregroundColor(.green)
                                                            .frame(width: 5, height: 5)
                                                    }
                                                    
                                                    if tasksForDate.contains(where: { !$0.isMedicine }) {
                                                        Circle()
                                                            .foregroundColor(.red)
                                                            .frame(width: 5, height: 5)
                                                    }
                                                }
                                                .padding(.top, 30)
                                            }
                                        }
                                    }
                                } else {
                                    Text("")
                                }
                            }
                            .frame(width: 45, height: 45)
                            .cornerRadius(30)
                            .onTapGesture {
                                calendarDate.selectedDate = value.date
                                withAnimation(.linear(duration: 0.15)) {
                                    calendarOffset = -100
                                }
                                showingModal.toggle()
                            }
                        }
                    }
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(15)
                    .padding()
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        calendarDate.selectedMonth += 1
                                    }
                                } else if value.translation.width > 0 {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        calendarDate.selectedMonth -= 1
                                    }
                                }
                            }
                    )
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .offset(y: calendarOffset)
            .onChange(of: calendarDate.selectedMonth) { _ in
                calendarDate.selectedDate = calendarDate.fetchSelectedMonth()
            }
            .sheet(isPresented: $showingModal, onDismiss: {
                showingModal = false
                withAnimation (.easeInOut(duration: 0.2)) {
                    calendarOffset = 0
                }
            }) {
                VStack {
                    ModalView(onClose: {
                        showingModal = false
                        withAnimation (.linear(duration: 0.1)) {
                            calendarOffset = 0
                        }
                    }, date: calendarDate.selectedDate, tasks: $tasks)
                }
                .presentationDetents([.medium])
                .presentationCornerRadius(25)
            }
            
            //Tolto poichè messo in tab bar
//            VStack {
//                HStack {
//                    Spacer()
//                    
//                    Button(action: {
//                        showingAllTasks.toggle() // Mostra tutte le attività
//                    }) {
//                        Text("All Tasks")
//                            .font(.headline)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 8)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding(.trailing, 20)
//                }
//                Spacer() // Spinge il pulsante verso l'alto
//            }
        }
        .sheet(isPresented: $showingAllTasks) {
            AllTasksView(tasks: $tasks) // Mostra la vista di tutte le attività
        }
        .onAppear {
            tasks = loadTasksFromFile()
        }
        
    }
        
}

#Preview {
    CalendarView(tasks: .constant([Task(medicineName: "Example", dosage: "500 mg", frequency: Frequency.recurringIntervals.rawValue)]))
}
