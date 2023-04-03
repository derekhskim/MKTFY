//
//  CreateListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-15.
//

import UIKit

class CreateListingViewController: MainViewController, DashboardStoryboard {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var uploadImageButton: UploadImageButton!
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - @IBAction
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        
        if uploadImageButton.chosenImages.isEmpty {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.mediaTypes = ["public.image"]
            imagePickerController.modalPresentationStyle = .fullScreen
            
            present(imagePickerController, animated: true, completion: nil)
            
            print("Tapped")
        }
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
    }
}

extension CreateListingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, uploadImageButton.chosenImages.count <= 3 {
            uploadImageButton.chosenImages.append(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
