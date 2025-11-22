import Foundation
struct CalendarDate : Identifiable {
    
    let id = UUID()
    var day = 1
    var date = Date()

    var selectedMonth = 0
    var selectedDate = Date()
    
  
    
    
    func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()
        var datesOfMonth = currentMonth.datesOfMonth().map({CalendarDate(day: calendar.component(.day, from: $0) ,date : $0)})
        
        let firstDayOfWeek = calendar.component(.weekday, from: datesOfMonth.first?.date ?? Date())
        
        for _ in 0..<firstDayOfWeek - 1 {
            datesOfMonth.insert(CalendarDate(day: -1,date: Date()), at: 0)
        }
            
            
        return datesOfMonth
    }
    
    
    
    func fetchSelectedMonth() -> Date{
        let calendar = Calendar.current
        let month = calendar.date(byAdding: .month, value: selectedMonth, to: Date())
        return month!
    }
    
}

extension Date {
    
    
    func month() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    func monthNumber() -> Int {
            let calendar = Calendar.current
            return calendar.component(.month, from: self)
        }
    
    func year() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
    
    
    
    
    func datesOfMonth() -> [Date]{
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear
        startDateComponents.month = currentMonth
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)!
        
        var endDateComponents = DateComponents()
        endDateComponents.month = 1
        endDateComponents.day = -1
        let endDate = calendar.date(byAdding: endDateComponents, to: startDate)!
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
        
    }
    
    
}


