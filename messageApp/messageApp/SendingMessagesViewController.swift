//
//  SendingMessagesViewController.swift
//  messageApp
//
//  Created by esra.yildiz on 22.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class SendingMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var sendingMessagesTableView: UITableView!
    var messageArray = [String]()
    var nameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareArrays()
        self.view.backgroundColor = UserDefaults.standard.object(forKey: "renk") as? UIColor
    }
    
    func prepareArrays () -> Void
    {
        nameArray.removeAll(keepingCapacity: false)
        messageArray.removeAll(keepingCapacity: false)
        FirebaseOperations.takeMessages(message: "SendingMessages") { (message, user) in
            self.nameArray.append(user)
            self.messageArray.append(message)
            self.sendingMessagesTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sendingMessagesTableView.dequeueReusableCell(withIdentifier: "sendingMessageCell") as! SendingMessageCell
        cell.message.text = messageArray[indexPath.section]
        cell.userName.text = "To: " + nameArray[indexPath.section]
        return cell
    }

    @IBAction func refresh(_ sender: Any)
    {
        prepareArrays()
        self.sendingMessagesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
