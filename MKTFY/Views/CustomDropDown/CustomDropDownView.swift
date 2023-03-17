////
////  CustomDropDownView.swift
////  MKTFY
////
////  Created by Derek Kim on 2023-03-17.
////
//
//import UIKit
//
//protocol CustomDropDownViewDelegate: AnyObject {
//    func didSelectItem(item: String)
//}
//
//class CustomDropDownView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
//
//    weak var delegate: CustomDropDownViewDelegate?
//
//    private let tableView = UITableView()
//    private let searchBar = UISearchBar()
//
//    private var data: [String] = []
//    private var filteredData: [String] = []
//
//    init(items: [String]) {
//        super.init(frame: .zero)
//        data = items
//        filteredData = data
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//
//        searchBar.delegate = self
//        searchBar.showsCancelButton = true
//
//        addSubview(searchBar)
//        addSubview(tableView)
//
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: topAnchor),
//            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
//
//            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = filteredData[indexPath.row]
//        cell.textLabel?.textAlignment = .left
//        cell.textLabel?.textColor = .black
//        cell.selectionStyle = .default
//
//        let selectedView = UIView()
//        selectedView.backgroundColor = .gray
//        cell.selectedBackgroundView = selectedView
//
//        cell.textLabel?.highlightedTextColor = UIColor.appColor(LPColor.OccasionalPurple)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.didSelectItem(item: filteredData[indexPath.row])
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredData = data
//        } else {
//            filteredData = data.filter { $0.lowercased().contains(searchText.lowercased()) }
//        }
//        tableView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//}
