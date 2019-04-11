//
//  Tile.swift
//  Minesweep
//
//  Created by STEAM on 4/11/19.
//  Copyright © 2019 STEAM. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : SKSpriteNode {
    var isBomb = false
    var count = 0
    var neighbors = [Tile]()
    var isClicked = false
    var mainScene : GameScene?
    
    init(startx : Int, starty: Int, scene: SKScene) {
        let tex = SKTexture(imageNamed: "tile_base")
        super.init(texture: tex, color: UIColor.clear, size: tex.size())
        self.size = CGSize(width: tileSize, height: tileSize)
        self.position = CGPoint(x: startx, y: starty)
        self.name = "tile"
        mainScene = scene as! GameScene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func click() {
        isClicked = true
        if isBomb {
            self.texture = SKTexture(imageNamed: "bomb")
            mainScene!.explode()
        } else {
            let numStr = String(count)
            self.texture = SKTexture(imageNamed: numStr)
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
