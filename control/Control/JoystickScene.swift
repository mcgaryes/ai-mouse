//
//  GameScene.swift
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit

protocol JoystickSceneDelegate
{
    func joystickScene(didUpdate data:(leftMotorSpeed:Double, rightMotorSpeed:Double))
}

class JoystickScene: SKScene
{
    
    // ============================================================
    // === Internal API ===========================================
    // ============================================================
    
    // MARK: Internal Properties
    
    var joystickDelegate:JoystickSceneDelegate?
    
    // MARK: Internal Methods
    
    override init(size: CGSize)
    {
        initialSize = size
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView)
    {
        
        joystick =  AnalogJoystick(withSize: CGSize(width: 240.0, height: 240.0))
        joystick.isUserInteractionEnabled = false
        backgroundColor = UIColor(netHex: 0xF2F2F2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        joystick.diameter = 240.0
        joystick.position = CGPoint(x: initialSize.width / 2.0, y: initialSize.height / 2.0)
        addChild(joystick)
        
        linearScaleX.domain = [-240.0 / 2.0, 240.0 / 2.0]
        linearScaleX.range = [-1.0, 1.0]
        
        linearScaleY.domain = [-240.0 / 2.0, 240.0 / 2.0]
        linearScaleY.range = [-255.0, 255.0]
        
        self.joystick.trackingHandler = { [weak self] data in
            
            guard let slf = self else { return }
            
            let vx = Double(data.velocity.x)
            let vy = Double(data.velocity.y)
            
            let sx = slf.linearScaleX.scale(value: vx)
            let sy = slf.linearScaleY.scale(value: vy)
            
            var lms = sy
            var rms = sy
            
            if abs(sy) > 50 {
                if sx < -0.25 {
                    lms = sy * (1 - abs(sx))
                } else if sx > 0.25 {
                    rms = sy * (1 - abs(sx))
                }
            } else {
                rms = sx * -255.0
                lms = sx * 255.0
            }
            
            if slf.previousData != (lms, rms) {
                slf.joystickDelegate?.joystickScene(didUpdate:(round(lms), round(rms)))
                slf.previousData = (lms, rms)
            }
            
        }
        
        self.joystick.stopHandler = { [weak self] () in
            
            guard let slf = self else { return }
            slf.joystickDelegate?.joystickScene(didUpdate:(0.0, 0.0))
            
        }
        
    }
    
    // MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let position = touches.first?.location(in: self) else { return }
        joystick.isUserInteractionEnabled = true
        joystick.position = CGPoint(x: position.x, y: position.y)
        joystick.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        joystick.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        joystick.isUserInteractionEnabled = false
        joystick.touchesEnded(touches, with: event)
    }
    
    // ============================================================
    // === Private API ============================================
    // ============================================================
    
    // MARK: Private Properties
    
    private var joystick:AnalogJoystick!
    private let initialSize:CGSize!
    private let linearScaleX = LinearScale()
    private let linearScaleY = LinearScale()
    private let queue = OperationQueue()
    private var previousData:(Double, Double) = (0,0)
    
}
