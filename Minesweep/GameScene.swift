//
//  GameScene.swift
//  Minesweep
//
//  Created by STEAM on 4/11/19.
//  Copyright © 2019 STEAM. All rights reserved.
//

import SpriteKit
import GameplayKit

let tileSize = 28
let numBombs = 40
var flagMode = false

class GameScene: SKScene {
    var tiles = [[Tile?]](repeating: [Tile?](repeating: nil, count: 20), count: 20)
    
    override func didMove(to view: SKView) {
        for x in 0...19 {
            for y in 0...19 {
                let xpos = (tileSize * x) - 260
                let ypos = (tileSize * y) - 260
                tiles[x][y] = Tile(startx: xpos, starty: ypos, scene: self)
                self.addChild(tiles[x][y]!)
            }
        }
        setup()
    }
    
    func setup() {
        for _ in 0...numBombs {
            let rx = Int.random(in: 0...19)
            let ry = Int.random(in: 0...19)
            tiles[rx][ry]!.isBomb = true
        }
        for x in 0...19 {
            for y in 0...19 {
                var tCount = 0
                if x > 0 {
                    if tiles[x-1][y]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y]!)
                }
                if x < 19 {
                    if tiles[x+1][y]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x+1][y]!)
                }
                if y > 0 {
                    if tiles[x][y-1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x][y-1]!)
                }
                if y < 19 {
                    if tiles[x][y+1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x][y+1]!)
                }
                if x > 0 && y > 0 {
                    if tiles[x-1][y-1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y-1]!)
                }
                if x > 0 && y < 19 {
                    if tiles[x-1][y+1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y+1]!)
                }
                if x < 19 && y > 0 {
                    if tiles[x+1][y-1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x+1][y-1]!)
                }
                if x < 19 && y < 19 {
                    if tiles[x+1][y+1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x+1][y+1]!)
                }
                tiles[x][y]!.count = tCount
            }
        }
    }
    
    func explode() {
        var timeDelay : Double = 1
        for row in tiles {
            for tile in row {
                if tile!.isBomb {
                    let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeDelay), repeats: false) { _ in
                        tile!.click()
                    }
                    timeDelay += 0.1
                }
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let touched = self.nodes(at: pos)
        for tile in touched {
            if tile.name == "tile" {
                let cTile = tile as! Tile
                cTile.click()
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
