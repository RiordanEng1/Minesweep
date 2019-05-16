//
//  GameViewController.swift
//  Minesweep
//
//  Created by STEAM on 4/11/19.
//  Copyright © 2019 STEAM. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var timer : Timer?
    var seconds = 0, minutes = 0
    @IBOutlet weak var clockLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                let gameScene = scene as! GameScene
                gameScene.gvc = self
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            startClock()
        }
    }
    
    func gameOver() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "someViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func startClock() {
        if let t = timer {
            t.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.updateClock), userInfo: nil, repeats: true)
        seconds = 0
        minutes = 0
    }
    
    @objc func updateClock() {
        if gameOver {
            timer!.invalidate()
        }
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        formatter.maximumIntegerDigits = 2
        clockLabel.text = formatter.string(from: NSNumber(integerLiteral: minutes))! + ":" + formatter.string(from: NSNumber(integerLiteral: seconds))!
        seconds += 1
        if seconds >= 60 {
            minutes += 1
            seconds = 0
        }
    }
    @IBAction func reset(_ sender: Any) {
        startClock()
        gameScene!.setup()
    }
    

    @IBAction func flagModeButton(_ sender: UIButton) {
        flagMode = !flagMode
        if (flagMode) {
            sender.backgroundColor = UIColor.red
        } else {
            sender.backgroundColor = UIColor.white
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
