//
//  MyPurchasesViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyPurchasesViewController: MainViewController, DashboardStoryboard {
    
    var myPurchases: [Purchases] = [
        Purchases(image: UIImage(named: "pearl_the_christmas")!, date: "September 7, 2020", title: "Pearl the Cat: Christmas Edition", price: "$340.00"),
        Purchases(image: UIImage(named: "pearl_the_halloween")!, date: "September 7, 2020", title: "Pearl the Cat: Halloween Edition", price: "$340.00")
    ]
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListingViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ListingViewTableViewCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0)
        ])
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        setupTableViewBackground()
    }
    
    func setupTableViewBackground() {
        backgroundView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundView.clipsToBounds = true
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}

extension MyPurchasesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPurchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingViewTableViewCell", for: indexPath) as! ListingViewTableViewCell
        
        let purchases = myPurchases[indexPath.row]
        
        cell.titleLabel.text = purchases.title
        cell.dateLabel.text = purchases.date
        cell.priceLabel.text = purchases.price
        cell.itemImageView.image = purchases.image
        
        return cell
    }
}

extension MyPurchasesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
}
