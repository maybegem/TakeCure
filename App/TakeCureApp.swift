import SwiftUI
import UserNotifications

@main //Punto d'ingresso
struct TakeCure: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate 
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
