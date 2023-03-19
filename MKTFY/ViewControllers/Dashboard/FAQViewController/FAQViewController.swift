//
//  FAQViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-18.
//

import UIKit

class FAQViewController: MainViewController, DashboardStoryboard {

    weak var coordinator: MainCoordinator?
    private var tapGestures: [() -> Void] = []

    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var FAQ1View: UIView!
    @IBOutlet weak var FAQ2View: UIView!
    @IBOutlet weak var FAQ3View: UIView!
    @IBOutlet weak var FAQ4View: UIView!
    @IBOutlet weak var FAQ5View: UIView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture(for: FAQ1View) { [weak self] in
            self?.coordinator?.goToFAQ1VC()
        }
        
        configureTapGesture(for: FAQ2View) { [weak self] in
            self?.coordinator?.goToFAQ2VC()
        }
        
        configureTapGesture(for: FAQ3View) { [weak self] in
            self?.coordinator?.goToFAQ3VC()
        }
        
        configureTapGesture(for: FAQ4View) { [weak self] in
            self?.coordinator?.goToFAQ4VC()
        }
        
        configureTapGesture(for: FAQ5View) { [weak self] in
            self?.coordinator?.goToFAQ5VC()
        }
        

    }
    
    // MARK: - func
    func configureTapGesture(for view: UIView, onTap: @escaping () -> Void) {
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.tag = tapGestures.count
        tapGestures.append(onTap)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            let index = view.tag
            if index < tapGestures.count {
                tapGestures[index]()
            }
        }
    }
}
