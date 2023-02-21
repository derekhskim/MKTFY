//
//  LoadingConfirmationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit

class LoadingConfirmationViewcontroller: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// MARK: - Confirmation Check Animation Lottie GIF file
        imageView.image = UIImage.animatedGif(named: "confirmation_check")
                
//        imageView?.animationRepeatCount = 1
//        imageView?.startAnimating()
//        
//        /// MARK: - Automatically transitions to the next view after 2.2 seconds, which is the time when animation completes
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
//            let forgotPasswordVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVerificationViewController")
//            self.show(forgotPasswordVerificationViewController!, sender: nil)
        }
    }
    
    
//    /// MARK: - Controls whether if you want to hide or show the navigation bar
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
//}
