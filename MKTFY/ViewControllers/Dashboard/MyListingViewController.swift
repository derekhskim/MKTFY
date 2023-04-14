//
//  MyListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyListingViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    var listingResponse: [ListingResponse] = []
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        setupTableViewBackground()
        
        getUsersListings()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListingViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ListingViewTableViewCell")
        
        floatingButton()
    }
    
    func setupTableViewBackground() {
        backgroundView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func floatingButton() {
        let floatingButton = DKFloatingButton(action: #selector(floatingButtonTapped), target: self)
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 165),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func floatingButtonTapped() {
        coordinator?.goToCreateListingVC()
    }
    
    func getUsersListings() {
        let getUsersListingsEndpoint = GetUsersListingsEndpoint()
        NetworkManager.shared.request(endpoint: getUsersListingsEndpoint) { (result: Result<[ListingResponse], Error>) in
            switch result {
            case .success(let listingResponse):
                print("User's listings retrieved: \(listingResponse)")
                print("listingResponse count: \(listingResponse.count)")
                self.listingResponse = listingResponse
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to retrieve user's listings: \(error.localizedDescription)")
            }
        }
    }
}

extension MyListingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListingViewTableViewCell", for: indexPath) as! ListingViewTableViewCell
            
            let listings = listingResponse[indexPath.row]
            
            cell.cellView.layer.cornerRadius = 20
            cell.cellView.layer.masksToBounds = false
            cell.cellView.layer.shadowColor = UIColor.black.cgColor
            cell.cellView.layer.shadowOffset = CGSize.zero
            cell.cellView.layer.shadowOpacity = 0.3
            cell.cellView.layer.shadowRadius = 2
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let dateObject = dateFormatter.date(from: listings.created) {
                dateFormatter.dateFormat = "MMMM d, yyyy"
                let formattedDate = dateFormatter.string(from: dateObject)
                cell.dateLabel.text = formattedDate
            }
            
            cell.titleLabel.text = listings.productName
            cell.priceLabel.text = String(format: "$%.2f", listings.price)
            
            cell.itemImageView.loadImage(from: URL(string: listings.images.first ?? "")) { [weak cell] in
                guard let cell = cell else { return }
                cell.itemImageView.image = cell.itemImageView.image ?? UIImage(named: "no-image")
            }
            
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
