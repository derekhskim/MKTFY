//
//  MyPurchasesViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyPurchasesViewController: MainViewController, DashboardStoryboard {
        
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListingViewTableViewCell.self, forCellReuseIdentifier: "ListingViewTableViewCell")
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
    }
}

extension MyPurchasesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingViewTableViewCell", for: indexPath) as! ListingViewTableViewCell
        
        let image = UIImage(named: "pearl_the_christmas")
        let date = "September 7, 2020"
        let title = "Pearl the Cat: Christmas Edition"
        let price = "$340.00"
        
        cell.configureCell(image: image ?? UIImage(), date: date, title: title, price: price)
        
        return cell
    }
}

extension MyPurchasesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
