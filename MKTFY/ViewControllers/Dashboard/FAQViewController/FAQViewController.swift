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
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture(for: FAQ1View) { [weak self] in
            self?.coordinator?.goToFAQ1VC()
        }

    }
    
    // MARK: - func
    func configureTapGesture(for view: UIView, onTap: @escaping () -> Void) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
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
