//
//  FAQSpecificViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-14.
//

import UIKit

class FAQSpecificViewController: MainViewController, DashboardStoryboard {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewBackground(view: backgroundView, talbeView: tableView)
        
        
    }
}
