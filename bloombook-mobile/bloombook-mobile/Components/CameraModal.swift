import SwiftUI
import AVFoundation

struct CameraCaptureModal: View {
    @Binding var isShowingCamera: Bool
    @Binding var image: UIImage?
    
    var body: some View {
        CameraViewController(isShowingCamera: $isShowingCamera, image: $image)
            .ignoresSafeArea(.all)
    }
}

struct CameraViewController: UIViewControllerRepresentable {
    @Binding var isShowingCamera: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraViewController
        
        init(parent: CameraViewController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.isShowingCamera = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowingCamera = false
        }
    }
}
