//
//  Credits.swift
//  Pearl
//
//  Created by Shivam Dave on 7/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Credits: CCNode {
   
    func back() {
        let gameplay = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(gameplay)
    }
}
