//
//  NotificationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class NotificationViewController: MainViewController, DashboardStoryboard {
    
    var newNotifications: [Notification] = [
        Notification(title: "Hey Pearl, welcome to MKTFY", date: "September 7, 2020"),
    ]
    
    var oldNotifications: [Notification] = [
        Notification(title: "Let's create your first offer!", date: "September 5, 2020"),
        Notification(title: "Our Terms of Service has been updated!", date: "September 3, 2020"),
    ]
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupTableViewBackground()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    func setupTableViewBackground() {
        backgroundView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundView.clipsToBounds = true
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let unreadAction = UIContextualAction(style: .normal, title: "Unread") { (_, _, completionHandler) in
                let unSeenNotification = self.oldNotifications.remove(at: indexPath.row)
                self.newNotifications.append(unSeenNotification)
                
                let destinationIndexPath = IndexPath(row: self.newNotifications.count - 1, section: 0)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                tableView.endUpdates()
                
                if let cell = tableView.cellForRow(at: destinationIndexPath) as? NotificationTableViewCell {
                    cell.viewBackgroundColor = .white
                }
                
                completionHandler(true)
            }
            unreadAction.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
            
            let configuration = UISwipeActionsConfiguration(actions: [unreadAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        } else {
            return nil
        }
    }
}
