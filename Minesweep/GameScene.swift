//
//  GameScene.swift
//  Minesweep
//
//  Created by STEAM on 4/11/19.
//  Copyright © 2019 STEAM. All rights reserved.
//

import SpriteKit
import GameplayKit

let tileSize = 60
let numBombs = 20
var flagMode = false
var gridSize = 12
var gameOver = false

class GameScene: SKScene {
    var plusButton = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
    
    
    
    
    var tiles = [[Tile?]](repeating: [Tile?](repeating: nil, count: gridSize), count: gridSize)
    var gvc : GameViewController?
    override func didMove(to view: SKView) {
        plusButton.position = CGPoint(x: -250, y: 250)
        plusButton.name == "plus"
        self.addChild(plusButton)
        
        setup()
    }
    
    func setup() {
        gameOver = false
        self.removeAllChildren()
        for x in 0...gridSize-1 {
            for y in 0...gridSize-1 {
                let xpos = (tileSize * x) - 340
                let ypos = (tileSize * y) - 280
                //tiles[x][y] = Tile(startx: xpos, starty: ypos, scene: self)
                self.addChild(tiles[x][y]!)
                //tiles[x][y].
            }
        }
        for _ in 0...numBombs {
            let rx = Int.random(in: 0...gridSize-1)
            let ry = Int.random(in: 0...gridSize-1)
            tiles[rx][ry]!.isBomb = true
        }
        for x in 0...gridSize-1 {
            for y in 0...gridSize-1 {
                var tCount = 0
                
                //left
                if x > 0 {
                    if tiles[x-1][y]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y]!)
                }
                //right
                if x < gridSize-1 {
                    if tiles[x+1][y]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x+1][y]!)
                }
                //below
                if y > 0 {
                    if tiles[x][y-1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x][y-1]!)
                }
                //above
                if y < gridSize-1 {
                    if tiles[x][y+1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x][y+1]!)
                }
                //upper left corner
                if x > 0 && y > 0 {
                    if tiles[x-1][y-1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y-1]!)
                }
                //upper right corner
                if x > 0 && y < gridSize-1 {
                    if tiles[x-1][y+1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y+1]!)
                }
                //lower left
                if x < gridSize-1 && y > 0 {
                    if tiles[x+1][y-1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x+1][y-1]!)
                }
                //lower left
                if x < gridSize-1 && y < gridSize-1 {
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
        gameOver = true
        var timeDelay : Double = 0.3
        for row in tiles {
            for tile in row {
                if tile!.isBomb {
                    let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeDelay), repeats: false) { _ in
                        tile!.explode()
                    }
                    timeDelay += 0.1
                }
            }
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
//        if gameOver {
//            return
//        }
        let touched = self.nodes(at: pos)
        for tile in touched {
            if let pikachu = sprite as? moleclass {
                if pikachu.active {
                    score += 1
                }
            } else if sprite.name == "plus" {
                speed += 5
            }
            
            
            if tile.name == "tile" {
                let cTile = tile as! Tile
                cTile.click()
                
                
//                if flagMode {
//                    cTile.flag()
//                } else {
//
//                }
            }
        }
        checkWin()
    }
    
    func checkWin() {
        for row in tiles {
            for tile in row {
                if !tile!.isClicked && !tile!.isBomb{
                    return
                }
            }
        }

        let troph = SKSpriteNode(imageNamed: "trophy")
        troph.size = CGSize(width: 350, height: 350)
        troph.zPosition = 5
        self.addChild(troph)
        gameOver = true
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
    
    var nextShotTime : Double?
    override func update(_ currentTime: TimeInterval) {
        if (currentTime.distance(to: nextShotTime!) < 2) {
            
            nextShotTime = currentTime.advanced(by: 1.0)
        }
        // Called before each frame is rendered
    }
}
