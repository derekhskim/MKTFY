//
//  MainViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class MainViewController: UIViewController {
    
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalFrame = view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        let getUserEndpoint = GetUserEndpoint(userId: userId)
        
        NetworkManager.shared.request(endpoint: getUserEndpoint, completion: completion, userDefaultsSaving: saveUserToUserDefaults)
    }
    
    func saveUserToUserDefaults(user: User) {
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.phone, forKey: "phone")
        UserDefaults.standard.set(user.address, forKey: "address")
        UserDefaults.standard.set(user.city, forKey: "city")
    }
}

// Extension to shift the view upward or downward when system keyboard appears
extension MainViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var newFrame = originalFrame
        newFrame.origin.y -= keyboardSize.height * shiftFactor
        view.frame = newFrame
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame = originalFrame
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
