//
//  Tile.swift
//  Minesweep
//
//  Created by STEAM on 4/11/19.
//  Copyright © 2019 STEAM. All rights reserved.
//

import Foundation
import SpriteKit
//inheritance
class Tile : SKSpriteNode {
    //contain
//    var sprite = SKSpriteNode(imageNamed: "tile_base")
    var isBomb = false
    var count = 0
    var neighbors = [Tile]()
    var isClicked = false
    var mainScene : GameScene?
    var flagged = false
    
    
    var count = 2
    
    init(startx : Int, starty: Int) {
        let tex = SKTexture(imageNamed: "tile_base")
        super.init(texture: tex, color: UIColor.clear, size: tex.size())
        self.size = CGSize(width: tileSize, height: tileSize)
        self.position = CGPoint(x: startx, y: starty)
        self.name = "tile"
        mainScene = (scene as! GameScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flag() {
        if (isClicked) {
            return
        }
        flagged = !flagged
        if flagged {
            self.texture = SKTexture(imageNamed: "flagged")
        } else {
            self.texture = SKTexture(imageNamed: "tile_base")
        }
    }
    
    func explode() {
        self.texture = SKTexture(imageNamed: "bomb")
        
    }
    
    func click() {
        
        if isClicked {
            var tCount = 0
            for n in neighbors {
                if n.flagged {
                    tCount += 1
                }
            }
            if tCount == count {
                for n in neighbors {
                    if !n.isClicked {
                        n.click()
                    }
                }
            }
        }
        
        isClicked = true
        if flagged {
            return
        }
        if isBomb {
            self.explode()
            mainScene!.explode()
        } else {
            let numStr = String(count)
            self.texture = SKTexture(imageNamed: numStr)
            if count == 1 {
                
            }
            if count == 0 {
                for neighbor in neighbors {
                    if !neighbor.isClicked {
                        neighbor.click()
                    }
                }
            }
        }
    }
    
}
