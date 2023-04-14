//
//  FAQViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-18.
//

import UIKit

class FAQViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    var faqResponses: [FAQResponse] = []
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupTableViewBackground()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQTableViewCell")
        
        getFAQ()
    }
    
    // MARK: - Function
    func setupTableViewBackground() {
        backgroundView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func getFAQ(){
        let getFAQEndpoint = GetFAQEndpoint()
        NetworkManager.shared.request(endpoint: getFAQEndpoint) { (result: Result<FAQResponses, Error>) in
            switch result {
            case .success(let response):
                for faqResponse in response {
                    self.faqResponses.append(faqResponse)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("FAQ Successfully received - id: \(faqResponse.id), question: \(faqResponse.question)")
                }
            case .failure(let error):
                print("Failde to get FAQ data: \(error.localizedDescription)")
            }
            
        }
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Fix Spacing
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        
        let faqResponse = faqResponses[indexPath.row]
        
        // TODO: DropShadow is only affecting corners ATM
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 2
        
        cell.faqQuestionLabel.text = faqResponse.question
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
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
