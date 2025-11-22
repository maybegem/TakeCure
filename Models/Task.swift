import Foundation

class Task : Identifiable, Codable{
    
    var id = UUID()
    var medicineName = String()
    var dosage = String()
    var frequency = Frequency.oneTime
    var date = Date()
    var appointment = String()
    var appointmentNote = String()
    var isMedicine = Bool()
    var isCompleted = Bool()
    var notificationIdentifiers: [String] = []
    
    
    init(medicineName: String = String(), dosage: String = String(), frequency: String = String(), date: Date = Date()) {
        self.medicineName = medicineName
        isMedicine = true
        self.dosage = dosage
        self.frequency = Frequency.oneTime
        self.date = date
        
    }
    
    init(appointment: String = String(),appointmentNote: String = String(),date: Date = Date()) {
        
        self.appointment = appointment
        self.appointmentNote = appointmentNote
        self.date = date
    }
    
    
}


enum Frequency : String, CaseIterable, Identifiable, Codable{
    
    case oneTime = "One time"
    case recurringIntervals = "Recurring intervals"
    
    
    
    var id: String { self.rawValue }
}


enum Dosage: String, CaseIterable, Identifiable, Codable {
    case mg = "mg"                // milligrams
    case g = "g"                  // grams
    case ml = "ml"                // milliliters
    case l = "l"                  // liters
    case teaspoon = "teaspoon"    // teaspoons
    case tablespoon = "tablespoon" // tablespoons
    case cup = "cup"              // cups
    case other = "other"
    
    var id: String { self.rawValue }
}
