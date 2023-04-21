//
//  MyListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyListingViewController: MainViewController, DashboardStoryboard {
    
    // MARK: - Properties
    enum ListingState {
        case pendingAndActive
        case complete
    }
    
    var currentState: ListingState = .pendingAndActive
    weak var coordinator: MainCoordinator?
    var pendingListingResponses: [ListingResponse] = []
    var activeListingResponses: [ListingResponse] = []
    var completeListingResponses: [ListingResponse] = []
    var listingResponse: ListingResponse?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activeItemsButton: UIButton!
    @IBOutlet weak var soldItemsButton: UIButton!
    
    // MARK: - @IBAction
    @IBAction func activeItemsButtonTapped(_ sender: Any) {
        getUsersPendingAndActiveListings()
        activeItemsButton.tintColor = UIColor.appColor(LPColor.OccasionalPurple)
        soldItemsButton.tintColor = UIColor.appColor(LPColor.TextGray)
        activeItemsButton.isUserInteractionEnabled = false
        soldItemsButton.isUserInteractionEnabled = true
        currentState = .pendingAndActive
        tableView.reloadData()
    }
    
    @IBAction func soldItemsButtonTapped(_ sender: Any) {
        getUsersCompletedListings()
        activeItemsButton.tintColor = UIColor.appColor(LPColor.TextGray)
        soldItemsButton.tintColor = UIColor.appColor(LPColor.OccasionalPurple)
        activeItemsButton.isUserInteractionEnabled = true
        soldItemsButton.isUserInteractionEnabled = false
        currentState = .complete
        tableView.reloadData()
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        setupTableViewBackground(view: backgroundView, talbeView: tableView)
        
        getUsersPendingAndActiveListings()
        activeItemsButton.tintColor = UIColor.appColor(LPColor.OccasionalPurple)
        activeItemsButton.isUserInteractionEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListingViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ListingViewTableViewCell")
        
        floatingButton()
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
    
    func getUsersPendingAndActiveListings() {
        let getUsersListingsEndpoint = GetUsersListingsEndpoint()
        NetworkManager.shared.request(endpoint: getUsersListingsEndpoint) { (result: Result<[ListingResponse], Error>) in
            switch result {
            case .success(let listingResponse):
                self.pendingListingResponses = listingResponse.filter({ $0.status == "PENDING" })
                self.activeListingResponses = listingResponse.filter({ $0.status == "ACTIVE" })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to retrieve user's listings: \(error.localizedDescription)")
            }
        }
    }
    
    func getUsersCompletedListings() {
        let getUsersListingsEndpoint = GetUsersListingsEndpoint()
        NetworkManager.shared.request(endpoint: getUsersListingsEndpoint) { (result: Result<[ListingResponse], Error>) in
            switch result {
            case .success(let listingResponse):
                self.completeListingResponses = listingResponse.filter({ $0.status == "COMPLETE" })
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
        switch currentState {
        case .pendingAndActive:
            return 2
        case .complete:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case .pendingAndActive:
            if section == 0 {
                return pendingListingResponses.count
            } else {
                return activeListingResponses.count
            }
        case .complete:
            return completeListingResponses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Fix Spacing
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingViewTableViewCell", for: indexPath) as! ListingViewTableViewCell
        
        let listings: ListingResponse
        switch currentState {
        case .pendingAndActive:
            listings = indexPath.section == 0 ? pendingListingResponses[indexPath.row] : activeListingResponses[indexPath.row]
        case .complete:
            listings = completeListingResponses[indexPath.row]
        }
        
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
        let selectedListingResponse: ListingResponse
        switch currentState {
        case .pendingAndActive:
            selectedListingResponse = indexPath.section == 0 ? pendingListingResponses[indexPath.row] : activeListingResponses[indexPath.row]
        case .complete:
            selectedListingResponse = completeListingResponses[indexPath.row]
        }
        let getListingByIDEndpoint = GetListingByIDEndpoint(id: selectedListingResponse.id)
        
        NetworkManager.shared.request(endpoint: getListingByIDEndpoint) { (result: Result<ListingResponse, Error>) in
            switch result {
            case .success(let listingResponse):
                print("ListingResponse by ID retrieved: \(listingResponse)")
                self.listingResponse = listingResponse
                if listingResponse.status.lowercased() == "active" {
                    DispatchQueue.main.async {
                        print("This item's status is: \(listingResponse.status)")
                        self.coordinator?.goToActiveListingDetailsVC(listingResponse: listingResponse)
                    }
                } else if listingResponse.status.lowercased() == "pending" {
                    DispatchQueue.main.async {
                        print("This item's status is: \(listingResponse.status)")
                        self.coordinator?.goToPendingListingDetailsVC(listingResponse: listingResponse)
                    }
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
        if currentState == .pendingAndActive && section == 1 {
            let headerView = UIView()
            headerView.backgroundColor = .clear
            
            let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.size.width, height: 24))
            headerLabel.font = UIFont(name: "OpenSans-SemiBold", size: 14)
            headerLabel.textColor = UIColor.appColor(LPColor.TextGray)
            headerLabel.text = "AVAILABLE ITEMS"
            headerLabel.sizeToFit()
            
            headerView.addSubview(headerLabel)
            
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}
