//
//  ViewController.swift
//  musicPlayer1
//
//  Created by techmaster on 10/27/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var sld_vol: UISlider!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var sld_time: UISlider!    
    @IBOutlet weak var repeatChange: UISwitch!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songImgLabel: UIImageView!
    
    var audio = AVAudioPlayer()
    var isPlaying = true
    var musicFile : [String] = ["music_1", "music_", "music_2"]
    var musicName : [String] = ["Shawn_Mendes_-_Stitches", "Charlie_Puth_-_We don't talk anymore", "Bruno_Mars_-_Marry You"]
    var musicImg: [String] = ["Stitches.jpg", "charlie.jpg", "marry.jpg"]
    
    var random = Int(arc4random_uniform(3))
    override func viewDidLoad() {
        super.viewDidLoad()
        audio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: musicFile[random], ofType: "mp3")!))
        songImgLabel.image = UIImage(named: musicImg[random])
        songNameLabel.text = musicName[random]
        
        audio.delegate = self
        audio.numberOfLoops = -1
        audio.prepareToPlay()
        addSliderImg()
        convertTime(time: Float(audio.duration), lbl: self.totalTime)
        sld_time.maximumValue = Float(audio.duration)
        repeatChange.addTarget(self, action: #selector(switchChange), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func updateFrame() {
        convertTime(time: Float(audio.currentTime), lbl: self.runTime)
        sld_time.value = Float(audio.currentTime)
    }
    func addSliderImg() {
        sld_vol.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        sld_vol.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .highlighted)
    }
    
    @IBAction func prevTrackBtn(_ sender: UIButton) {
        var cur_id = musicName.index(of: songNameLabel.text!)!
        print("cur_id = \(cur_id)")
        if cur_id == 0 {
            cur_id = 2
        } else {
            cur_id = cur_id - 1
        }
        setParam(index: cur_id)
    }
    
    @IBAction func nextTrackBtn(_ sender: UIButton) {
        var cur_id = musicName.index(of: songNameLabel.text!)!
        print("cur_id = \(cur_id)")
        if cur_id == 2 {
            cur_id = 0
        } else {
            cur_id = cur_id + 1
        }
        setParam(index: cur_id)
    }
    @IBAction func action_play(_ sender: UIButton) {
        if isPlaying {
            audio.play()
            btn_play.setImage(UIImage(named: "pause.png"), for: UIControlState())
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateFrame), userInfo: nil, repeats: true)
        }
        else {
            audio.pause()
            btn_play.setImage(UIImage(named: "play.png"), for: UIControlState())
        }
    }
    
    @IBAction func action_repeat(_ sender: UISwitch) {
        if sender.isOn {
            audio.numberOfLoops = -1
        } else {
            audio.numberOfLoops = 0
        }
    }
    @IBAction func action_sliderVol(_ sender: UISlider) {
        audio.volume = sender.value
    }
    
    @IBAction func action_sliderTime(_ sender: UISlider) {
        audio.currentTime = TimeInterval(sender.value)
    }
    
    func switchChange(){

    }
    func  setParam(index: Int) {
        audio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: musicFile[index], ofType: "mp3")!))
        songImgLabel.image = UIImage(named: musicImg[index])
        songNameLabel.text = musicName[index]
        self.btn_play.setImage(UIImage(named: "play.png"), for: UIControlState())
    }
    func convertTime(time: Float, lbl: UILabel) {
        let minu: Int = Int(time / 60)
        let sec: Int = Int(time.truncatingRemainder(dividingBy: 60))
        if (sec < 10 && minu < 10){
            lbl.text = "0\(minu):0\(sec) "
        } else {
            if sec < 10 {
                lbl.text = "\(minu):0\(sec) "
            } else if minu < 10 {
                lbl.text = "0\(minu):\(sec) "
            }else{
                lbl.text = "\(minu):\(sec) "
            }
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("numberOfLoops = \(audio.numberOfLoops)")
        self.btn_play.setImage(UIImage(named: "play.png"), for: UIControlState())
        isPlaying = !isPlaying
    }
}

