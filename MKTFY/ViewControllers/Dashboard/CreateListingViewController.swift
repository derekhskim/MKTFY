//
//  CreateListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-15.
//

import PhotosUI
import UIKit

class CreateListingViewController: MainViewController, DashboardStoryboard {
    
    var chosenImages = [UIImage]()
    private var additionalUploadImageButton = UIButton()
    
    private let mainImageView = UIImageView()
    private let additionalImageView1 = UIImageView()
    private let additionalImageView2 = UIImageView()
    
    // MARK: - @IBOutlet
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    
    // MARK: - @IBAction
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        
        uploadButtonTapped()
        
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        imageStackView.backgroundColor = .red
        
    }
    
    @objc private func uploadButtonTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
}

extension CreateListingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    print(image)
                }
            }
        }
    }
}

//extension CreateListingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let image = info[.originalImage] as? UIImage, chosenImages.count < 3 {
//            chosenImages.append(image)
//            switch chosenImages.count {
//            case 1:
//                mainImageView.image = chosenImages[0]
//                mainImageView.contentMode = .scaleAspectFit
//                mainImageView.clipsToBounds = true
//            case 2:
//                additionalImageView1.image = image
//                additionalImageView1.contentMode = .scaleAspectFit
//                additionalImageView1.clipsToBounds = true
//                additionalImageView1.isHidden = false
//            case 3:
//                additionalImageView2.image = image
//                additionalImageView2.contentMode = .scaleAspectFit
//                additionalImageView2.clipsToBounds = true
//                additionalImageView2.isHidden = false
//            default:
//                break
//            }
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
