import SwiftUI

struct GGradient: View , ShapeStyle{
    var startColor: Color
    var endColor: Color
    var startPoint: UnitPoint
    var endPoint: UnitPoint
    
    
    
    init(startColor: Color, endColor: Color, startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.startColor = startColor
        self.endColor = endColor
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    init(lightBlue: Bool, startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .center) {
        
        if lightBlue {
            self.startColor = .white
            self.endColor = Color(red: 168/255, green: 239/255, blue: 255/255)
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
        
        else{
            self.startColor = .white
            self.endColor = Color(red: 255/255, green: 255/255, blue: 255/255)
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
    }
    
    init(green: Bool, startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        if green{
            self.startColor = Color.green.opacity(0.2)
            self.endColor = Color.green.opacity(0.8)
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
        else{
            self.startColor = .white
            self.endColor = Color(red: 255/255, green: 255/255, blue: 255/255)
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [startColor, endColor]),
            startPoint: startPoint,
            endPoint: endPoint
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    GGradient(green: false)
}
