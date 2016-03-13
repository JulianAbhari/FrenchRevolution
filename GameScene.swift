//
//  GameScene.swift
//  FrenchRevolution
//
//  Created by Julian Abhari on 2/24/16.
//  Copyright (c) 2016 Julian Abhari. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Enemy : UInt32 = 1
    static let Knife : UInt32 = 2
    static let Player : UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isGameOver = false
    var Enemy = SKSpriteNode(imageNamed: "Enemy.png")
    var Player = SKSpriteNode(imageNamed: "Player.png")
    var scoreLabel = UILabel()
    var gameOverLabel = UILabel()
    var Score = Int()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let backgroundTexture = SKTexture(imageNamed: "Backgroundimage.png")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture, size: view.frame.size)
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        backgroundImage.zPosition = -5
        backgroundImage.setScale(1.8)
        addChild(backgroundImage)
        
        physicsWorld.contactDelegate = self
        Player.position = CGPointMake(self.size.width/5, self.size.height/3)
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size)
        Player.physicsBody!.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Player.physicsBody?.dynamic = false
        Player.setScale(3.0)
        self.addChild(Player)
        
        EnemyTimer()
        
        scoreLabel.text = "\(Score)"
        scoreLabel = UILabel(frame: CGRect(x: 30, y: 50, width: 100, height: 20))
        scoreLabel.backgroundColor = UIColor.clearColor()
        scoreLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(scoreLabel)
        
        gameOverLabel.text = "Game Over"
        gameOverLabel = UILabel(frame: CGRect(x: 100, y: 50, width: 100, height: 20))
        gameOverLabel.backgroundColor = UIColor.clearColor()
        gameOverLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(gameOverLabel)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Knife)) || ((firstBody.categoryBitMask == PhysicsCategory.Knife) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
            
            CollisionWithKnife(firstBody.node as! SKSpriteNode, Knife: secondBody.node as! SKSpriteNode)
        }
            
        else if ((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Player)) || ((firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
            
            CollisionWithPerson(firstBody.node as! SKSpriteNode, Person: secondBody.node as! SKSpriteNode)
            
            
        }
    }
    
    func CollisionWithPerson(Enemy: SKSpriteNode, Person: SKSpriteNode) {
        Enemy.removeFromParent()
        Person.removeFromParent()
        
        gameOver()
        
    }
    
    func CollisionWithKnife(Enemy: SKSpriteNode, Knife: SKSpriteNode) {
        Enemy.removeFromParent()
        Knife.removeFromParent()
        Score++
        
        scoreLabel.text = "\(Score)"
    }
    
    
    func EnemyTimer() {
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("spawnEnemies"), userInfo: nil, repeats: true)
        
    }
    
    func spawnEnemies() {
        
        let Enemy = SKSpriteNode(imageNamed: "Enemy")
        Enemy.position = CGPoint(x: self.size.width, y: self.size.height / 3)
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Knife
        Enemy.physicsBody!.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        
        
        
        let action = SKAction.moveToX(1, duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        Enemy.runAction(SKAction.sequence([action, actionDone]))
        Enemy.setScale(3.0)
        self.addChild(Enemy)
       
        
    }
    
    func spawnKnife() {
        
        let Knife = SKSpriteNode(imageNamed: "Knife.png")
        Knife.zPosition = 1
        Knife.position = CGPointMake(Player.position.x, Player.position.y)
        
        let action = SKAction.moveToX(self.size.width + 30, duration: 0.8)
        let actionDone = SKAction.removeFromParent()
        Knife.runAction(SKAction.sequence([action, actionDone]))
        Knife.physicsBody = SKPhysicsBody(rectangleOfSize: Knife.size)
        Knife.physicsBody?.categoryBitMask = PhysicsCategory.Knife
        Knife.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Knife.physicsBody?.affectedByGravity = false
        Knife.physicsBody?.dynamic = false
        Knife.setScale(0.5)
        self.addChild(Knife)
    }
    
    func gameOver() {
        isGameOver = true
        
        gameOverLabel.text = "Game Over"
    }
    
    func restart() {
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .AspectFill
        
        view!.presentScene(newScene)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if isGameOver {
            restart()
        }
        else {
          spawnKnife()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            Player.position.x = location.x
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
