//
//  GameScene.swift
//  CookieCrunch
//
//  Created by Hector Enrique Gomez Morales on 7/14/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var level: Level!
    
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    
    let gameLayer = SKNode()
    let cookieslayer = SKNode()
    
    init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(x: -TileWidth * CGFloat(NumColumns) / 2, y: -TileHeight * CGFloat(NumRows) / 2)
        cookieslayer.position = layerPosition
        gameLayer.addChild(cookieslayer)
    }
    
    
}
