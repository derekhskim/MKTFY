//
//  LoadingConfirmationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit

class LoadingConfirmationViewcontroller: UIViewController {
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var circularIndicator: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        circularIndicator?.animationRepeatCount = 1
        circularIndicator?.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + circularIndicator.animationDuration) {
            let forgotPasswordVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVerificationViewController")
            self.show(forgotPasswordVerificationViewController!, sender: nil)
        }
    }
}
