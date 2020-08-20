//
//  ViewController.swift
//  esleKazan
//
//  Created by esra.yildiz on 9.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var animalCollectionView: UICollectionView!
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var beQuietButton: UIButton!
    
    var indexList = [Int]()
    var numberOfMoves = 0
    var formerImageAndIndex: (UIImage,Int)!
    var score = 0
    var time = 30
    var timer: Timer!
    var timerForHiding: Timer!
    var formerCell: ImageCollectionViewCell! = nil
    var currentCell: ImageCollectionViewCell! = nil
    var indexPathForBlue: IndexPath!
    var player1: AVAudioPlayer!
    var player2: AVAudioPlayer!
    var player3: AVAudioPlayer!
    var controlForSound = true
    var isItSameCell = false
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        time = 30
        score = 0
        numberOfMoves = 0
        controlForSound = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.decreaseTime), userInfo: nil, repeats: true)
        scoreLabel.text = "\(score)"
        formIndexList()
        playGameSound()
    }
    
    @objc func decreaseTime()
    {
        time -= 1
        timerLabel.text = "\(time)"
        if time < 10
        {
            timerLabel.textColor = UIColor.red
            timerLabel.font = UIFont(name: "\(time)", size: 25)
            timerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        }
        if time == 0
        {
            timer.invalidate()
            self.esraCreateAnAlert(title: "UPS" ,message: "Time is finished.")
            playFinishedSound(resource: "gameOver", withExtension: "wav")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = animalCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.indexList = indexList
        cell.chosenIndex = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        movesLabel.text = "\(numberOfMoves)"
        if numberOfMoves < 30
        {
            if timerLabel.text != "0"
            {
                if formerImageAndIndex != nil
                {
                    let formerIndexPath = IndexPath(item: formerImageAndIndex!.1 , section: 0)
                    if formerIndexPath == indexPath
                    {
                        isItSameCell = true
                    }
                    else
                    {
                        isItSameCell = false
                    }
                }
                if formerImageAndIndex == nil && numberOfMoves != 0
                {
                    doAllScreenBlue()
                }
                if isItSameCell == false
                {
                    playSound()
                    scoreLabel.textColor = UIColor.black
                    let image = animalImageArray[indexList[indexPath.row]]
                    currentCell = animalCollectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
                    currentCell.animalImage.image = image
                    UIView.transition(with: currentCell.animalImage, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                    if numberOfMoves%2 == 1
                    {
                        if formerImageAndIndex?.0 == image && formerImageAndIndex?.0 != UIImage(named: "maviEkran.jpg") && formerImageAndIndex?.1 != indexPath.row
                        {
                            self.animalCollectionView.isUserInteractionEnabled = false
                            timerForHiding = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.makeHide), userInfo: nil, repeats: false)
                            let formerIndexPath = IndexPath(item: formerImageAndIndex!.1 , section: 0)
                            formerCell = (animalCollectionView.cellForItem(at: formerIndexPath) as! ImageCollectionViewCell)
                            formerCell?.animalImage.image = image
                            score += 10
                            formerCell.isUserInteractionEnabled = false
                            currentCell.isUserInteractionEnabled = false
                            //
                            let originalTransform = scoreLabel.transform
                            let scaledTransform = originalTransform.scaledBy(x: 0.2, y: 0.2)
                            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: -250.0)
                            self.scoreLabel.textColor = UIColor.red
                            UIView.animate(withDuration: 0.7, animations: {
                                self.scoreLabel.transform = scaledAndTranslatedTransform
                            })
                            scoreLabel.transform = originalTransform
                            //
                            scoreLabel.text = "\(score)"
                            if score == 60
                            {
                                createStars()
                                timer.invalidate()
                                playFinishedSound(resource: "congratulations", withExtension: "wav")
                            }
                        }
                        if formerImageAndIndex?.0 != image
                        {
                            formerImageAndIndex = nil
                        }
                    }
                    if numberOfMoves%2 == 0
                    {
                        formerImageAndIndex = (animalImageArray[indexList[indexPath.row]], indexPath.row) as! (UIImage, Int)
                    }
                    else
                    {
                        formerImageAndIndex = nil
                    }
                    numberOfMoves += 1
                }
                
            }
            else
            {
                timer.invalidate()
                self.esraCreateAnAlert(title: "UPS", message: "Time is finished.")
                playFinishedSound(resource: "gameOver", withExtension: "wav")
            }
        }
        else
        {
            timer.invalidate()
            playFinishedSound(resource: "gameOver", withExtension: "wav")
            self.esraCreateAnAlert(title: "UPS", message: "Your right of action is 30")
        }
        
        
    }
    
    func createStars()
    {
        let collectionViewHeight = animalCollectionView.bounds.height
        let collectionViewWidth = animalCollectionView.bounds.width
        let starArray = [(0.0,0.0),(collectionViewWidth,0),(0,collectionViewHeight),(collectionViewWidth,collectionViewHeight)]
        let image = UIImage(named: "star.png")
        var imageViewArray = [UIImageView]()
        for star in starArray
        {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: star.0, y: star.1, width: 5, height: 5)
            self.view.addSubview(imageView)
            imageViewArray.append(imageView)
        }
        let label = UILabel(frame: CGRect(x: collectionViewWidth/2-150, y: collectionViewHeight/2-50, width: 300, height: 100))
        label.textAlignment = .center
        label.text = "CONGRATULATIONS"
        
        label.font = UIFont.boldSystemFont(ofSize: 8)
        view.addSubview(label)
        
        UIView.animate(withDuration: 1) {
            for imageView in imageViewArray
            {
                imageView.frame = CGRect(x: collectionViewWidth/2-100, y: collectionViewHeight/2-100, width: 200, height: 200)
            }
            label.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = (animalCollectionView.bounds.width)-10
        let collectionViewHeight = (animalCollectionView.bounds.height)-15
        let size = CGSize(width: collectionViewWidth/3-1, height: collectionViewHeight/4-1)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func playSound()
    {
        if controlForSound
        {
            let url = Bundle.main.url(forResource: "flipcard", withExtension: "wav")
            do {
                player1 = try AVAudioPlayer(contentsOf: url!)
                guard let player = player1 else { return }
                
                player.prepareToPlay()
                player.play()
                if isVolumeOpen == false
                {
                    player.volume = 0
                }
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    @objc func playGameSound()
    {
        let url = Bundle.main.url(forResource: "gameSound", withExtension: "wav")
        do {
            player2 = try AVAudioPlayer(contentsOf: url!)
            guard let player = player2 else { return }
            
            player.prepareToPlay()
            player.play()
            if isVolumeOpen == false
            {
                player.volume = 0
                beQuietButton.setImage(UIImage(named: "volumeOff.png"), for: .normal)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playFinishedSound(resource: String, withExtension: String)
    {
        if controlForSound
        {
            if player2.isPlaying
            {
                player2.stop()
            }
            let url = Bundle.main.url(forResource: resource, withExtension: withExtension)
            do {
                player3 = try AVAudioPlayer(contentsOf: url!)
                guard let player = player3 else { return }
                
                player.prepareToPlay()
                player.play()
                if isVolumeOpen == false
                {
                    player.volume = 0
                }
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    
    @IBAction func replayButtonClicked(_ sender: Any)
    {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameBoard = storyBoard.instantiateViewController(withIdentifier: "gameBoard")
        delegate.window?.rootViewController = gameBoard
        player2.stop()
        timer.invalidate()
    }
    
    @objc func doAllScreenBlue()
    {
        for index in 0..<12
        {
            let indexPaths = IndexPath(item: index, section: 0)
                let currentCellImage = (animalCollectionView.cellForItem(at: indexPaths) as! ImageCollectionViewCell).animalImage
                if currentCellImage?.image != UIImage(named: "maviEkran.jpg")
                {
                    currentCellImage?.image = UIImage(named: "maviEkran.jpg")
                    UIView.transition(with: currentCellImage!, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
                }
        }
    }
    
    @objc func makeHide()
    {
        UIView.animate(withDuration: 0.1) {
            self.formerCell.animalImage.alpha = 0
            self.currentCell.animalImage.alpha = 0
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.enableInteractionAgain), userInfo: nil, repeats: false)
        }
        timerForHiding.invalidate()
    }
    
    @objc func enableInteractionAgain()
    {
        animalCollectionView.isUserInteractionEnabled = true
    }
    
    
    func formIndexList()
    {
        while indexList.count < 12 {
            let number = Int(arc4random_uniform(12))
            if lookIsNotThere(number: number)
            {
                indexList.append(Int(number))
            }
            else
            {
                if indexList.count == 12
                {
                    return
                }
                else
                {
                    formIndexList()
                }
            }
        }
    }
    @IBAction func beQuietButtonClicked(_ sender: Any)
    {
        if player2.volume != 0
        {
            beQuietButton.setImage(UIImage(named: "volumeOff.png"), for: .normal)
            player2.volume = 0
            isVolumeOpen = false
            controlForSound = false
        }
        else
        {
            beQuietButton.setImage(UIImage(named: "volumeOn.png"), for: .normal)
            controlForSound = true
            isVolumeOpen = true
            player2.volume = 1
        }
    }
    
    
    
    func lookIsNotThere(number: Int) -> Bool
    {
        if indexList.count > 0
        {
            for index in indexList
            {
                if index == number
                {
                    return false
                }
            }
            return true
        }
        else
        {
            return true
        }
    }
    
}

