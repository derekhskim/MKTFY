//
//  DKCustomDropDown.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-06.
//

import UIKit

protocol CustomDropDownDelegate: AnyObject {
    func customDropDown(_ customDropDown: DKCustomDropDown, didSelectOption option: String)
}

class DKCustomDropDown: UIView {
    
    weak var delegate: CustomDropDownDelegate?
    weak var relatedTextField: UITextField?
    
    private(set) var dropDownView: UIView!
    
    var options: [String] = [] {
        didSet {
            setupButtons()
        }
    }
    
    var searchBarPlaceholder: String? {
        didSet {
            searchBar.placeholder = searchBarPlaceholder
        }
    }
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        searchBar.delegate = self
        
        dropDownView = UIView()
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dropDownView)
        
        NSLayoutConstraint.activate([
            dropDownView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            dropDownView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dropDownView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dropDownView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupButtons() {
        for (index, option) in options.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(UIColor.appColor(LPColor.OccasionalPurple), for: .highlighted)
            button.addTarget(self, action: #selector(dropDownOptionSelected(_:)), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: CGFloat(index) * 50, width: 200, height: 50)
            button.backgroundColor = .white
            button.setBackgroundImage(UIImage(color: UIColor.appColor(LPColor.VerySubtleGray), alpha: 0.25), for: .highlighted)
            dropDownView.addSubview(button)
        }
    }
    
    @objc func dropDownOptionSelected(_ sender: UIButton) {
        if let option = sender.title(for: .normal) {
            delegate?.customDropDown(self, didSelectOption: option)
        }
    }
}

extension DKCustomDropDown: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredOptions = searchText.isEmpty ? options : options.filter { $0.lowercased().contains(searchText.lowercased()) }
        
        for (index, button) in dropDownView.subviews.compactMap({ $0 as? UIButton }).enumerated() {
            if filteredOptions.indices.contains(index) {
                let option = filteredOptions[index]
                button.setTitle(option, for: .normal)
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }
}
