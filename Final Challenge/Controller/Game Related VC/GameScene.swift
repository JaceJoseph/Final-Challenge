//
//  GameScene.swift
//  IOSMoveSpritesAccelerometerTutorial
//
//  Created by Arthur Knopper on 18/12/2018.
//  Copyright © 2018 Arthur Knopper. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import UIKit

struct colliderType {
    static let airplane: UInt32 = 1
    static let obstacle: UInt32 = 0
    static let border: UInt32 = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    var airplane = SKSpriteNode()
    var motionManager = CMMotionManager()
    var destX: CGFloat  = 0.0
    
    var gas = SKSpriteNode()
    var brake = SKSpriteNode()
    var speedometer = SKLabelNode()
    
//    var obstacle = SKSpriteNode()
    var hiddenTrigger = SKSpriteNode()
    var konstruksi = SKSpriteNode()
    var finish = SKSpriteNode()
    
    var collisionLampu = SKSpriteNode()
    var garisLurus = SKSpriteNode()
    var rightRoad = SKSpriteNode()
    var wrongRoad = SKSpriteNode()
    var lampuMerah = SKSpriteNode()
    var border = SKSpriteNode()
    
    var isGassing:Bool = false
    var isBraking:Bool = false
    var isGreen:Bool = false
    var numberOfContact:Int = 0
    
    var maxSpeed:Int = 80
    var minSpeed:Int = 0
    
    var someCounter:Int = 0
    var score:Float = 100.0
    
    var cameraNode = SKCameraNode()
    
    override func didMove(to view: SKView) {
        //MARK: INIT PHYSICS DELEGATE
//        view.showsPhysics = true
        self.physicsWorld.contactDelegate = self
        
        //MARK: INIT BUTTON FOR GAS AND BRAKE
        gas = self.childNode(withName: "gas") as! SKSpriteNode
        gas.removeFromParent()
        
        brake = self.childNode(withName: "brake") as! SKSpriteNode
        brake.removeFromParent()
        
        speedometer = self.childNode(withName: "speedometer") as! SKLabelNode
        speedometer.removeFromParent()
        
        lampuMerah = self.childNode(withName: "lampuMerah") as! SKSpriteNode
        lampuMerah.color = .red
        
        //MARK: INIT OBSTACLE NODE
        garisLurus = self.childNode(withName: "garisLurus") as! SKSpriteNode
        enumerateChildNodes(withName: "garisLurus") { (node, stop) in
                if let skNode = node as? SKSpriteNode{
                    skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.size)
                    skNode.physicsBody!.affectedByGravity = false
                    skNode.physicsBody?.categoryBitMask = colliderType.obstacle
                    skNode.physicsBody?.contactTestBitMask = colliderType.airplane
                    skNode.physicsBody?.collisionBitMask = colliderType.obstacle
                    skNode.physicsBody?.isDynamic = false
                }
                    
            }
        
        collisionLampu = self.childNode(withName: "collisionLampu") as! SKSpriteNode
        enumerateChildNodes(withName: "collisionLampu") { (node, stop) in
                if let skNode = node as? SKSpriteNode{
                    skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.size)
                    skNode.physicsBody!.affectedByGravity = false
                    skNode.physicsBody?.categoryBitMask = colliderType.obstacle
                    skNode.physicsBody?.contactTestBitMask = colliderType.airplane
                    skNode.physicsBody?.collisionBitMask = colliderType.obstacle
                    skNode.physicsBody?.isDynamic = false
                }
                    
            }
        
        rightRoad = self.childNode(withName: "rightRoad") as! SKSpriteNode
        enumerateChildNodes(withName: "rightRoad") { (node, stop) in
            if let skNode = node as? SKSpriteNode{
                skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.size)
                skNode.physicsBody!.affectedByGravity = false
                skNode.physicsBody?.categoryBitMask = colliderType.obstacle
                skNode.physicsBody?.contactTestBitMask = colliderType.airplane
                skNode.physicsBody?.collisionBitMask = colliderType.obstacle
                skNode.physicsBody?.isDynamic = false
                skNode.isHidden = true
            }
        }
        
        wrongRoad = self.childNode(withName: "wrongRoad") as! SKSpriteNode
        enumerateChildNodes(withName: "wrongRoad") { (node, stop) in
            if let skNode = node as? SKSpriteNode{
                skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.size)
                skNode.physicsBody!.affectedByGravity = false
                skNode.physicsBody?.categoryBitMask = colliderType.obstacle
                skNode.physicsBody?.contactTestBitMask = colliderType.airplane
                skNode.physicsBody?.collisionBitMask = colliderType.obstacle
                skNode.physicsBody?.isDynamic = false
                skNode.isHidden = true
            }
        }
        
        //MARK: HIDDEN TRIGGER
        hiddenTrigger = self.childNode(withName: "hiddenTrigger") as! SKSpriteNode
        enumerateChildNodes(withName: "hiddenTrigger") { (node, stop) in
            if let skNode = node as? SKSpriteNode{
                skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.size)
                skNode.physicsBody!.affectedByGravity = false
                skNode.physicsBody?.categoryBitMask = colliderType.obstacle
                skNode.physicsBody?.contactTestBitMask = colliderType.airplane
                skNode.physicsBody?.collisionBitMask = colliderType.obstacle
                skNode.physicsBody?.isDynamic = false
                skNode.isHidden = true
                }
            }
               
        konstruksi = self.childNode(withName: "konstruksi") as! SKSpriteNode
            enumerateChildNodes(withName: "konstruksi") { (node, stop) in
            if let skNode = node as? SKSpriteNode{
                skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.size)
                skNode.physicsBody!.affectedByGravity = false
                skNode.physicsBody?.categoryBitMask = colliderType.obstacle
                skNode.physicsBody?.contactTestBitMask = colliderType.airplane
                skNode.physicsBody?.collisionBitMask = colliderType.obstacle
                skNode.physicsBody?.isDynamic = false
                }
            }
        
        finish = self.childNode(withName: "finish") as! SKSpriteNode
        finish.physicsBody = SKPhysicsBody(rectangleOf: finish.size)
        finish.physicsBody!.affectedByGravity = false
        finish.physicsBody?.categoryBitMask = colliderType.obstacle
        finish.physicsBody?.contactTestBitMask = colliderType.airplane
        finish.physicsBody?.collisionBitMask = colliderType.obstacle
        finish.physicsBody?.isDynamic = false
        finish.isHidden = true
        
        border = self.childNode(withName: "border") as! SKSpriteNode
        enumerateChildNodes(withName: "border") { (node, stop) in
            if let skNode = node as? SKSpriteNode{
                skNode.physicsBody = SKPhysicsBody(rectangleOf: skNode.size)
                skNode.physicsBody!.affectedByGravity = false
                skNode.physicsBody?.categoryBitMask = colliderType.border
                skNode.physicsBody?.contactTestBitMask = colliderType.airplane
                skNode.physicsBody?.collisionBitMask = colliderType.border
                skNode.physicsBody?.isDynamic = false
                }
            }
    
        //MARK: INIT CAMERA NODE AND ADD BUTTONS TO CAMERA
        cameraNode = SKCameraNode()
        
        self.addChild(cameraNode)
        camera = cameraNode
        
        cameraNode.addChild(gas)
        cameraNode.addChild(brake)
        cameraNode.addChild(speedometer)
        
        camera?.position.x = size.width/2
        camera?.position.y = size.height/2
        
        gas.position = CGPoint(x: 435, y: -180)
        brake.position = CGPoint(x: -435, y: -180)
        speedometer.position = CGPoint(x: -440, y: 50)
        
        //MARK: INIT PLAYER
        airplane = SKSpriteNode(imageNamed: "Mobil 1")
        
        airplane.physicsBody = SKPhysicsBody(rectangleOf: airplane.size)
        airplane.zPosition = 2
        airplane.name = "airplane"
        airplane.physicsBody?.isDynamic = true
        airplane.physicsBody?.affectedByGravity = false
        airplane.physicsBody?.friction = 0.5
        airplane.physicsBody?.mass = 1
        airplane.physicsBody?.angularDamping = 0.1
        airplane.physicsBody?.linearDamping = 0.1
        
        airplane.position = CGPoint(x: frame.size.width/2-275, y: frame.size.height/2)
        
        airplane.physicsBody?.categoryBitMask = colliderType.airplane
        airplane.physicsBody?.collisionBitMask = colliderType.obstacle
        airplane.physicsBody?.collisionBitMask = colliderType.border
        airplane.physicsBody?.contactTestBitMask = colliderType.obstacle
        
        self.addChild(airplane)
        
        //MARK: CHECK ACCELEROMETER AND LOGIC OF ACCELEROMETER
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
             
            motionManager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = self.motionManager.accelerometerData else { return }
                if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
                    self.airplane.physicsBody?.applyForce(CGVector(dx: -100 * CGFloat(data.acceleration.y), dy: 0))
                 } else {
                    self.airplane.physicsBody?.applyForce(CGVector(dx: 100 * CGFloat(data.acceleration.y), dy: 0))
                 }
            }
        }
    }
    
    //MARK: WHEN THERE'S TOUCH, DO THIS:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //IF GAS IS TAPPED, INCREASE FORCE, IF BRAKE, DECREASE FORCE
        for touch in touches{
            let location = touch.location(in: cameraNode)
            if gas.contains(location){
                isGassing = true
                
            }else if brake.contains(location){
                isBraking = true
            }
        }
    }
    
    //MARK: WHEN TOUCH STOP, DO THIS:
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //MAKE NEUTRAL AND STOP GAS/BRAKE
        isBraking = false
        isGassing = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        
         //MARK: TIAP 500 COUNTER, RESET COUNTER DAN UPDATE LAMPU MERAH
        someCounter += 1
        if someCounter == 500{
            if isGreen == false{
                isGreen = true
                lampuMerah.texture = SKTexture(image: #imageLiteral(resourceName: "Lampu lau lintas (Ijo)"))
            }else if isGreen == true{
                isGreen = false
                lampuMerah.texture = SKTexture(image: #imageLiteral(resourceName: "Lampu lau lintas (Merah)"))
            }
            
            someCounter = 0
        }
        
        if !(airplane.physicsBody?.velocity.dy.isLessThanOrEqualTo(20))!{
            guard let data = motionManager.accelerometerData else { return }
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                if (airplane.physicsBody?.velocity.dx)! > CGFloat(30) || (airplane.physicsBody?.velocity.dx)! < CGFloat(-30) {
                    airplane.physicsBody?.applyForce(CGVector(dx: 150 * CGFloat(data.acceleration.y), dy: -2))
                }
                airplane.physicsBody?.applyForce(CGVector(dx: 90 * CGFloat(data.acceleration.y), dy: -2))
             } else {
                if (airplane.physicsBody?.velocity.dx)! > CGFloat(30) || (airplane.physicsBody?.velocity.dx)! < CGFloat(-30) {
                    airplane.physicsBody?.applyForce(CGVector(dx: -150 * CGFloat(data.acceleration.y), dy: -2))
                }
                airplane.physicsBody?.applyForce(CGVector(dx: -90 * CGFloat(data.acceleration.y), dy: -2))
             }
        }
    
        let speedOfAirplane = Int(airplane.physicsBody?.velocity.dy ?? 100)/4
        //MARK: GET AIRPLANE SPEED AND CHECK FOR SPEED LIMIT
        if checkSpeed(speed: speedOfAirplane) == true{
            speedometer.fontColor = .black
        }else{
            speedometer.fontColor = .red
        }
        speedometer.text = "\(speedOfAirplane) km/h"
        
        //MARK: CHECK FOR GAS AND BRAKE
        if isBraking == true{
//            print("isbraking")
            if (airplane.physicsBody?.velocity.dy.isLessThanOrEqualTo(0))!{
                //IF BRAKING AND SPEED IS 0 OR LESS, MAKE IT STOP
                airplane.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }else{
                if Int((airplane.physicsBody?.velocity.dx)!) > 0{
                    airplane.physicsBody?.applyForce(CGVector(dx: -25, dy: -60))
                }else if Int((airplane.physicsBody?.velocity.dx)!) < 0{
                    airplane.physicsBody?.applyForce(CGVector(dx: 25, dy: -60))
                }else{
                    airplane.physicsBody?.applyForce(CGVector(dx: 0, dy: -60))
                }
            }
        }else if isGassing == true{
//            print("isgassing")
            airplane.physicsBody?.applyForce(CGVector(dx: 0, dy: 40))
        }
        
        
        //MARK: UPDATE CAMERA POSITION TO FOLLOW PLAYER
        cameraNode.position.y = airplane.position.y+210
    }

    //MARK: START CONTACT TRIGGER
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "airplane"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
         if firstBody.node?.name == "airplane" && secondBody.node?.name == "garisLurus"{
            print("kontak garis lurus")
            score -= 10
        }
        
        if firstBody.node?.name == "airplane" && secondBody.node?.name == "collisionLampu"{
            print(isGreen)
            if isGreen == false{
                print("not green")
                score -= 10
            }else{
                print("safe")
            }
        }
        
        if firstBody.node?.name == "airplane" && secondBody.node?.name == "rightRoad"{
            print("jalur benar")
        }
        
        if firstBody.node?.name == "airplane" && secondBody.node?.name == "wrongRoad"{
            print("jalur salah")
        }
        
        if firstBody.node?.name == "airplane" && secondBody.node?.name == "hiddenTrigger"{
            print("speed bump")
            numberOfContact += 1
            switch numberOfContact {
            case 1:
                maxSpeed = 60
            case 2:
                maxSpeed = 200
            case 3:
                maxSpeed = 60
            case 4:
                maxSpeed = 80
            default:
                return
            }
        }

        if firstBody.node?.name == "airplane" && secondBody.node?.name == "konstruksi"{
            print("jduar")
            print(score)
            score -= 30
            if score < 0{
                score = 0
            }
            DatabaseHandler.updateScoreSection3Data(scoreSection3: Int(score))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doaSegue"), object: nil)
        }
        
        if firstBody.node?.name == "airplane" && secondBody.node?.name == "finish"{
            print("yay")
            print(score)
            if score < 0{
                score = 0
            }
            DatabaseHandler.updateScoreSection3Data(scoreSection3: Int(score))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doaSegue"), object: nil)
        }
        
        if firstBody.node?.name == "airplane" && secondBody.node?.name == "border"{
            print("this is a border")
            //MARK: SIAPA TAU MAU DIMINUS
//            score -= 10
        }
    }
    
    //MARK: CHECK SPEED LIMIT
    func checkSpeed(speed:Int)->Bool{
        if speed > maxSpeed{
            score -= 0.1
            return false
        }else if speed < minSpeed{
            score -= 0.1
            return false
        }
        return true
    }
}
