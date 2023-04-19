//
//  NotificationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class NotificationViewController: MainViewController, DashboardStoryboard {
    
    // MARK: - Properties
    var newNotifications: [Notification] = []
    var oldNotifications: [Notification] = []
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupTableViewBackground(view: backgroundView, talbeView: tableView)
        
        getNotification()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    // MARK: - Function
    func getNotification() {
        let getUsersNotificationEndpoint = GetUsersNotificationEndpoint()
        NetworkManager.shared.request(endpoint: getUsersNotificationEndpoint) {(result: Result<NotificationResponse, Error>) in
            switch result {
            case .success(let notificationResponse):
                print("Notifications received: \(notificationResponse)")
                self.newNotifications = notificationResponse.new.map { Notification(from: $0) }
                self.oldNotifications = notificationResponse.seen.map { Notification(from: $0) }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Error receiving notifications: \(error.localizedDescription)")
            }
        }
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = tableView.backgroundColor
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
        ])
        
        let bottomConstraintConstant: CGFloat = section == 0 ? -10 : -25
        let bottomConstraint = headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: bottomConstraintConstant)
        bottomConstraint.isActive = true
        
        headerLabel.textColor = UIColor.appColor(LPColor.TextGray)
        headerLabel.font = UIFont(name: "OpenSans-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        headerLabel.text = section == 0 ? "New for you" : "Previously seen"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 44 : 59
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return newNotifications.count
        } else {
            return oldNotifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let notification = indexPath.section == 0 ? newNotifications[indexPath.row] : oldNotifications[indexPath.row]
        
        cell.title = notification.title
        cell.date = notification.date
        
        if indexPath.section == 1 {
            cell.viewBackgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let seenNotification = newNotifications.remove(at: indexPath.row)
            oldNotifications.insert(seenNotification, at: 0)
            
            let destinationIndexPath = IndexPath(row: 0, section: 1)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
