//
//  GameOver.swift
//  Pearl
//
//  Created by Shivam Dave on 7/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GameOver: CCScene {
    
    weak var scoreLabel: CCLabelTTF!
    weak var highScore: CCLabelTTF!
    var score = 0 {
        
        didSet{
            
            scoreLabel.string = "\(score)"
        }
    }
    
    func didLoadFromCCB(){
        updateHighscore()
        
    }
    
    func updateHighscore(){
        var newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highScore.string = "\(newHighscore)"
    }
    override func update(delta: CCTime) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var currentHighscore = defaults.integerForKey("highscore")
        highScore.string = "\(currentHighscore)"
        
    }
    
    func restart(){
    
        var mainScene = CCBReader.load("Gameplay") as! Gameplay
        var scene = CCScene()
        scene.addChild(mainScene)
        var transition = CCTransition(fadeWithDuration: 0.2)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)


    }
    func Menu(){
        var mainScene = CCBReader.load("MainScene") as! MainScene
        var scene = CCScene()
        scene.addChild(mainScene)
        var transition = CCTransition(fadeWithDuration: 0.2)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        

    }
   
}
