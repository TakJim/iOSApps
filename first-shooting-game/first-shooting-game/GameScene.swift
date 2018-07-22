//
//  GameScene.swift
//  first-shooting-game
//
//  Created by T. Jimbo on 2018/07/22.
//  Copyright © 2018年 TakJim. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let motionManager = CMMotionManager()
    var accelaration: CGFloat = 0.0
    
    var timer: Timer?
    
    var earth: SKSpriteNode!
    var spaceship: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.earth = SKSpriteNode(imageNamed: "earth")
        self.earth.xScale = 1.5
        self.earth.yScale = 0.3
        self.earth.position = CGPoint(x: 0, y: -frame.height / 2)
        self.earth.zPosition = -1.0
        addChild(self.earth)
        
        self.spaceship = SKSpriteNode(imageNamed: "spaceship")
        self.spaceship.scale(to: CGSize(width: frame.width / 5, height: frame.width / 5))
        self.spaceship.position = CGPoint(x: 0, y: self.earth.frame.maxY + 50)
        addChild(self.spaceship)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, _) in
            guard let data = data else { return } //guard は条件に一致しなかった場合、処理を中断させる
            let a = data.acceleration
            self.accelaration = CGFloat(a.x) * 0.75 + self.accelaration * 0.25
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in self.addAsteroid()} )
    }
    
    override func didSimulatePhysics() {
        let nextPosition = self.spaceship.position.x + self.accelaration * 50
        if nextPosition > frame.width / 2 - 30 { return }
        if nextPosition < -frame.width / 2 + 30 { return }
        self.spaceship.position.x = nextPosition
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { //タップが終わった時に行う処理
        let missile = SKSpriteNode(imageNamed: "missile") //宇宙船や地球と違って、スコープはこの関数内
        missile.position = CGPoint(x: self.spaceship.position.x, y: self.spaceship.position.y + 50)
        addChild(missile)
        
        let moveToTap = SKAction.moveTo(y: frame.height + 10, duration: 1) //durationは弾の速さ
        let remove = SKAction.removeFromParent()
        missile.run(SKAction.sequence([moveToTap, remove])) //runはSKSpriteNodeクラスのメソッドで、指定したSKActionを実行する。sequenceで順番にmoveしてremoveせよと命令。
    }
    
    func addAsteroid(){
        let names = ["asteroid1", "asteroid2", "asteroid3"]
        let index = Int(arc4random_uniform(UInt32(names.count)))
        let name = names[index]
        let asteroid = SKSpriteNode(imageNamed: name)
        let random = CGFloat(arc4random_uniform(UINT32_MAX)) / CGFloat(UINT32_MAX)
        let positionX = frame.width * (random - 0.5)
        asteroid.position = CGPoint(x: positionX, y: frame.height / 2 + asteroid.frame.height)
        asteroid.scale(to: CGSize(width: 70, height: 70))
        addChild(asteroid)
        
        let move = SKAction.moveTo(y: -frame.height / 2 - asteroid.frame.height, duration: 6.0)
        let remove = SKAction.removeFromParent()
        asteroid.run(SKAction.sequence([move, remove]))
    }
    
}
