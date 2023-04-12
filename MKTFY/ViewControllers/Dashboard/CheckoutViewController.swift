//
//  CheckoutViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class CheckoutViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    var listingResponse: ListingResponse?
    
    // MARK: - @IBOutlet
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CheckoutTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CheckoutTableViewCell")
    }
    
}

// MARK: - Extension
extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
        
        if let listingResponse = listingResponse {
            cell.productNameLabel.text = listingResponse.productName
            cell.priceLabel.text = String(format: "$%.2f", listingResponse.price)
            
            if let firstImageURL = listingResponse.images.first {
                cell.imageHoldingView.loadImage(from: URL(string: firstImageURL))
            }
        }
        
        cell.configureSeparatorShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear

        let footerButton = Button()
        footerButton.setTitle("Confirm", for: .normal)
        footerButton.titleLabel!.font = UIFont(name: "OpenSans-bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        footerButton.setTitleColor(UIColor.appColor(LPColor.VoidWhite), for: .normal)
        footerButton.layer.cornerRadius = 20
        footerButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        footerButton.translatesAutoresizingMaskIntoConstraints = false
        footerButton.addTarget(self, action: #selector(footerButtonTapped), for: .touchUpInside)

        footerView.addSubview(footerButton)

        NSLayoutConstraint.activate([
            footerButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -27),
            footerButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 15),
            footerButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -15),
            footerButton.heightAnchor.constraint(equalToConstant: 51)
        ])

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let totalContentHeight = tableView.contentSize.height
        let availableSpace = max(tableView.frame.height - totalContentHeight - 90, 0)
        
        return availableSpace
    }
    
    @objc func footerButtonTapped() {
        print("Ouch")
        
        let purchaseListingEndpoint = PurchaseListingEndpoint(id: listingResponse?.id)
        NetworkManager.shared.request(endpoint: purchaseListingEndpoint) { (result: Result<ListingResponse, Error>) in
            switch result {
            case .success(let listingResponse):
                print("Checkout success: \(listingResponse)")
            case .failure(let error):
                print("Error, checkout failed: \(error.localizedDescription)")
            }
            
        }
        
    }
}
