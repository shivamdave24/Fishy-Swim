//
//  Gameplay.swift
//  Pearl
//
//  Created by Shivam Dave on 7/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Gameplay: CCNode {
  
    weak var contentNode: CCNode!
    weak var bg: CCNode!
    weak var bg2: CCNode!
    weak var fish: CCNode!
    var grounds = [CCNode]()
    weak var physics : CCPhysicsNode!
    weak var scoreLabel: CCLabelTTF!
    var score = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    var pauseScreen: Pause!
    var touch = 0
    var stuff = [CCNode]()
    var timeControl: NSTimeInterval  = 1
    var gameOver = false
    var speed: CGFloat = 7.5
    var timer: NSTimer!
    weak var tap1: CCLabelTTF!
    weak var tap2: CCLabelTTF!
    var firstJump = false
    var tracker = 0
 
    func didLoadFromCCB(){
        userInteractionEnabled = true
        physics.collisionDelegate = self
        //adds backgrounds to the grounds array
        grounds.append(bg)
        grounds.append(bg2)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("method"), userInfo: nil,repeats: true)
        var timerSpawn = NSTimer.scheduledTimerWithTimeInterval(timeControl, target: self, selector: "spawnRandomStuff", userInfo: nil, repeats: true)
//        if firstJump == false {
//            tap1.visible = true
//            firstJump = true
//        }
    }
        
    func  method(){
        score+=5

    }
    
    func pausey(){
        self.paused = true
        timer.invalidate()
        pauseScreen = CCBReader.load("Pause", owner: self) as! Pause
        self.addChild(pauseScreen)
        
    }
    func resume(){
        self.paused = false
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("method"), userInfo: nil, repeats: true)
        self.removeChild(pauseScreen)
        
    }
    func quit(){
        let main = CCBReader.loadAsScene("MainScene")
        var transition = CCTransition(fadeWithDuration: 0.2)
        CCDirector.sharedDirector().presentScene(main, withTransition: transition)
    }
    override func update(delta: CCTime) {
        if gameOver {
            return
        }
        contentNode.position.x-=speed
        fish.position.x+=speed
        checkOffScreen()
        checkStuffOffScreen()
        checkBoundaries()
        if touch == 1 {
            fish.position.y+=6
            
        }
        else if touch == 2 {
            fish.position.y-=6
        }
        speed+=0.003
        if speed > 12.5 {
            speed = 12.5
        }
//        if touch == 1 {
//            tap1.visible = false
//            tap2.visible = true
//            tracker++
//        }
//        if tracker > 40 {
//            tap2.visible = false
//        }
    }
    func checkStuffOffScreen() {
        for var s = stuff.count - 1; s>=0; --s {
            var worldPosition = contentNode.convertToWorldSpace(stuff[s].position)
            var screenPosition = convertToNodeSpace(worldPosition)
            if screenPosition.x < -100 {
                physics.removeChild(stuff[s])
                stuff.removeAtIndex(s)
            }
        }
    }
    func spawnRandomStuff(){
        var rand = CCRANDOM_0_1()
        if rand < 0.25 {
            //CCB reader reads the ccb files and loads the anchor ccb file and stores it as a variable to be randomized and spawned
            var anchor = CCBReader.load("Anchor") as! Anchor
            anchor.position = ccp(fish.position.x + 450, 260)
            physics.addChild(anchor)
            stuff.append(anchor)
            timeControl-=0.02
        }
        else if rand < 0.5 {
            var anchor = CCBReader.load("MonsterSpin") as! MonsterSpin
            var constant: CGFloat
            if fish.position.y > self.contentSizeInPoints.height / 2 {
                constant = -anchor.contentSizeInPoints.height / 2
            }
            else { constant = anchor.contentSizeInPoints.height / 2; }
            anchor.position = ccp(fish.position.x + 450, fish.position.y + constant)
            physics.addChild(anchor)
            stuff.append(anchor)
            timeControl-=0.02
        }
        else if rand < 0.75 {
            var anchor = CCBReader.load("Shipwreck") as! shipwreck
            anchor.position = ccp(fish.position.x + 450, 45)
            physics.addChild(anchor)
            stuff.append(anchor)
            timeControl-=0.02
        }
        else {
            var anchor = CCBReader.load("monster1") as! monster1
            anchor.position = ccp(fish.position.x + 450, 50)
            physics.addChild(anchor)
            stuff.append(anchor)
            timeControl-=0.01
        }
        if timeControl < 0.3 {
            timeControl = 0.2
        }
    }
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, fish: CCNode!, wildcard: CCNode!) -> Bool {
        if gameOver {
            return false
        }
        triggerGameOver()
        
        
        
        
        
        
        return true
        
        
   }
    func triggerGameOver(){
        
        
        var gameOverScreen = CCBReader.load("gameOver") as! GameOver
        self.addChild(gameOverScreen)
        gameOverScreen.score = self.score
        gameOver = true
        let defaults = NSUserDefaults.standardUserDefaults()
        var highscore = defaults.integerForKey("highscore")
        if self.score > highscore {
            
            defaults.setInteger(self.score, forKey: "highscore")
        }
    
        
        
    }
        override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if gameOver {
            return
        }
        if self.touch == 0{
            self.touch++
        }
        else if self.touch == 1 {
            self.touch++
        }
        else if self.touch == 2 {
            self.touch--
        }
      
    }
    
    func checkBoundaries(){
        while fish.position.y + fish.boundingBox().height + 30 >= self.contentSizeInPoints.height {
           fish.position.y-=2
           
        }
        
        while fish.position.y - fish.boundingBox().height - 27 < 0 {
            fish.position.y+=2
        }
       
        
        
        
    }
    
    

    func checkOffScreen(){
        //iterates to see if a background is off the screen and if it is then move it to the back
        for g in grounds {
            //this code maintains the original coordinates of the background only instead of continuously adding onto the original coordinates
            var worldPosition = contentNode.convertToWorldSpace(g.position)
            var screenPosition = convertToNodeSpace(worldPosition)
            if screenPosition.x <= -g.boundingBox().width + 8 {
                g.position.x = g.position.x + g.boundingBox().width * 2 - 20
            }
        }
    }
   
}
