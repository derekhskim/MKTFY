//
//  MainViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

protocol DropDownSelectionDelegate: AnyObject {
    func setDropDownSelectedOption(_ option: String)
}

class MainViewController: UIViewController {
    
    weak var selectionDelegate: DropDownSelectionDelegate?
    
    var customDropDownView: CustomDropDown?
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalFrame = view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    // MARK: - Function
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
    
    func setupCustomDropDown(with uiView: UIView) {
        let rect = uiView.convert(uiView.bounds, to: view)
        customDropDownView = CustomDropDown(frame: CGRect(x: rect.maxX - 200, y: rect.maxY, width: 200, height: 300))
        customDropDownView?.options = ["Calgary", "Camrose", "Brooks"]
        customDropDownView?.searchBarPlaceholder = "Search options"
        customDropDownView?.delegate = self
        self.view.addSubview(customDropDownView!)
    }
    
    func initializeImageDropDown(with textField: UITextField) {
        let imgViewForDropDown = UIImageView()
        imgViewForDropDown.frame = CGRect(x: 0, y: 0, width: 30, height: 48)
        imgViewForDropDown.image = UIImage(named: "drop_down_arrow")
        imgViewForDropDown.isUserInteractionEnabled = true
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imgViewForDropDown.frame.width + 10, height: imgViewForDropDown.frame.height))
        containerView.addSubview(imgViewForDropDown)
        
        textField.rightView = containerView
        textField.rightViewMode = .always
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCustomDropDownView(_:)))
        containerView.addGestureRecognizer(tapGesture)

        imgViewForDropDown.contentMode = .right
    }
    
    @objc func showCustomDropDownView(_ sender: UITapGestureRecognizer) {
        if let dropDownView = customDropDownView {
            hideCustomDropDownView()
        } else {
            if let textField = sender.view?.superview as? UITextField {
                setupCustomDropDown(with: textField)
            }
            
        }
    }
    
    func hideCustomDropDownView() {
        customDropDownView?.removeFromSuperview()
        customDropDownView = nil
    }
}

// MARK: - Extension
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

extension MainViewController: CustomDropDownDelegate {
    func customDropDown(_ customDropDown: CustomDropDown, didSelectOption option: String) {
        selectionDelegate?.setDropDownSelectedOption(option)
        hideCustomDropDownView()
    }
}
