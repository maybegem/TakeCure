import Foundation
import SwiftUI
import UserNotifications

func scheduleNotificationAppointment(title: String, for task: Task, at date: Date) {
    let content = UNMutableNotificationContent()
    content.title = title.capitalized
    content.subtitle = "Remember to take your medicine!"
    content.sound = UNNotificationSound.default

    var notificationIdentifiers: [String] = []

    let newDate = date.addingTimeInterval(-1800)
    let timeInterval = newDate.timeIntervalSinceNow
    let initialTrigger = UNTimeIntervalNotificationTrigger(timeInterval: max(5, timeInterval), repeats: false)
    
    let initialIdentifier = UUID().uuidString
    let initialRequest = UNNotificationRequest(identifier: initialIdentifier, content: content, trigger: initialTrigger)
    
    notificationIdentifiers.append(initialIdentifier)
    UNUserNotificationCenter.current().add(initialRequest) { error in
        if let error = error {
            print("Error scheduling initial notification: \(error.localizedDescription)")
        } else {
            print("Initial notification scheduled for \(newDate)")
        }
    }

    task.notificationIdentifiers = notificationIdentifiers

    var checkTaskCompletionTimer: Timer?
    checkTaskCompletionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
        if task.isCompleted {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
            timer.invalidate()
            print("Task complete, notifications for this task canceled.")
        } else {
            print("Task not completed, notifications will continue.")
        }
    }
}


// Richiedo permessi
func requestNotificationPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Error requesting notification authorization: \(error.localizedDescription)")
        } else if granted {
            print("Notification permissions granted.")
        } else {
            print("Notification permissions denied.")
        }
    }
}


func scheduleNotification(title: String, for task: Task, at date: Date) {
    requestNotificationPermissions()
    
    // Se il task non è una medicina, passa alla funzione dedicata agli appuntamenti
    if !task.isMedicine {
        scheduleNotificationAppointment(title: title, for: task, at: date)
        return
    }

    // Creazione del contenuto della notifica
    let content = UNMutableNotificationContent()
    content.title = title.capitalized
    content.subtitle = "Remember to take your medicine!"
    content.sound = UNNotificationSound.default

    var notificationIdentifiers: [String] = []

    // Calcola l'intervallo di tempo tra l'attuale e la data specificata
    let timeInterval = max(5, date.timeIntervalSinceNow)
    let initialTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    let initialIdentifier = UUID().uuidString
    let initialRequest = UNNotificationRequest(identifier: initialIdentifier, content: content, trigger: initialTrigger)
    
    notificationIdentifiers.append(initialIdentifier)

    // Prima richiesta
    UNUserNotificationCenter.current().add(initialRequest) { error in
        if let error = error {
            print("Error scheduling initial notification: \(error.localizedDescription)")
        } else {
            print("Initial notification scheduled for \(date)")
        }
    }

    
    let checkInterval: TimeInterval = max(0, date.timeIntervalSinceNow) // Inizio il controllo della task  dopo l'orario di programmazione
    
    DispatchQueue.main.asyncAfter(deadline: .now() + checkInterval) {
        // Vedo se è stata inviata un'altra notifica
        var additionalNotificationSent = false

        //timer per verificare se il task è stato completato
        var checkTaskCompletionTimer: Timer?
        checkTaskCompletionTimer = Timer.scheduledTimer(withTimeInterval: 7*60, repeats: true) { timer in
            if task.isCompleted { // Se il task è completato, rimuove tutte le notifiche e ferma il timer
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
                timer.invalidate()
                print("Task complete, notifications for this task canceled.")
            } else if !additionalNotificationSent { // Se il task non è completato e non abbiamo già inviato una notifica aggiuntiva
                additionalNotificationSent = true
                print("Task not completed, sending additional notification.")

                // notifica aggiuntiva
                let additionalContent = UNMutableNotificationContent()
                additionalContent.title = title.capitalized
                additionalContent.subtitle = "Don't forget to take your medicine!"
                additionalContent.sound = UNNotificationSound.default
                
                let additionalIdentifier = UUID().uuidString
                let additionalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // 5 minuti
                let additionalRequest = UNNotificationRequest(identifier: additionalIdentifier, content: additionalContent, trigger: additionalTrigger)
                
                notificationIdentifiers.append(additionalIdentifier)
                
                UNUserNotificationCenter.current().add(additionalRequest) { error in
                    if let error = error {
                        print("Error scheduling additional notification: \(error.localizedDescription)")
                    } else {
                        print("Additional notification scheduled.")
                    }
                }
            }
        }
    }
}


//
//func requestNotificationPermissions() {
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//        if let error = error {
//            print("Error requesting notification authorization: \(error.localizedDescription)")
//        } else if granted {
//            print("Notification permissions granted.")
//        } else {
//            print("Notification permissions denied.")
//        }
//    }
//}
//
//func scheduleNotification(title: String, for task: Task, at date: Date) {
//    requestNotificationPermissions()
//
//    if !task.isMedicine
//    {
//        scheduleNotificationAppointment(title: title, for: task, at: date)
//        return
//    }
//    let content = UNMutableNotificationContent()
//    content.title = title.capitalized
//    content.subtitle = "Remember to take your medicine!"
//    content.sound = UNNotificationSound.default
//
//    var notificationIdentifiers: [String] = []
//
//    let timeInterval = max(5, date.timeIntervalSinceNow)
//    let initialTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//    let initialIdentifier = UUID().uuidString
//    let initialRequest = UNNotificationRequest(identifier: initialIdentifier, content: content, trigger: initialTrigger)
//
//    notificationIdentifiers.append(initialIdentifier)
//
//    UNUserNotificationCenter.current().add(initialRequest) { error in
//        if let error = error {
//            print("Error scheduling initial notification: \(error.localizedDescription)")
//        } else {
//            print("Initial notification scheduled for \(date)")
//        }
//    }
//
//    for i in 1...3 {
//        let repeatTimeInterval = timeInterval + Double(i * 10)
//        let repeatTrigger = UNTimeIntervalNotificationTrigger(timeInterval: repeatTimeInterval, repeats: false)
//        let repeatIdentifier = UUID().uuidString
//        let repeatRequest = UNNotificationRequest(identifier: repeatIdentifier, content: content, trigger: repeatTrigger)
//
//        notificationIdentifiers.append(repeatIdentifier)
//
//        UNUserNotificationCenter.current().add(repeatRequest) { error in
//            if let error = error {
//                print("Error scheduling repeated notification \(i): \(error.localizedDescription)")
//            } else {
//                print("Repeated notification \(i) scheduled.")
//            }
//        }
//    }
//
//    task.notificationIdentifiers = notificationIdentifiers
//
//    var checkTaskCompletionTimer: Timer?
//    checkTaskCompletionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//        if task.isCompleted {
//            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
//            timer.invalidate()
//            print("Task complete, notifications for this task canceled.")
//        } else {
//            print("Task not completed, notifications will continue.")
//        }
//    }
//}
