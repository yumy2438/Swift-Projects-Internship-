//
//  ContactViewController.swift
//  messageApp
//
//  Created by esra.yildiz on 19.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import SDWebImage
import UserNotifications

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate{
    @IBOutlet weak var contactTableView: UITableView!
    var name = ""
    var email = ""
    var personArray = [Person]()
    var index = 0
    
    @IBOutlet weak var userName: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareArray()
        contactTableView.reloadData()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound ]) { (granted, error) in
            if granted
            {
                FirebaseOperations.fetchNotifications(completion: { [weak self] (results) in
                    for result in results
                    {
                        self?.registerCategory()
                        self?.scheduleNotification(message: result["message"]!, userName: result["email"]!)
                    }
                })
            }
        }
        userName.title = "Your email address: " +    FirebaseOperations.getCurrentUserEmail()
    }
    
    func openPopUpMessage(name: String, email: String) -> Void
    {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUp") as! PopUpMessageViewController
        popUpVC.name = "To: " + name
        popUpVC.email = email
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
    }
    
    func prepareArray()
    {
        personArray.removeAll(keepingCapacity: false)
        FirebaseOperations.fetchFromContactList { [weak self] (result: Person) in
            self?.personArray.append(result)
            self?.contactTableView.reloadData()
        }
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewPerson"
        {
            let destinationVC = segue.destination as! NewPersonViewController
            destinationVC.blockNewCityEntered = {
                self.prepareArray()
                self.contactTableView.reloadData()
            }
        }
        if segue.identifier == "toChat"
        {
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.email = personArray[index].email
            destinationVC.nameSurname = (personArray[index].name + " " + personArray[index].surname)
        }
    }
    
    //MARK: Action functions
    @IBAction func logoutButtonClicked(_ sender: Any)
    {
        UserDefaultOperations.removeUser()
        let signBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginSB = signBoard.instantiateViewController(withIdentifier: "loginSB")
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginSB
        FirebaseOperations.signOut()
    }
    
    @IBAction func addButtonClicked(_ sender: Any)
    {
        performSegue(withIdentifier: "toNewPerson", sender: nil)
    }
    
    @IBAction func messageAction(sender: UIButton)
    {
        let person = personArray[sender.tag]
        openPopUpMessage(name: person.name, email: person.email)
    }
    
    //MARK: tableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 138
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
        let person = personArray[indexPath.section]
        cell.personNameSurname.text = person.name + " " + person.surname
        cell.personEmail.text = person.email
        cell.personImage.sd_setImage(with: URL(string: person.image))
        cell.takeMessageButton.tag = indexPath.section
        cell.takeMessageButton.addTarget(self, action: #selector(ContactViewController.messageAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.section
        FirebaseOperations.removeNotifications(friendEmail: personArray[index].email)
        performSegue(withIdentifier: "toChat", sender: nil)
    }
    
    //MARK: Notification
    
    func registerCategory() -> Void
    {
        let callNow = UNNotificationAction(identifier: "reply", title: "Reply", options: [])
        let clear = UNNotificationAction(identifier: "clear", title: "Clear", options: [])
        let category : UNNotificationCategory = UNNotificationCategory.init(identifier: "CALLINNOTIFICATION", actions: [callNow, clear], intentIdentifiers: [], options: [])
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
    }
    
    func scheduleNotification (message : String, userName: String)
    {
        let content = UNMutableNotificationContent()
        content.title = userName
        content.body = message
        content.categoryIdentifier = "CALLINNOTIFICATION"
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let identifier = "id_"+message
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        switch response.actionIdentifier {
        case "reply":
            FirebaseOperations.removeNotifications(friendEmail: email)
            //let nameEmail = response.notification.request.content.title
            //openPopUpMessage(name: nameEmail, email: nameEmail)
            performSegue(withIdentifier: "toChat", sender: nil)
            break
        case "clear":
            FirebaseOperations.removeNotifications(friendEmail: email)
            break
        default:
            performSegue(withIdentifier: "toChat", sender: nil)
            //let nameEmail = response.notification.request.content.title
            //openPopUpMessage(name: nameEmail, email: nameEmail)
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.badge, .alert, .sound])
    }
}
