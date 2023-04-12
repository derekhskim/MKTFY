//
//  ButtonTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    let customView = UIView()
    let customButton = Button()
    
    weak var coordinator: MainCoordinator?
    var listingResponse: ListingResponse?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCustomView()
        configureCustomButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomView() {
        contentView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customView.heightAnchor.constraint(equalToConstant: 91)
        ])
        
        customView.backgroundColor = UIColor.appColor(LPColor.SubtleGray)
    }
    
    func configureCustomButton() {
        customView.addSubview(customButton)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customButton.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 12),
            customButton.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20),
            customButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -12),
            customButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -20),
            customButton.heightAnchor.constraint(equalToConstant: 51)
        ])
        
        customButton.setTitle("I want this!", for: .normal)
        customButton.titleLabel!.font = UIFont(name: "OpenSans-bold", size: 16) ?? UIFont()
        customButton.setTitleColor(UIColor.appColor(LPColor.VoidWhite), for: .normal)
        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        customButton.cornerRadius = 20
        customButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
    }
    
    @objc func customButtonTapped() {
        if let listingResponse = listingResponse {
            coordinator?.goToCheckoutVC(listingResponse: listingResponse)
        }
    }
    
}

