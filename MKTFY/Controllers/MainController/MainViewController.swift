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

class MainViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    weak var selectionDelegate: DropDownSelectionDelegate?
    var customDropDownView: DKCustomDropDown?
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
    
    func setupCustomDropDownWithStackView(with uiView: UIView) {
        if let stackView = uiView.superview as? UIStackView {
            let rect = stackView.convert(uiView.bounds, to: view)
            customDropDownView = DKCustomDropDown(frame: CGRect(x: rect.maxX - 200, y: rect.maxY, width: 200, height: 300))
            customDropDownView?.options = ["Calgary", "Camrose", "Brooks"]
            customDropDownView?.searchBarPlaceholder = "Search options"
            customDropDownView?.delegate = self
            self.view.addSubview(customDropDownView!)
        }
    }
    
    @objc func showCustomDropDownViewForStackView(_ sender: UITapGestureRecognizer) {
        if let dropDownView = customDropDownView {
            hideCustomDropDownView()
        } else {
            if let uiView = sender.view {
                setupCustomDropDownWithStackView(with: uiView)
            }
        }
    }
    
    func hideCustomDropDownView() {
        customDropDownView?.removeFromSuperview()
        customDropDownView = nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appColor(LPColor.TextGray40) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your message"
            textView.textColor = UIColor.appColor(LPColor.TextGray40)
        }
    }
    
    func setupTableViewBackground(view: UIView, talbeView: UITableView) {
        view.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        talbeView.separatorStyle = .none
        talbeView.backgroundColor = .clear
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
    func customDropDown(_ customDropDown: DKCustomDropDown, didSelectOption option: String) {
        selectionDelegate?.setDropDownSelectedOption(option)
        hideCustomDropDownView()
    }
}
