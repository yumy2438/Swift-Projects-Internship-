//
//  TakenMessagesViewController.swift
//  messageApp
//
//  Created by esra.yildiz on 20.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class TakenMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var takenMessagesTableView: UITableView!
    var messageArray = [String]()
    var nameArray = [String]()
    var email = ""
    
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        super.viewDidLoad()
        FirebaseOperations.takeMessages(message: "TakenMessages") { (message, user) in
            self.nameArray.append(user)
            self.messageArray.append(message)
            self.takenMessagesTableView.reloadData()
        }
        FirebaseOperations.removeNotifications()
        self.view.backgroundColor = UserDefaults.standard.object(forKey: "renk") as? UIColor
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = takenMessagesTableView.dequeueReusableCell(withIdentifier: "messageCell") as! TakenMessageCell
        cell.fromName.text = "FROM: " + nameArray[indexPath.section]
        cell.messageText.text = messageArray[indexPath.section]
        cell.addPersonButtonClicked.tag = indexPath.section
        cell.addPersonButtonClicked.addTarget(self, action: #selector(TakenMessagesViewController.addPerson(sender:)), for: .touchUpInside)
        cell.replyButtonClicked.tag = indexPath.section
        cell.replyButtonClicked.addTarget(self, action: #selector(TakenMessagesViewController.reply(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewPerson"
        {
            let destinationVC = segue.destination as! NewPersonViewController
            destinationVC.personEmail = email
        }
    }
    
    @IBAction func reply(sender: UIButton)
    {
        email = nameArray[sender.tag]
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUp") as! PopUpMessageViewController
        popUpVC.email = email
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
    }
    
    @IBAction func addPerson(sender: UIButton)
    {
        email = nameArray[sender.tag]
        performSegue(withIdentifier: "toNewPerson", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    @IBAction func deleteAllMessagesButtonClicked(_ sender: Any) {
        
    }
    
    

}
