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
        setupBackgroundView(view: backgroundView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let seenNotification = newNotifications.remove(at: indexPath.row)
            oldNotifications.append(seenNotification)
            
            let destinationIndexPath = IndexPath(row: oldNotifications.count - 1, section: 1)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
