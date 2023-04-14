//
//  MyPurchasesViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyPurchasesViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    var listingResponse: ListingResponse?
    
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
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        setupTableViewBackground()
        
        getUsersPurchases()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListingViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ListingViewTableViewCell")
        
    }
    
    func setupTableViewBackground() {
        backgroundView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func getUsersPurchases() {
        let getUsersPurchasesEndpoint = GetUsersPurchasesEndpoint()
        NetworkManager.shared.request(endpoint: getUsersPurchasesEndpoint) { (result: Result<[ListingResponse], Error>) in
            switch result {
            case .success(let listingResponse):
                print("User's purchases retrieved: \(listingResponse)")
            case .failure(let error):
                print("Failed to retrieve user's purchases: \(error.localizedDescription)")
            }
        }
    }
    
}

extension MyPurchasesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return myPurchases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
