//
//  ChatViewController.swift
//  messageApp
//
//  Created by esra.yildiz on 26.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import FirebaseStorage
import FirebaseDatabase
import MapKit
import NotificationCenter
import UserNotifications

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,CLLocationManagerDelegate{
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var newMessageText: UITextView!
    @IBOutlet weak var talkingWithLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var sendPhotoButoon: UIButton!
    @IBOutlet weak var sendCurrentLocationButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var constraintSendButtonWhenKeyboardOpen: NSLayoutConstraint!
    @IBOutlet weak var constraintSendButtonWhenKeyboardOpen2: NSLayoutConstraint!
    
    var image: UIImage?
    var voiceURL: String?
    var email = ""
    var nameSurname = ""
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var uniqueNumber = NSUUID().uuidString
    var fileName: URL!
    var settings = [String:Any]()
    var userLocation: CLLocation?
    var controlForSendingLocation = false
    
    var locationManager = CLLocationManager()
    
    var sendingAndTakenMessages = [Dictionary<String,Any>]()
    
    
    override func viewDidLoad()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardVisible), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        super.viewDidLoad()
        
        newMessageText.text = "Enter a text"
        newMessageText.textColor = UIColor.brown
        newMessageText.delegate = self
        talkingWithLabel.text = "You are talking with " + nameSurname.uppercased()
        FirebaseOperations.removeNotifications(friendEmail: email)
        fetchMessages()
        recordingSession = AVAudioSession.sharedInstance()
        
        recordingSession.requestRecordPermission { (hasPermissin) in
            if hasPermissin
            {
                print("ACCEPTED")
            }
        }
        newMessageText.returnKeyType = .done
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        newMessageText.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            sendTheText()
            newMessageText.text = ""
            return false
        }
        return true
    }
    
    @objc func keyboardVisible(notification: NSNotification) {
        constraintSendButtonWhenKeyboardOpen.constant = -220
        scroll()
    }
    
    @objc func keyboardHidden(notification: NSNotification) {
        constraintSendButtonWhenKeyboardOpen.constant = 0
    }

    
    func fetchMessages() -> Void
    {
        FirebaseOperations.fetchChatMessages(friendEmail: email) { [weak self] (messageAndEmail) in
            self?.sendingAndTakenMessages.append(messageAndEmail)
            self?.chatTableView.reloadData()
            if self?.sendingAndTakenMessages != nil
            {
                if (self?.sendingAndTakenMessages.count)! > 0
                {
                    let indexPath = IndexPath(row: 0, section: (self?.sendingAndTakenMessages.count)!-1)
                    self?.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            
        }
    }
    
    func scroll() -> Void
    {
        if sendingAndTakenMessages.count > 0
        {
            let indexPath = IndexPath(row: 0, section: sendingAndTakenMessages.count-1)
            chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func sendTheUserLocation()
    {
        FirebaseOperations.saveChatMessages(friendEmail: email, message: "", image: nil, voiceURL: nil, userLocation: userLocation)
        newMessageText.text = ""
    }
    
    func sendTheText()
    {
        FirebaseOperations.saveChatMessages(friendEmail: email, message: newMessageText.text, image: nil, voiceURL: nil, userLocation: nil)
        newMessageText.text = ""
        
    }
    
    func sendTheImage()
    {
        FirebaseOperations.saveChatMessages(friendEmail: email, message: "", image: image, voiceURL: nil, userLocation: nil)
        newMessageText.text = ""
    }
    
    func sendTheVoice()
    {
        FirebaseOperations.saveChatMessages(friendEmail: email, message: "", image: nil, voiceURL: voiceURL, userLocation: nil)
        newMessageText.text = ""
    }
    
    
    //MARK: tableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sendingAndTakenMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let message = sendingAndTakenMessages[indexPath.section]
        if message["longitude"] == nil
        {
            if message["image"] == nil
            {
                if message["voiceUrl"] == nil
                {
                    if message["email"] as! String == FirebaseOperations.getCurrentUserEmail()
                    {
                        let cell = Bundle.main.loadNibNamed("UserTableViewCell", owner: self, options: nil)?.first as! UserTableViewCell
                        cell.isFriend = false
                        cell.userText.text = message["message"] as! String
                        return cell
                    }
                    else
                    {
                        let cell = Bundle.main.loadNibNamed("UserTableViewCell", owner: self, options: nil)?.first as! UserTableViewCell
                        cell.isFriend = true
                        cell.userText.text = message["message"] as! String
                        cell.widthOfTheScreen = chatTableView.frame.size.width
                        cell.awakeFromNib()
                        return cell
                    }
                }
                else
                {
                    let currentURL = URL(string: message["voiceUrl"] as! String)
                    if message["email"] as! String == FirebaseOperations.getCurrentUserEmail()
                    {
                        let sendingVoiceCell = chatTableView.dequeueReusableCell(withIdentifier: "sendingVoiceCell") as! SendingVoiceCell
                        sendingVoiceCell.url = currentURL
                        sendingVoiceCell.awakeFromNib()
                        voiceURL = nil
                        return sendingVoiceCell
                    }
                    else
                    {
                        let takenVoiceCell = chatTableView.dequeueReusableCell(withIdentifier: "takenVoiceCell") as! TakenVoiceCell
                        takenVoiceCell.url = currentURL
                        takenVoiceCell.awakeFromNib()
                        voiceURL = nil
                        return takenVoiceCell
                    }
                }
            }
            else
            {
                let message = sendingAndTakenMessages[indexPath.section]
                if message["email"] as! String == FirebaseOperations.getCurrentUserEmail()
                {
                    let sendingPhotoCell = chatTableView.dequeueReusableCell(withIdentifier: "sendingPhotoCell", for:indexPath) as! SendingPhotoCell
                    sendingPhotoCell.sendingPhoto.sd_setImage(with: URL(string: (message["image"] as! String)))
                    image = nil
                    return sendingPhotoCell
                }
                else
                {
                    let takenPhotoCell = chatTableView.dequeueReusableCell(withIdentifier: "takenPhotoCell", for:indexPath) as! TakenPhotoCell
                    takenPhotoCell.takenPhoto.sd_setImage(with: URL(string: (message["image"] as! String)))
                    image = nil
                    return takenPhotoCell
                }
            }
        }
        else
        {
            if message["email"] as! String == FirebaseOperations.getCurrentUserEmail()
            {
                let sendingLocationCell = chatTableView.dequeueReusableCell(withIdentifier: "sendingLocationCell") as! SendingLocationCell
                sendingLocationCell.coordinate = CLLocationCoordinate2DMake(message["latitude"] as! CLLocationDegrees, message["longitude"] as! CLLocationDegrees)
                sendingLocationCell.goTheRegion()
                return sendingLocationCell
            }
            else
            {
                let takenLocationCell = chatTableView.dequeueReusableCell(withIdentifier: "takenLocationCell") as! TakenLocationCell
                takenLocationCell.coordinate = CLLocationCoordinate2DMake(message["latitude"] as! CLLocationDegrees, message["longitude"] as! CLLocationDegrees)
                takenLocationCell.goTheRegion()
                return takenLocationCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    //MARK: TEXTVIEW FUNCTIONS
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.brown
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = "Enter a text"
            textView.textColor = UIColor.brown
        }
    }
  
    //MARK: ACTION FUNCTIONS
    
    @IBAction func photoButtonClicked(_ sender: Any)
    {
        voiceURL = ""
       choosePhoto()
    }
    
    @IBAction func recordButtonClicked(_ sender: Any)
    {
        newMessageText.isUserInteractionEnabled = false
        if audioRecorder == nil
        {
            fileName = Constant().getDirectory().appendingPathComponent(uniqueNumber + ".m4a")
            settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            do
            {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                startButton.setTitle("CLICK FOR SENDING", for: UIControlState.normal)
                sendCurrentLocationButton.isUserInteractionEnabled = false
                sendPhotoButoon.isUserInteractionEnabled = false
                sendButton.setTitle("CANCEL THE RECORD", for: .normal)
                
            }
            catch
            {
                print("allalala")
            }
        }
        else
        {
            startButton.setTitle("RECORD A VOICE", for: UIControlState.normal)
            sendButton.setTitle("SEND", for: .normal)
            newMessageText.isUserInteractionEnabled = true
            audioRecorder.stop()
            sendCurrentLocationButton.isUserInteractionEnabled = true
            sendPhotoButoon.isUserInteractionEnabled = true
            audioRecorder = nil
            voiceURL = fileName.absoluteString
            sendTheVoice()
        }
    }
    
    @IBAction func sendLocation(_ sender: Any)
    {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if controlForSendingLocation == true
        {
            sendTheUserLocation()
        }
        controlForSendingLocation = true
    }
    
    @IBAction func sendButtonClicked(_ sender: Any)
    {
        if sendButton.titleLabel?.text == "CANCEL THE RECORD"
        {
            audioRecorder = nil
            player = nil
            startButton.setTitle("RECORD A VOICE", for: .normal)
            sendButton.setTitle("SEND", for: .normal)
            newMessageText.isUserInteractionEnabled = true
            sendCurrentLocationButton.isUserInteractionEnabled = true
            sendPhotoButoon.isUserInteractionEnabled = true
            
        }
        else
        {
            sendButton.setTitle("SEND", for: .normal)
            sendTheText()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if controlForSendingLocation
        {
            let locationValue: CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = " + "\(locationValue.latitude) ve \(locationValue.longitude)")
            userLocation = locations.last
            sendTheUserLocation()
        }
    }
    
    //MARK: Image Functions
    
    @objc func choosePhoto()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        sendTheImage()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
