//
//  DashboardViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/21.
//

import UIKit

class DashboardViewController: MainViewController, DashboardStoryboard, UISearchBarDelegate {
    
    weak var coordinator: MainCoordinator?
    
    var customDropDownView: UIView?
    var dropDownView: UIView!
    
    let vm = FlowLayoutViewModel()
    let leftPadding: CGFloat = 8
    let rightPadding: CGFloat = 8
    let width = UIScreen.main.bounds.width
    let height: CGFloat = 270
    
    // MARK: - @IBOutlet
    @IBOutlet weak var navigationWhiteBackgroundView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var imgViewForDropDown: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var horizontalView: UIView!
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cstTopCollectionView: NSLayoutConstraint!
    
    // MARK: - @IBAction
    
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        
        navigationWhiteBackgroundView.layer.cornerRadius = 10
        navigationWhiteBackgroundView.clipsToBounds = true
        
        menuButton()
        floatingButton()
        initializeImageDropDown()
        
        horizontalDropShadow()
        horizontalScrollView.bounces = false
        horizontalScrollView.showsHorizontalScrollIndicator = false
        
        searchTextField.borderStyle = .none
        searchTextField.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        
        let layout = LPCollectionViewLayout()
        layout.delegate = self
        layout.headerReferenceSize = CGSize(width: width, height: 44)
        collectionView.collectionViewLayout = layout
        
        let tapOutsideDropDown = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        view.addGestureRecognizer(tapOutsideDropDown)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - func
    func horizontalDropShadow() {
        horizontalView.backgroundColor = .clear
        
        let topShadow = CAGradientLayer()
        topShadow.frame = CGRect(x: 0, y: 0, width: horizontalView.bounds.width, height: 2)
        topShadow.colors = [UIColor.black.withAlphaComponent(0.25).cgColor, UIColor.clear.cgColor]
        topShadow.startPoint = CGPoint(x: 0.5, y: 1.0)
        topShadow.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        let bottomShadow = CAGradientLayer()
        bottomShadow.frame = CGRect(x: 0, y: horizontalView.bounds.height - 5, width: horizontalView.bounds.width, height: 5)
        bottomShadow.colors = [UIColor.black.withAlphaComponent(0.25).cgColor, UIColor.clear.cgColor]
        bottomShadow.startPoint = CGPoint(x: 0.5, y: 0.0)
        bottomShadow.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        horizontalView.layer.addSublayer(topShadow)
        horizontalView.layer.addSublayer(bottomShadow)
    }
    
    func initializeImageDropDown() {
        imgViewForDropDown.frame = CGRect(x: 0, y: 0, width: 30, height: 48)
        imgViewForDropDown.image = UIImage(named: "drop_down_arrow")
        imgViewForDropDown.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCustomDropDownView))
        imgViewForDropDown.addGestureRecognizer(tapGesture)
        
        imgViewForDropDown.contentMode = .right
    }
    
    @objc func showCustomDropDownView() {
        if let dropDownView = customDropDownView {
            dropDownView.removeFromSuperview()
            customDropDownView = nil
        } else {
            dropDownView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            dropDownView.backgroundColor = .white
            dropDownView.layer.shadowColor = UIColor.black.cgColor
            dropDownView.layer.shadowOpacity = 0.5
            dropDownView.layer.shadowOffset = CGSize(width: 0, height: 1)
            dropDownView.layer.shadowRadius = 5
            dropDownView.clipsToBounds = false
            
            let triangleView = UIImageView()
            triangleView.image = UIImage(named: "white_triangle")
            triangleView.translatesAutoresizingMaskIntoConstraints = false
            dropDownView.addSubview(triangleView)
            
            let options = ["Calgary", "Camrose", "Brooks"]
            
            for (index, option) in options.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(option, for: .normal)
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                button.setTitleColor(.black, for: .normal)
                button.setTitleColor(UIColor.appColor(LPColor.OccasionalPurple), for: .highlighted)
                button.addTarget(self, action: #selector(dropDownOptionSelected(_:)), for: .touchUpInside)
                button.frame = CGRect(x: 0, y: 44 + CGFloat(index) * 50, width: 200, height: 50)
                button.backgroundColor = .white
                button.setBackgroundImage(UIImage(color: UIColor.appColor(LPColor.VerySubtleGray), alpha: 0.25), for: .highlighted)
                dropDownView.addSubview(button)
            }
            
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.placeholder = "Search City"
            searchBar.delegate = self
            searchBar.searchTextField.backgroundColor = .clear
            searchBar.searchTextField.layer.borderWidth = 1
            searchBar.searchTextField.layer.borderColor = UIColor.appColor(LPColor.SubtleGray).cgColor
            
            searchBar.backgroundImage = UIImage()
            
            dropDownView.addSubview(searchBar)
            
            NSLayoutConstraint.activate([
                triangleView.bottomAnchor.constraint(equalTo: dropDownView.topAnchor, constant: 0),
                triangleView.trailingAnchor.constraint(equalTo: dropDownView.trailingAnchor, constant: -3.5),
                triangleView.heightAnchor.constraint(equalToConstant: 11),
                triangleView.widthAnchor.constraint(equalToConstant: 24.5),
                
                searchBar.topAnchor.constraint(equalTo: dropDownView.topAnchor, constant: 10),
                searchBar.leadingAnchor.constraint(equalTo: dropDownView.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: dropDownView.trailingAnchor),
                searchBar.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            let rect = imgViewForDropDown.convert(imgViewForDropDown.bounds, to: view)
            let xOffset = (imgViewForDropDown.frame.width - triangleView.frame.width)
            dropDownView.frame.origin = CGPoint(x: rect.maxX - dropDownView.frame.width + xOffset, y: rect.maxY + imgViewForDropDown.frame.height / 2)
            view.addSubview(dropDownView)
            customDropDownView = dropDownView
        }
    }
    
    @objc func dropDownOptionSelected(_ sender: UIButton) {
        if let option = sender.title(for: .normal) {
            if let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderCollectionReusableView {
                headerView.cityLabel.text = option
            }
            cityLabel.text = option
        }
        sender.superview?.removeFromSuperview()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let options = ["Calgary", "Camrose", "Brooks"]
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
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let pointInCustomDropDownView = sender.location(in: customDropDownView)
        let pointInSearchTextField = sender.location(in: searchTextField)
        
        if searchTextField.bounds.contains(pointInSearchTextField) == false {
            view.endEditing(true)
        }
        
        if let customDropDownView = customDropDownView, let convertedCustomDropDownViewFrame = customDropDownView.superview?.convert(customDropDownView.frame, to: view) {
            if !convertedCustomDropDownViewFrame.contains(sender.location(in: view)) {
                customDropDownView.removeFromSuperview()
                self.customDropDownView = nil
            }
        }
    }
    
    func floatingButton() {
        let floatingButton = FloatingButton(action: #selector(floatingButtonTapped), target: self)
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 165),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func floatingButtonTapped() {
        coordinator?.presentCreateListingVC()
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Extension
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        
        let item = vm.items[indexPath.row]
        cell.updateData(data: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(indexPath)")
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
}

extension DashboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}

extension DashboardViewController {
    func menuButton() {
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(menuButtonTapped))
        menuImageView.addGestureRecognizer(menuTapped)
        menuImageView.isUserInteractionEnabled = true
    }
    
    @objc func menuButtonTapped() {
        coordinator?.goToDashboardMenuVC()
    }
    
    @objc func searchButtonTapped() {
        
    }
}

extension DashboardViewController: LPCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, cellWidth: CGFloat, heightForAtIndexPath: IndexPath) -> CGFloat {
        
        let height = vm.items[heightForAtIndexPath.row].height(cellWidth: cellWidth)
        return height
        
    }
}
