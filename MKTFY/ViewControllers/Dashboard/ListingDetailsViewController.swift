//
//  ListingDetailsViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-17.
//

import UIKit

class ListingDetailsViewController: MainViewController, DashboardStoryboard {
    
    var listingResponse: ListingResponse?
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ImageCarouselTableViewCell.self, forCellReuseIdentifier: "ImageCarouselTableViewCell")
        tableView.register(CustomViewTableViewCell.self, forCellReuseIdentifier: "CustomViewTableViewCell")
        tableView.register(PriceTableViewCell.self, forCellReuseIdentifier: "PriceTableViewCell")
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonTableViewCell")
        tableView.register(DetailsLabelTableViewCell.self, forCellReuseIdentifier: "DetailsLabelTableViewCell")
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.register(ConditionTableViewCell.self, forCellReuseIdentifier: "ConditionTableViewCell")
        tableView.register(UINib(nibName: "SellerProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SellerProfileTableViewCell")
    }
    
}

// MARK: - Extension
extension ListingDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCarouselTableViewCell", for: indexPath) as! ImageCarouselTableViewCell
            cell.listingResponse = listingResponse
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewTableViewCell", for: indexPath) as! CustomViewTableViewCell
            cell.TextFieldView.title = "Product Name"
            cell.TextFieldView.inputTextField.placeholder = listingResponse?.productName
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceTableViewCell", for: indexPath) as! PriceTableViewCell
            cell.priceLabel.text = String(format: "$%.2f", listingResponse?.price ?? 0)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.coordinator = coordinator
            cell.listingResponse = listingResponse
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsLabelTableViewCell", for: indexPath) as! DetailsLabelTableViewCell
            cell.detailsLabel.text = "Details"
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            cell.descriptionLabel.text = listingResponse?.description
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionTableViewCell", for: indexPath) as! ConditionTableViewCell
            
            cell.listingResponse = listingResponse
            cell.conditionLabel.text = listingResponse?.condition.uppercased()
            cell.setupView()
            cell.configureSeparatorShadow()
            
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerProfileTableViewCell", for: indexPath) as! SellerProfileTableViewCell
            
            cell.listingResponse = listingResponse
            cell.changeNameAndPrefix()
            cell.configureSellerProfile()
            cell.configureProfileHoldingView()
            
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
