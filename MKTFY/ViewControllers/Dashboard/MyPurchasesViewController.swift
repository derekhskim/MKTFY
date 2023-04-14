//
//  MyPurchasesViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyPurchasesViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    var listingResponses: [ListingResponse] = []
    var listingResponse: ListingResponse?
    
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
            case .success(let listingResponses):
                print("User's listings retrieved: \(listingResponses)")
                print("listingResponse count: \(listingResponses.count)")
                self.listingResponses = listingResponses
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to retrieve user's purchases: \(error.localizedDescription)")
            }
        }
    }
    
}

extension MyPurchasesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Fix Spacing
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingViewTableViewCell", for: indexPath) as! ListingViewTableViewCell
        
        let listings = listingResponses[indexPath.row]
        
        // TODO: DropShadow is only affecting corners ATM
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedListingResponse = listingResponses[indexPath.row]
        let getListingByIDEndpoint = GetListingByIDEndpoint(id: selectedListingResponse.id)
        
        NetworkManager.shared.request(endpoint: getListingByIDEndpoint) { (result: Result<ListingResponse, Error>) in
            switch result {
            case .success(let listingResponse):
                print("ListingResponse by ID retrieved: \(listingResponse)")
                self.listingResponse = listingResponse
                
                DispatchQueue.main.async {
                    self.coordinator?.goToPickupInformationVC(listingResponse: listingResponse)
                }
            case .failure(let error):
                print("ListingResponse by ID Failed to Retrieve: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Something Happened!", message: "Unable to see details of your purchase. Please try again.", purpleButtonTitle: "OK", whiteButtonTitle: "Go Back", purpleButtonAction: {
                        self.dismiss(animated: true, completion: nil)
                    }, whiteButtonAction: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        
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
