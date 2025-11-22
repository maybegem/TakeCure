import SwiftUI

struct MedicineFormView: View {
    @State var medicineName: String = ""
    @State var doseAmount: String = ""
    @State var doseUnit: Dosage = .mg
    @State var frequency: Frequency = .oneTime
    @State var dates: [Date] = [] 
    @State var endDate = Date() 
    @Binding var tasks: [Task]
    @Binding var showMedicineForm: Bool
    @State var days = 0
    @State var intervals = 1
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            GGradient(lightBlue: true).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Image("FotoPillole")
                        .resizable()
                        .scaledToFit()
                    
                    // Campo nome medicina
                    VStack(alignment: .leading) {
                        Text("Medicine name")
                            .font(.subheadline)
                        Divider()
                        
                        TextField("Insert medicine name", text: $medicineName)
                            .padding(3)
                            .foregroundColor(.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Campo dose
                    VStack(alignment: .leading) {
                        Text("Dose")
                            .font(.subheadline)
                        Divider()
                        
                        HStack {
                            TextField("Insert dose (ex. 500)", text: $doseAmount)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                            
                            Picker("Select dosage unit", selection: $doseUnit) {
                                ForEach(Dosage.allCases) { dosage in
                                    Text(dosage.rawValue).tag(dosage)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: UIScreen.main.bounds.size.width / 3.5)
                        }
                    }
                    
                    // Picker Frequenza
                    VStack(alignment: .leading) {
                        Text("Frequence")
                            .font(.subheadline)
                        Divider()
                        HStack{
                            Picker("Select frequency", selection: $frequency) {
                                ForEach(Frequency.allCases, id: \.self) { frequency in
                                    Text(frequency.rawValue).tag(frequency)
                                }
                            }
                            Spacer()
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        
                        if frequency == Frequency.recurringIntervals {
                            HStack(spacing: 25){
                                VStack(alignment: .center) {
                                    Text("Pick the start date").font(.subheadline)
                                    Divider()
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10).frame(width:UIScreen.main.bounds.size.width / 3.2,height: 40).foregroundStyle(.blue)
                                        Text(dates[0], format: .dateTime.day().month().year()).foregroundStyle(.white).bold().opacity(0.6)
                                    }
                                    HStack {
                                        Text(">")
                                        DatePicker("Select end date", selection: $endDate, displayedComponents: [.date])
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                            .background().cornerRadius(7)
                                        Text("<")
                                    }
                                    Spacer()
                                }
                                VStack(alignment: .center) {
                                    Text("Pick the interval").font(.subheadline)
                                    Divider()
                                    
                                    Picker("", selection: $intervals) {
                                        ForEach(1...30, id: \.self) { interval in
                                            if interval == 1 {
                                                Text("Every day")
                                            } else {
                                                Text("Every \(interval) days")
                                            }
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .background(Color(red: 239/255, green: 239/255, blue: 240/255)).cornerRadius(15)
                                }
                            }.padding(.top,20)
                        }
                    }
                    
                    // DatePickers dinamici
                    VStack(alignment: .leading) {
                        Text("Pick the time")
                            .font(.subheadline)
                        Divider()
                        
                        ForEach(0..<dates.count, id: \.self) { index in
                            HStack {
                                DatePicker("Select date and time", selection: $dates[index], displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                
                                // Bottone per aggiungere un altro DatePicker
                                if index == dates.count - 1 {
                                    Button("+") {
                                        addDatePicker()
                                    }
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .padding(.bottom, 1)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(60)
                                    .bold()
                                }
                                if dates.count > 1  {
                                        Button("-") {
                                            removeDatePicker(at: index)
                                        }
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .padding(.bottom, 1)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(60)
                                        .bold()
                                    
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Medicine")
            .navigationBarItems(trailing: Button("Save") {
                saveMedicine()
            }.disabled(medicineName.isEmpty || doseAmount.isEmpty)
            .onAppear {
                
                endDate = dates[0].addingTimeInterval(86400) 
               
            })
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    private func addDatePicker() {
        dates.append(dates[0])
    }
    
    private func removeDatePicker(at index: Int) {
        guard index >= 0 && index < dates.count else {
            print("Index out of bounds")
            return
        }
        dates.remove(at: index)
    }

    
    
     func saveMedicine() {
        let startDate = dates[0]
        
        
        if startDate < Date() || endDate <= Date() {
            errorMessage = "The start and end dates must be in the future!"
            showErrorAlert = true
            return
        }

        // Se la frequenza è onetime, salva un task per ogni orario selezionato
        if frequency == .oneTime {
            for date in dates {
                let newTask = Task(medicineName: medicineName, dosage: doseAmount + " " + doseUnit.rawValue, frequency: frequency.rawValue, date: date)
                tasks.append(newTask)
                scheduleNotification(title: medicineName, for: newTask, at: date)
            }
        } else {
            
            let calendar = Calendar.current
            
            // Creo la task per ogni data selezionata
            for date in dates {
                var currentDate = date
                
                while currentDate <= endDate {
                    let newTask = Task(medicineName: medicineName, dosage: doseAmount + " " + doseUnit.rawValue, frequency: frequency.rawValue, date: currentDate)
                    tasks.append(newTask)
                    
                    // Configuro la notifica per ogni task
                    scheduleNotification(title: medicineName, for: newTask, at: currentDate)
                    
                    if let nextDate = calendar.date(byAdding: .day, value: intervals, to: currentDate) {
                        currentDate = nextDate
                    } else {
                        break
                    }
                }
            }
        }

        saveTasksToFile(tasks: tasks)
        print("Medicina salvata con data iniziale \(startDate) e finale \(endDate)")
        showMedicineForm = false
    }


    // Funzione per configurare e pianificare una notifica

}

#Preview {
    MedicineFormView(tasks: .constant([Task(medicineName: "Example", dosage: "500 mg", frequency: Frequency.recurringIntervals.rawValue, date: Date())]), showMedicineForm: .constant(false))
}
