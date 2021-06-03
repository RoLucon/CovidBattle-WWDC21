import SpriteKit

public class Person: SKSpriteNode {
    
    var state: PersonState!
    
    var startTime: Double = 0
    var lastTime: Double = 0
    var timer: Double = 0
    
    public init (state: PersonState) {
        self.state = state
        
        let image = UIImage(named: state.imageName)
        
        let frame = UIScreen.main.bounds
        let size: CGFloat = min(frame.width, frame.height) * 0.1
        
        super.init(texture: SKTexture(image: image!),color: .clear, size: CGSize(width: size, height: size))
        
        createPhysicsBody()
        self.color = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Physics Body
    private func createPhysicsBody(){
        physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = 1
        physicsBody?.friction = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.restitution = 1.1
        physicsBody?.allowsRotation = false
    }
    
    //MARK: - Distance to
    public func distanceTo(node: SKNode) -> CGFloat {
        let x = pow(self.position.x - node.position.x, 2)
        let y = pow(self.position.y - node.position.y, 2)
        return sqrt(x + y)
    }
    
    public func distanceTo(position: CGPoint) -> CGFloat {
        let x = pow(self.position.x - position.x, 2)
        let y = pow(self.position.y - position.y, 2)
        return sqrt(x + y)
    }
    
    //MARK: - Movement
    public func movement() {
        guard let body = physicsBody else { return }
        
        let x = body.velocity.dx
        let y = body.velocity.dy
        
        let sum = abs(x + y)
        
        let xPercent = x / sum
        let yPercent = y / sum
        
        if sum < 100 {
//              body.velocity = CGVector(dx: 150 * xPercent, dy: 150 * yPercent)
        } else if sum > 700 {
            body.velocity = CGVector(dx: 300 * xPercent, dy: 300 * yPercent)
        }
    }
    
    // MARK: - Effects
    public func effect(_ currentTime: TimeInterval, inRange: Bool) {
        if lastTime == 0 {
            lastTime = currentTime
        }
        
        if timer <= 0.0 {
            timer = 0.1
        }
        
        switch state {
        case .masked:
            maskEffect(currentTime, inRange: inRange)
        case .infected:
            infectedEffect(currentTime) 
        case .vaccined:
            break
        case .unMasked:
            withoutMaskEffect(currentTime, inRange: inRange)
        case .crying:
            cryingEffect(currentTime)
        default:
            withoutMaskEffect(currentTime, inRange: inRange)
        }
        
        lastTime = currentTime
    }
    
    private func maskEffect(_ currentTime: TimeInterval, inRange: Bool) {
        if inRange {
            timer += currentTime - lastTime
        } else {
            timer -= currentTime - lastTime
        }
        
        self.colorBlendFactor = CGFloat(min(timer / 5, 1))
        
        if timer > 5 {
            self.colorBlendFactor = 0
            state = .unMasked
            texture = SKTexture(image: UIImage(named: state.imageName)!)
            resetTimer()
        }
    }
    
    private func withoutMaskEffect(_ currentTime: TimeInterval, inRange: Bool) {
        let number = Double.random(in: 0..<1)
        
        if timer > 60 && number < 0.75 {
            turnIfected()
        } else if timer > 30 && number < 0.35 {
            turnIfected()
        } else if number < 0.001 {
            turnIfected()
        }
    }
    
    private func turnIfected(){
        state = .infected
        self.colorBlendFactor = 0
        texture = SKTexture(image: UIImage(named: state.imageName)!)
        resetTimer()
    }
    
    private func infectedEffect(_ currentTime: TimeInterval) {
        timer += currentTime - lastTime
        
        if timer > 8 {
            state = .unMasked
            texture = SKTexture(image: UIImage(named: state.imageName)!)
            resetTimer()
        }
    }
    
    func turnOffMask() {
        state = .unMasked
        texture = SKTexture(image: UIImage(named: state.imageName)!)
        resetTimer()
    }
    
    private func cryingEffect(_ currentTime: TimeInterval) {
        timer += currentTime - lastTime
        
        if timer > 5 {
            state = .unMasked
            texture = SKTexture(image: UIImage(named: state.imageName)!)
            resetTimer()
        }
    }
    
    private func resetTimer() {
        timer = 0
    }
    
    //MARK: - Touched
    func touched() {
        
        if state == .unMasked {
            run(SKAction.playSoundFileNamed("ClickOk", waitForCompletion: false))
            state = .masked
            texture = SKTexture(image: UIImage(named: state.imageName)!)
            resetTimer()
        } else if state == .masked {
            run(SKAction.playSoundFileNamed("ClickErro", waitForCompletion: false))
            state = .crying
            colorBlendFactor = 0
            texture = SKTexture(image: UIImage(named: state.imageName)!)
            resetTimer()
        }
    }
}
