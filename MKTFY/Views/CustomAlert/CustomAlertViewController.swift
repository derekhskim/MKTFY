//
//  CustomAlertController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-15.
//

import UIKit

class CustomAlertViewController: UIViewController {
    init(title: String, description: String, purpleButtonTitle: String, whiteButtonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupCustomAlert(title: title, description: description, purpleButtonTitle: purpleButtonTitle, whiteButtonTitle: whiteButtonTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomAlert(title: String, description: String, purpleButtonTitle: String, whiteButtonTitle: String) {
        let customView = UIView()
        customView.layer.cornerRadius = 24
        customView.backgroundColor = UIColor.white
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "OpenSans-Bold", size: 16)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let purpleButton = UIButton(type: .system)
        purpleButton.setTitle(purpleButtonTitle, for: .normal)
        purpleButton.setTitleColor(UIColor.white, for: .normal)
        purpleButton.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
        purpleButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        purpleButton.layer.cornerRadius = 18
        purpleButton.translatesAutoresizingMaskIntoConstraints = false
        
        let whiteButton = UIButton(type: .system)
        whiteButton.setTitle(whiteButtonTitle, for: .normal)
        whiteButton.setTitleColor(UIColor.appColor(LPColor.GrayButtonGray), for: .normal)
        whiteButton.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 16)
        whiteButton.layer.borderWidth = 1
        whiteButton.layer.borderColor = UIColor.appColor(LPColor.GrayButtonGray).cgColor
        whiteButton.backgroundColor = UIColor.white
        whiteButton.layer.cornerRadius = 18
        whiteButton.translatesAutoresizingMaskIntoConstraints = false
        
        customView.addSubview(titleLabel)
        customView.addSubview(descriptionLabel)
        customView.addSubview(purpleButton)
        customView.addSubview(whiteButton)
        self.view.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            customView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            customView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            
            whiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            whiteButton.trailingAnchor.constraint(equalTo: purpleButton.leadingAnchor, constant: -10),
            whiteButton.heightAnchor.constraint(equalToConstant: 37),
            whiteButton.widthAnchor.constraint(equalToConstant: 120),
            
            purpleButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            purpleButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            purpleButton.heightAnchor.constraint(equalToConstant: 37),
            purpleButton.widthAnchor.constraint(equalToConstant: 120),
            
            customView.bottomAnchor.constraint(equalTo: whiteButton.bottomAnchor, constant: 20)
        ])
        
        purpleButton.addTarget(self, action: #selector(purpleButtonTapped), for: .touchUpInside)
        
        whiteButton.addTarget(self, action: #selector(whiteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func purpleButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func whiteButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
