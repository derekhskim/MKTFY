//
//  CreateListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-15.
//

import UIKit

class CreateListingViewController: MainViewController, DashboardStoryboard {
    
    private var additionalUploadImageButton: UploadImageButton?
    
    private let additionalImageView1 = UIImageView()
    private let additionalImageView2 = UIImageView()
    
    // MARK: - @IBOutlet
    @IBOutlet weak var uploadImageButton: UploadImageButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageStackView: UIStackView!
    
    // MARK: - @IBAction
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        
        if uploadImageButton.chosenImages.isEmpty {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            imagePickerController.mediaTypes = ["public.image"]
            
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
    
    func configureAdditionalImageUploadButton(){
        if uploadImageButton.chosenImages.count == 1 {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            
            imageStackView.addArrangedSubview(horizontalStackView)
            horizontalStackView.addArrangedSubview(additionalUploadImageButton!)
            
            NSLayoutConstraint.activate([
                horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
                horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
                horizontalStackView.topAnchor.constraint(equalTo: uploadImageButton.mainImageView.bottomAnchor),
                
                additionalUploadImageButton!.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
                additionalUploadImageButton!.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
                additionalUploadImageButton!.heightAnchor.constraint(equalToConstant: 44),
                additionalUploadImageButton!.widthAnchor.constraint(equalToConstant: 44)
            ])
            
        }
    }
    
    @objc private func uploadButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
        
        present(imagePickerController, animated: true, completion: nil)
        
        print("Additional Upload Image Button Tapped")
    }
    
}

extension CreateListingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage, uploadImageButton.chosenImages.count < 3 {
                    uploadImageButton.chosenImages.append(image)
                    switch uploadImageButton.chosenImages.count {
                    case 2:
                        additionalImageView1.image = image
                        additionalImageView1.isHidden = false
                    case 3:
                        additionalImageView2.image = image
                        additionalImageView2.isHidden = false
                    default:
                        break
                    }
                }
                picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
