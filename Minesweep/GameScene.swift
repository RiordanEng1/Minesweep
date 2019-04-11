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
    var tiles = [[Tile?]](repeating: [Tile?](repeating: nil, count: gridSize), count: gridSize)
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    func setup() {
        gameOver = false
        self.removeAllChildren()
        for x in 0...gridSize-1 {
            for y in 0...gridSize-1 {
                let xpos = (tileSize * x) - 340
                let ypos = (tileSize * y) - 280
                tiles[x][y] = Tile(startx: xpos, starty: ypos, scene: self)
                self.addChild(tiles[x][y]!)
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
                if x > 0 {
                    if tiles[x-1][y]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y]!)
                }
                if x < gridSize-1 {
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
                if y < gridSize-1 {
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
                if x > 0 && y < gridSize-1 {
                    if tiles[x-1][y+1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x-1][y+1]!)
                }
                if x < gridSize-1 && y > 0 {
                    if tiles[x+1][y-1]!.isBomb {
                        tCount += 1
                    }
                    tiles[x][y]!.neighbors.append(tiles[x+1][y-1]!)
                }
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
        if gameOver {
            return
        }
        let touched = self.nodes(at: pos)
        for tile in touched {
            if tile.name == "tile" {
                let cTile = tile as! Tile
                if flagMode {
                    cTile.flag()
                } else {
                    cTile.click()
                }
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

        self.addChild(SKSpriteNode(imageNamed: "trophy"))
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
