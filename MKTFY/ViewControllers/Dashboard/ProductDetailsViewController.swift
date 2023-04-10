//
//  ProductDetailsViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-10.
//

import UIKit

class ProductDetailsViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    var listingId: String?
    var listingResponse: ListingResponse?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        getListingByID()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageCarouselTableViewCell.self, forCellReuseIdentifier: "ImageCarouselTableViewCell")
    }
    
    func getListingByID() {
        let getListingByIDEndpoint = GetListingByIDEndpoint(id: listingId)
        NetworkManager.shared.request(endpoint: getListingByIDEndpoint) { (result: Result<ListingResponse, Error>) in
            switch result {
            case .success(let listing):
                self.listingResponse = listing
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("response: \(listing)")
            case .failure(let error):
                print("Unable to get listing by ID: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Extension
extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCarouselTableViewCell", for: indexPath) as! ImageCarouselTableViewCell
            cell.listingResponse = listingResponse
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 415
        default:
            return UITableView.automaticDimension
        }
    }
    
}
