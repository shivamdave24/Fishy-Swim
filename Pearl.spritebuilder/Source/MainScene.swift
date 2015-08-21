import Foundation

class MainScene: CCNode {
 
    func play() {
        
        //the code below loads the scene play
        let gameplay = CCBReader.loadAsScene("Gameplay")
        var transition = CCTransition(fadeWithDuration: 0.2)
        CCDirector.sharedDirector().presentScene(gameplay, withTransition: transition)
    }
    
    func Settings(){
        let settings = CCBReader.loadAsScene("settings")

        CCDirector.sharedDirector().presentScene(settings)

        
    }
}
