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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarWithBackButton()
        getListingByID()
        // Do any additional setup after loading the view.
    }
    
    func getListingByID() {
        
        let getListingByIDEndpoint = GetListingByIDEndpoint(id: listingId)
        NetworkManager.shared.request(endpoint: getListingByIDEndpoint) { (result: Result<ListingResponse, Error>) in
            switch result {
            case .success(let listingResponse):
                print("response: \(listingResponse)")
            case .failure(let error):
                print("Unable to get listing by ID: \(error.localizedDescription)")
            }
        }
    }
}
