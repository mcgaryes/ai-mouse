//
//  AnalogStick.swift
//  Joystick
//
//

import SpriteKit

//MARK: AnalogJoystickData

public struct AnalogJoystickData
{
    
    var velocity = CGPoint.zero,
    angular = CGFloat(0)
    
    mutating func reset() {
        velocity = CGPoint.zero
        angular = 0
    }
}

//MARK: - AnalogJoystickComponent

open class AnalogJoystickComponent: SKSpriteNode
{
    
    private var kvoContext = UInt8(1)
    var borderWidth = CGFloat(0) { didSet { redrawTexture() } }
    var borderColor = UIColor.black { didSet { redrawTexture() } }
    var image: UIImage? { didSet { redrawTexture() } }
    
    var diameter: CGFloat {
        get { return max(size.width, size.height) }
        set { size = CGSize(width: newValue, height: newValue) }
    }
    
    var radius: CGFloat {
        
        get { return diameter / 2 }
        set { diameter = newValue * 2 }
    }
    
    init(diameter: CGFloat, color: UIColor? = nil, image: UIImage? = nil) { // designated
        
        super.init(texture: nil, color: color ?? UIColor.black, size: CGSize(width: diameter, height: diameter))
        
        addObserver(self, forKeyPath: "color", options: NSKeyValueObservingOptions.old, context: &kvoContext) // listen color changes
        
        
        self.diameter = diameter
        self.image = image
        self.alpha = 0.25
        redrawTexture()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "color")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        redrawTexture()
    }
    
    private func redrawTexture() {
        
        guard diameter > 0 else {
            texture = nil
            print("Diameter should be more than zero")
            return
        }
        
        let scale = UIScreen.main.scale,
        needSize = CGSize(width: self.diameter, height: self.diameter)
        UIGraphicsBeginImageContextWithOptions(needSize, false, scale)
        let rectPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: needSize))
        rectPath.addClip()
        
        color.set()
        rectPath.fill()
        
        if let img = image {
            img.draw(in: CGRect(origin: CGPoint.zero, size: needSize), blendMode: .normal, alpha: 1)
        }
        
        let needImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        texture = SKTexture(image: needImage)
    }
}

//MARK: - AnalogJoystick

open class AnalogJoystick: SKNode
{

    // ============================================================
    // === Internal API ===========================================
    // ============================================================
    
    // MARK: Internal Properties
    
    var trackingHandler: ((AnalogJoystickData) -> ())?
    var startHandler: (() -> Void)?
    var stopHandler: (() -> Void)?
    var substrate: AnalogJoystickComponent!
    var stick: AnalogJoystickComponent!
    
    // MARK: Internal Compiled Properties
    
    var disabled: Bool {
        get { return !isUserInteractionEnabled }
        set {
            isUserInteractionEnabled = !newValue
            if newValue {
                resetStick()
            }
        }
    }
    
    var diameter: CGFloat {
        get { return substrate.diameter }
        set {
            stick.diameter += newValue - diameter
            substrate.diameter = newValue
        }
    }
    
    var radius: CGFloat {
        get { return diameter / 2 }
        set { diameter = newValue * 2 }
    }
    
    // MARK: Internal Methods
    
    init(withSize size:CGSize)
    {
        super.init()
        
        substrate = AnalogJoystickComponent(diameter: size.width, color: UIColor.black, image: nil)
        substrate.isUserInteractionEnabled = false
        substrate.zPosition = 0
        addChild(substrate)
        
        stick = AnalogJoystickComponent(diameter: size.width/2, color: UIColor.black, image: nil)
        stick.zPosition = substrate.zPosition + 1
        addChild(stick)
        
        disabled = false
        let velocityLoop = CADisplayLink(target: self, selector: #selector(listen))
        velocityLoop.add(to: RunLoop.current, forMode: RunLoopMode(rawValue: RunLoopMode.commonModes.rawValue))
        
    }
    
    convenience override init()
    {
        self.init(withSize: CGSize(width: 0.0, height: 0.0))
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func listen()
    {
        if tracking {
            trackingHandler?(data)
        }
    }
    
    //MARK: Internal Overrides
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first, stick == atPoint(touch.location(in: self)) {
            tracking = true
            startHandler?()
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches {
            
            let location = touch.location(in: self)
            
            guard tracking else {
                return
            }
            
            let maxDistantion = substrate.radius,
            realDistantion = sqrt(pow(location.x, 2) + pow(location.y, 2)),
            needPosition = realDistantion <= maxDistantion ? CGPoint(x: location.x, y: location.y) : CGPoint(x: location.x / realDistantion * maxDistantion, y: location.y / realDistantion * maxDistantion)
            stick.position = needPosition
            data = AnalogJoystickData(velocity: needPosition, angular: -atan2(needPosition.x, needPosition.y))
        }
        
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        resetStick()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        resetStick()
    }
    
    // ============================================================
    // === Private  API ===========================================
    // ============================================================
    
    // MARK: Private Properties
    
    private var tracking = false
    private(set) var data = AnalogJoystickData()
    
    // MARK: Private Methods
    
    private func resetStick()
    {
        tracking = false
        let moveToBack = SKAction.move(to: CGPoint.zero, duration: TimeInterval(0.1))
        moveToBack.timingMode = .easeOut
        stick.run(moveToBack)
        data.reset()
        stopHandler?();
    }
}
