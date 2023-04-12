//
//  ConditionTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class ConditionTableViewCell: UITableViewCell {
    
    let conditionLabel = UILabel()
    let containerView = UIView()
    let shadowLayer = CAGradientLayer()
    var listingResponse: ListingResponse?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConditionLabel()
        setupView()
        configureSeparatorShadow()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConditionLabel() {
        let backgroundView = UIView()
        
        contentView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        
        backgroundView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            containerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 19),
            containerView.widthAnchor.constraint(equalToConstant: 43)
        ])
        
        containerView.addSubview(conditionLabel)
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            conditionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            conditionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        conditionLabel.numberOfLines = 1
        conditionLabel.font = UIFont(name: "OpenSans-SemiBold", size: 14)
    }
    
    func setupView() {
        guard let condition = listingResponse?.condition.lowercased() else { return }
        
        if condition == "new" {
            containerView.backgroundColor = UIColor.appColor(LPColor.GoodGreen).withAlphaComponent(0.2)
            conditionLabel.textColor = UIColor.appColor(LPColor.GoodGreen)
        } else if condition == "used" {
            containerView.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple).withAlphaComponent(0.2)
            conditionLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
        } else {
            containerView.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple).withAlphaComponent(0.2)
            conditionLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
        }
    }
    
    func configureSeparatorShadow() {
        contentView.layer.insertSublayer(shadowLayer, at: 0)
        shadowLayer.colors = [UIColor.black.withAlphaComponent(0.1).cgColor, UIColor.clear.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowHeight: CGFloat = 3
        shadowLayer.frame = CGRect(x: 0, y: contentView.bounds.height - shadowHeight, width: contentView.bounds.width, height: shadowHeight)
    }
}
