//
//  TakenVoiceCell.swift
//  messageApp
//
//  Created by esra.yildiz on 31.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import AVFoundation

class TakenVoiceCell: UITableViewCell,AVAudioPlayerDelegate {
    @IBOutlet weak var voiceProgressView: UIProgressView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    var url: URL!
    var control: Int!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var timer: Timer!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        if let fullURL = url
        {
            let nsURL = (fullURL as NSURL)
            voiceProgressView.progress = 0
            control = 0
            self.downloadFileFromURL(url: nsURL)
            playPauseButton.setBackgroundImage(UIImage(named: "start.jpg"), for: .normal)
        }
    }
    @IBAction func playPauseButtonClicked(_ sender: Any)
    {
        if player != nil
        {
            if playPauseButton.currentBackgroundImage == UIImage(named: "pause.jpg")
            {
                player.pause()
                playPauseButton.setBackgroundImage(UIImage(named: "start.jpg"), for: .normal)
            }
            else
            {
                if (timer == nil)
                {
                    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateAudioProgressView), userInfo: nil, repeats: true)
                    self.voiceProgressView.setProgress(Float(self.player.currentTime/self.player.duration), animated: false)
                    playPauseButton.setBackgroundImage(UIImage(named: "pause.jpg"), for: .normal)
                    player.play()
                    
                }
                else
                {
                    print("play")
                    playPauseButton.setBackgroundImage(UIImage(named: "pause.jpg"), for: .normal)
                    player.play()
                }
            }
        }
        else
        {
            control = 1
            playPauseButton.setBackgroundImage(UIImage(named: "pause.jpg"), for: .normal)
            downloadFileFromURL(url: url! as NSURL)
        }
    }
    
    func downloadFileFromURL(url:NSURL)
    {
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.play(url: URL! as NSURL)
        })
        
        downloadTask.resume()
    }
    
    @objc func updateAudioProgressView()
    {
        if player.isPlaying
        {
            voiceProgressView.setProgress(Float(player.currentTime/player.duration), animated: false)
        }
    }

    func play(url:NSURL) {
        if control == 1
        {
            do {
                self.player = try AVAudioPlayer(contentsOf: url as URL)
                self.player.delegate = self
                player.prepareToPlay()
                player.volume = 1.0
                player.play()
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateAudioProgressView), userInfo: nil, repeats: true)
                    self.voiceProgressView.setProgress(Float(self.player.currentTime/self.player.duration), animated: false)
                }
            }
            catch
            {
                print("AVAudioPlayer init failed")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        self.voiceProgressView.setProgress(1, animated: false)
        timer.invalidate()
        timer = nil
        self.voiceProgressView.setProgress(0, animated: false)
    }
    
}
