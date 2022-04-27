//
//  NotificationsViewController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 20.04.2022.
//

import UIKit

class NotificationsViewController: UITableViewController {
    
    var unreadMessages = [Notification]()
    var allMessages = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (unread, all) = NotificationsRequest.loadNotifications()
        if let unread = unread,
           let all = all {
            unreadMessages = unread
            allMessages = all
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let (unread, all) = NotificationsRequest.loadNotifications()
        if let unread = unread,
           let all = all {
            unreadMessages = unread
            allMessages = all
        }
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? unreadMessages.count : allMessages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt
       indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
           "NotificationCellIdentifier", for: indexPath) as! NotificationCell
        
        let message = indexPath.section == 0 ? unreadMessages[indexPath.row] : allMessages[indexPath.row]

        cell.messageLabel.attributedText = message.message.transformToAttributedString()
        (cell.timeLabel.text, cell.dateLabel.text) = message.timestamp.formatTimestamp()
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "UNREAD" : "ALL"
    }
    
}

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }
    
    func transformToAttributedString() -> NSMutableAttributedString {
        
        let str = self
        
        var startIndex: Int = 0
        var endIndex: Int = 0
        
        for i in 0 ..< str.count {
            if (str[i] == "*") {
                startIndex = i
                break
            }
        }
        
        for i in (0 ..< str.count).reversed()   {
            if (str[i] == "*") {
                endIndex = i
                break
            }
        }
        
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]

        let normalString1 = NSMutableAttributedString(string:String(str[0..<startIndex]))
        let boldText = NSMutableAttributedString(string:String(str[startIndex+2..<endIndex-1]), attributes:attrs)
        let normalString2 = NSMutableAttributedString(string:String(str[1+endIndex..<str.count]))
        
        let attributedString = normalString1
        attributedString.append(boldText)
        attributedString.append(normalString2)
        
        return attributedString
    }
    
    func formatTimestamp() -> (String, String) {
        let timestampString = self.split(separator: "T")
        let dateString = timestampString[0].split(separator: "-")
        let timeString = timestampString[1].split(separator: ":")

        return ("\(timeString[0]):\(timeString[1])", "\(dateString[2]).\(dateString[1]).\(dateString[0])")
    }
}
