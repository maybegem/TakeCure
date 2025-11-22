import SwiftUI

struct ContentView: View {
    @State var selection: Int = 0
    @State var tasks: [Task] = []
    
    var body: some View {
        
            TabView(selection: $selection) {
                CalendarView(tasks: $tasks)
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(0)
                
                ContactView()
                    .multilineTextAlignment(.center)
                    .tabItem {
                        Label("Contacts", systemImage: "person")
                    }
                    .tag(1)
                AllTasksView(tasks: $tasks)
                    .multilineTextAlignment(.center)
                    .tabItem {
                        Label("All tasks", systemImage: "book")
                    }
                    .tag(2)
            }
            .onAppear {
                UITabBar.appearance().isTranslucent = true
            }
        
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
