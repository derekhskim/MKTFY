//
//  CreateListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-15.
//

import UIKit

class CreateListingViewController: MainViewController, DashboardStoryboard, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var uploadImageButton: UploadImageButton!
    
    // MARK: - @IBAction
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
        if #available(iOS 14, *) {
            imagePickerController.modalPresentationStyle = .fullScreen
        }
        
        present(imagePickerController, animated: true, completion: nil)
        
        print("Tapped")
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage, uploadImageButton.chosenImages.count < 3 {
                uploadImageButton.chosenImages.append(image)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
