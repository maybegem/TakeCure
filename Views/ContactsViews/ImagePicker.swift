import Foundation
import SwiftUI

struct ImagePicker: View {
    @Environment(\.dismiss) var dismiss
    let imageOptions: [String]
    @Binding var selectedImage: String?
    var onReset: (() -> Void)?
    
    var body: some View {
        NavigationView{
            VStack {
                
                Text("Select an image")
                    .font(.headline)
                    .padding()
                
                ScrollView(.horizontal) {
                    
                    HStack {
                        ForEach(imageOptions, id: \.self) { image in
                            Button(action: {
                                selectedImage = image
                                dismiss()
                            }) {
                                Image(image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                            }
                        }
                    }
                }
                .padding()
                
                Button(action: {selectedImage = nil
                    onReset?()
                    dismiss()
                }) {
                    Image(systemName: "person.slash.fill")
                        .font(.system(size: 80))
                }
                .padding()
            }
        }
        
        Button("Cancel") {
            dismiss()
        }.padding(.bottom, 20)
    }
       
}

