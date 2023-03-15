//
//  UIViewController+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import Foundation
import UIKit
import Auth0

// MARK: - Functionality
extension UIViewController {
    static func storyboardInstance(storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
    
    func getManagementAccessToken(completion: @escaping (String?) -> Void) {
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: plistPath),
              let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
              let url = plist["cloudflareUrl"] as? String else {
            fatalError("Could not read credentials from .plist file.")
        }
        
        guard let url = URL(string: "\(url)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle network error
                print("error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let token = String(data: data, encoding: .utf8) else {
                // Handle response data error
                completion(nil)
                return
            }
            
            completion(token)
        }
        
        task.resume()
    }
    
    // Will probably remove it once back-end setup is complete
    func getUserMetadata() async {
        if let accessToken = UserDefaults.standard.object(forKey: "authenticationAPI") as? String {
            print(accessToken)
            do {
                let user = try await Auth0.authentication().userInfo(withAccessToken: accessToken).start()
                print("User Info: \(user)")
            } catch {
                print("Failed with \(error)")
            }
        } else {
            print("No Access Token Found")
        }
    }
}

// MARK: - Navigation Bar Setup
extension UIViewController {
    func setupNavigationBarWithBackButton() {
        // Controls the back button's action and style
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.appColor(LPColor.LightestPurple)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // Determines where the back button should take the view controller to
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBarWithSaveButtonOnRight() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.GrayButtonGray) as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        saveButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.GrayButtonGray) as Any], for: .highlighted)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBarWithExitButtonOnRight() {
        let exitButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(exitButtonTapped))
        exitButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = exitButton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    @objc func exitButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupBackgroundView(view: UIView) {
        let backgroundView = view
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
    }
}

// MARK: - Show Alert
// TODO: Custom ShowAlert
extension UIViewController {
    func showAlert(title: String, message: String, purpleButtonTitle: String, whiteButtonTitle: String) {
        let customAlert = CustomAlertViewController(title: title, description: message, purpleButtonTitle: purpleButtonTitle, whiteButtonTitle: whiteButtonTitle)
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        self.present(customAlert, animated: true, completion: nil)
    }
}
