import SwiftUI

struct TaskCircleView: View {
    var task: Task

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 52)
                .foregroundStyle(
                    task.isMedicine ?
                    LinearGradient(colors: [.red, .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.purple,.gray.opacity(0.3),.red], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            Circle()
                .frame(width: 50)
                .foregroundColor(.white)
            task.isMedicine ? Text("💊") : Text("🏩")
        }
    }
}

#Preview {
    TaskCircleView(task: Task(appointment: "Esempio", date: Date()))
}
