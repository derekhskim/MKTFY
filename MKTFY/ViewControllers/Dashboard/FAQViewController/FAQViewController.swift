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
        
        setupNavigationBarWithBackButton()
        
        // TODO: Re-implement this view as UITableView and show data as per endpoint
        getFAQ()
        
        configureVCPath()
    }
    
    // MARK: - Function
    func configureVCPath() {
        let faqViews = [FAQ1View, FAQ2View, FAQ3View, FAQ4View, FAQ5View]
        let actions: [() -> Void] = [
            { [weak self] in self?.coordinator?.goToFAQ1VC() },
            { [weak self] in self?.coordinator?.goToFAQ2VC() },
            { [weak self] in self?.coordinator?.goToFAQ3VC() },
            { [weak self] in self?.coordinator?.goToFAQ4VC() },
            { [weak self] in self?.coordinator?.goToFAQ5VC() }
        ]
        
        for (index, faqView) in faqViews.enumerated() {
            configureTapGesture(for: faqView!, onTap: actions[index])
        }
    }
    
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
    
    func getFAQ(){
        let getFAQEndpoint = GetFAQEndpoint()
        NetworkManager.shared.request(endpoint: getFAQEndpoint) { (result: Result<FAQResponses, Error>) in
            switch result {
            case .success(let response):
                for faqResponse in response {
                    print("FAQ Successfully received - id: \(faqResponse.id), question: \(faqResponse.question)")
                }
            case .failure(let error):
                print("Failde to get FAQ data: \(error.localizedDescription)")
            }
            
        }
    }
}
