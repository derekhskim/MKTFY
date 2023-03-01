//
//  LoadingConfirmationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit

class LoadingConfirmationViewcontroller: UIViewController, LoginStoryboard {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// MARK: - Confirmation Check Animation Lottie GIF file
        imageView.image = UIImage.animatedGif(named: "confirmation_check")
        
        navigationController?.setNavigationBarHidden(true, animated: true)

        }
    }
    
