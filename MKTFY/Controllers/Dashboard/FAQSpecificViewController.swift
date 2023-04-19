//
//  FAQSpecificViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-14.
//

import UIKit

class FAQSpecificViewController: MainViewController, DashboardStoryboard {
    
    var faqResponse: FAQResponse?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewBackground(view: backgroundView, talbeView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        tableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "AnswerTableViewCell")
        
        
        getSpecificFAQ()
    }
    
    func getSpecificFAQ() {
        let getSpecificFAQEndpoint = GetSpecificFAQEndpoint(id: faqResponse!.id)
        NetworkManager.shared.request(endpoint: getSpecificFAQEndpoint) { (result: Result<FAQResponse, Error>) in
            switch result {
            case .success(let faqResponse):
                self.faqResponse = faqResponse
            case .failure(let error):
                print("Failed to fetch FAQ Response: \(error.localizedDescription)")
            }
        }
    }
}

extension FAQSpecificViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
            
            cell.questionLabel.text = faqResponse?.question
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell", for: indexPath) as! AnswerTableViewCell
            
            let myString = faqResponse?.answer
            let escapedString = String(htmlEncodedString: myString!)
            let decodedString = String(htmlEncodedString: escapedString!)
            let stringWithNewlines = decodedString!.replacingOccurrences(of: "\n", with: "\n\n")
            cell.answerTextView.text = stringWithNewlines
            
            return cell
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
        return 2
    }
}
