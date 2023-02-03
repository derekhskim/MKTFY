//
//  LoadingConfirmationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit

class LoadingConfirmationViewcontroller: UIViewController {
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        
        imageView.image = UIImage.animatedGif(named: "confirmation_check")
        viewWillDisappear(true)
                
        imageView?.animationRepeatCount = 1
        imageView?.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            let forgotPasswordVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVerificationViewController")
            self.show(forgotPasswordVerificationViewController!, sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
