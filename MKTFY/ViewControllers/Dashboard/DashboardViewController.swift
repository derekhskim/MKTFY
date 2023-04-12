//
//  DashboardViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/21.
//

import UIKit

class DashboardViewController: MainViewController, DashboardStoryboard, UISearchBarDelegate {
    
    weak var coordinator: MainCoordinator?
    
    var vm = FlowLayoutViewModel(items: [])
    
    // TODO: either add actions to UIStackView or embed in UIView and add actions to allow selection for category. Call GetListingByCategory when pressed and pass category and city value
    
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
        
        getUsers()
        
        // TODO: Need to change this to getListingByCategory and default to Deals?
        getAllListing()
        
        navigationWhiteBackgroundView.layer.cornerRadius = 10
        navigationWhiteBackgroundView.clipsToBounds = true
        
        menuButton()
        floatingButton()
        
        selectionDelegate = self
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(dropdownTapped))
        imgViewForDropDown.addGestureRecognizer(tapImg)
        imgViewForDropDown.isUserInteractionEnabled = true
        
        horizontalDropShadow()
        horizontalScrollView.bounces = false
        horizontalScrollView.showsHorizontalScrollIndicator = false
        
        searchTextField.borderStyle = .none
        searchTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchButtonTapped))
        searchImageView.addGestureRecognizer(tapGesture)
        searchImageView.isUserInteractionEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        
        let layout = LPCollectionViewLayout()
        layout.delegate = self
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
        collectionView.collectionViewLayout = layout
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Function
    func createCollectionViewItems(from listingResponses: [ListingResponse], for city: String) -> [CollectionViewItems] {
        return listingResponses
            .filter { $0.city.lowercased() == city.lowercased() }
            .map { listingResponse in
                let id = listingResponse.id
                let title = listingResponse.productName
                let imageURL = listingResponse.images.first.flatMap { URL(string: $0) }
                let price = listingResponse.price
                
                return CollectionViewItems(id: id, title: title, imageURL: imageURL, price: price)
            }
    }
    
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
        coordinator?.goToCreateListingVC()
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
        
        let item = vm.items[indexPath.item]
        cell.titleLabel.text = item.title
        cell.priceLabel.text = String(format: "$%.2f", item.price)
        cell.imageViewItem.loadImage(from: item.imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
        
        headerView.updateCityLabel(city: cityLabel.text!)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = vm.items[indexPath.item]
        
        guard let id = selectedItem.id else { return }
        
        coordinator?.goToProductDetailsVC(listingId: id)
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
        searchButtonTapped()
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    func getUsers() {
        getUser { result in
            switch result {
            case .success(let user):
                print("User data successfully fetched: \(user)")
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    func getAllListing() {
        let getAllListingEndpoint = GetAllListingEndpoint()
        NetworkManager.shared.request(endpoint: getAllListingEndpoint) { (result: Result<ListingResponses, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    guard let city = self.cityLabel.text else {
                        return
                    }
                    
                    let collectionViewItems = self.createCollectionViewItems(from: response, for: city)
                    self.vm = FlowLayoutViewModel(items: collectionViewItems)
                    
                    if let layout = self.collectionView.collectionViewLayout as? LPCollectionViewLayout {
                        layout.clearCache()
                        layout.invalidateLayout()
                    }
                    
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch all listings: \(error.localizedDescription)")
            }
        }
    }
    
    func searchProducts(search: Search, completion: @escaping (Result<[ListingResponse], Error>) -> Void) {
        let searchEndpoint = SearchEndpoint(search: search)
        NetworkManager.shared.request(endpoint: searchEndpoint, completion: completion)
    }
    
    @objc func searchButtonTapped() {
        guard let searchText = searchTextField.text, let city = cityLabel.text else { return }
        
        let search = Search(search: searchText, city: city)
        searchProducts(search: search) { (result: Result<[ListingResponse], Error>) in
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    
                    let collectionViewItems = self.createCollectionViewItems(from: searchResults, for: city)
                    self.vm = FlowLayoutViewModel(items: collectionViewItems)
                    
                    if let layout = self.collectionView.collectionViewLayout as? LPCollectionViewLayout {
                        layout.clearCache()
                        layout.invalidateLayout()
                    }
                    
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getListingByCategory() {
        guard let city = cityLabel.text else { return }
        
        let listingCategory = ListingCatergory(category: "VEHICLES", city: city)
        let getListingByCategoryEndpoint = GetListingByCategoryEndpoint(category: listingCategory)
        
        NetworkManager.shared.request(endpoint: getListingByCategoryEndpoint) {(result: Result<ListingResponses, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    guard let city = self.cityLabel.text else {
                        return
                    }
                    
                    let collectionViewItems = self.createCollectionViewItems(from: response, for: city)
                    self.vm = FlowLayoutViewModel(items: collectionViewItems)
                    
                    if let layout = self.collectionView.collectionViewLayout as? LPCollectionViewLayout {
                        layout.clearCache()
                        layout.invalidateLayout()
                    }
                    
                    self.collectionView.reloadData()
                }
                
                print("Listing fetch by category success!: \(response)")
            case .failure(let error):
                print("Listing fetch by category fail: \(error.localizedDescription)")
            }
        }
        
    }
}

extension DashboardViewController: LPCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, cellWidth: CGFloat, heightForAtIndexPath: IndexPath) -> CGFloat {
        
        let height = vm.items[heightForAtIndexPath.row].height(cellWidth: cellWidth)
        return height
        
    }
}

extension DashboardViewController: DropDownSelectionDelegate {
    func setDropDownSelectedOption(_ option: String) {
        cityLabel.text = option
        
        if let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderCollectionReusableView {
            headerView.updateCityLabel(city: option)
        }
        
        getAllListing()
    }
    
    @objc func dropdownTapped(_ sender: UITapGestureRecognizer) {
        if customDropDownView == nil {
            showCustomDropDownViewForStackView(sender)
        } else {
            hideCustomDropDownView()
        }
    }
}
