//
//  CreatePasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/14.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
    }
}
