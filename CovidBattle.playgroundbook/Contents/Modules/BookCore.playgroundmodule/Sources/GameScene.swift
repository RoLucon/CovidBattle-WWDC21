import SpriteKit
import Combine
import PlaygroundSupport

public class GameScene: SKScene, SKPhysicsContactDelegate, ScoreboardDelegate {
    
    var persons: [Person] = []
    
    var isOn = false
    var gameEnd = false
    var gameArea: CGRect!
    
    var numberOfPersons = 20
    let initialSpeed: UInt32 = 100
    
    var scoreboard: Scoreboard!
    
    var maxTime: Int
    
    var offsetY: CGFloat = 120
    
    lazy var timeLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = 80
        label.color = .red
        label.text = "60:00"
        label.horizontalAlignmentMode = .left
        label.name = "time node"
        return label
    }()
    
    var infectionLabel = ProgressBarNode()
    
    let audioManager = AudioManager.shared
    
    //MARK: - Intro Labels
    lazy var startBtt: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "")
        
        node.size = CGSize(width: 300, height: 200)
        return node
    }()
    
    lazy var NameLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = 80
        label.color = .red
        label.text = "Nome da pessoa"
        label.horizontalAlignmentMode = .center
        label.fontColor = .black
        return label
    }()
    
    lazy var msgLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.fontSize = 80
        label.color = .red
        label.text = "Click on screen to start"
        label.horizontalAlignmentMode = .center
        label.fontColor = .black
        return label
    }()
    
    //MARK: - Initialize
    public init(size: CGSize, name: String, peoples: Int, seconds: Int) {
        maxTime = max(min(seconds, 60),20)
        super.init(size: size)
        NameLabel.text = "\(name) is ready?"
        numberOfPersons = max(min(peoples, 20),5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        maxTime = 60
        super.init(coder: aDecoder)
    }
    
    //MARK: - Did Move
    public override func didMove(to view: SKView) {
        audioManager.play(music: .menu)
        scoreboard = Scoreboard(maxTime: maxTime)
        scoreboard.delegate = self
        
        let offsetX: CGFloat = 0
        offsetY = 120 + offsetX
        
        gameArea = CGRect(x: frame.origin.x + offsetX, y: frame.origin.y + offsetX, width: frame.width - offsetX * 2, height: frame.height - offsetY)
        physicsBody = SKPhysicsBody(edgeLoopFrom: gameArea)
        physicsBody?.friction = 0.0
        physicsWorld.contactDelegate = self
        
        //Background
        let number: Int =  Int(frame.height / 200)
        
        for i in 0...number+1 {
            let bg = RepeatSpriteNode(coverArea: CGSize(width: frame.width, height: 200),imageNamed: "grass-2", direction: .all)
            bg.zPosition = -10
            bg.position = CGPoint(x: gameArea.minX - bg.offset, y: gameArea.minY + CGFloat(200 * (i + 1)) - 200)
            addChild(bg)
        }
        
        //Walls
        let topWall = RepeatSpriteNode(coverArea: CGSize(width: frame.width, height: offsetY), imageNamed: "brickWithShadow-1.png", direction: .horizontal)
        addChild(topWall)
        topWall.position = CGPoint(x: frame.minX - topWall.offset, y: frame.maxY - topWall.calculateAccumulatedFrame().height / 2)
        topWall.zPosition = zPositions.walls
        
        // Init Labels
        addChild(NameLabel)
        NameLabel.position = CGPoint(x: frame.midX, y: frame.midY + NameLabel.frame.height / 1.50)
        
        addChild(msgLabel)
        msgLabel.position = CGPoint(x: frame.midX, y: frame.midY - msgLabel.frame.height / 1.50)
    }
    
    //MARK: - Start
    private func startGame() {
        audioManager.play(music: .game)
        //Remove labels
        NameLabel.removeFromParent()
        msgLabel.removeFromParent()
        
        //Scoreboard
        addChild(timeLabel)
        timeLabel.position = CGPoint(x: frame.minX + timeLabel.frame.width / 2 + offsetY / 4, y: frame.maxY - timeLabel.frame.height - offsetY / 4)
        timeLabel.zPosition = zPositions.text
        
        addChild(infectionLabel)
        infectionLabel.position = CGPoint(x: frame.maxX - infectionLabel.realFrame.width / 2 - offsetY, y: frame.maxY - infectionLabel.realFrame.height / 2 - offsetY / 6)
        infectionLabel.updateProgress(0)
        infectionLabel.zPosition = zPositions.text
        
        //Persons
        for _ in 0..<numberOfPersons {
            let person = Person(state: PersonState.unMasked)
            person.position = randomPosition(containerSize: person.frame.width)
            persons.append(person)
            person.name = "\(persons.count)"
            person.zPosition = zPositions.peoples
            addChild(person)
        }
        
        for person in persons {
            let vector = CGVector(dx: CGFloat(arc4random_uniform(initialSpeed)) - (CGFloat(initialSpeed) * 0.5), dy: CGFloat(arc4random_uniform(initialSpeed)) - (CGFloat(initialSpeed) * 0.5))
            
            if let body = person.physicsBody {
                body.applyImpulse(vector)
            }
        }
        
        isOn = true
        scoreboard.startCount()
    }
    
    // MARK: - Updates methods
    public override func update(_ currentTime: TimeInterval) {
        if isOn {
            timeLabel.text = scoreboard.updateTimer()
            
            scoreboard.update(persons: persons)
            
            infectionLabel.updateProgress(CGFloat(scoreboard.infectionPercent()))
            
            for i in 0..<persons.count {
                let person = persons[i]
                var flag = false
                
                for j in 0..<persons.count {
                    if i != j {
                        if person.state == .masked && persons[j].state != .masked {
                            if person.distanceTo(node: persons[j]) < person.size.width * 2 + 20 {
                                flag = true
                            }
                        }
                    }
                }
                person.effect(currentTime, inRange: flag)
            }
        }
    }
        
    public override func didSimulatePhysics() {
        for person in persons {
            person.movement()
        }
    }
    
    //MARK: - Assists in the generation 
    /// Generates a random position where not the other "person".
    /// - Parameter containerSize: the size of the person.
    private func randomPosition(containerSize: CGFloat) -> CGPoint {
        var pos: CGPoint!
        repeat {
            let x = CGFloat.random(in: containerSize...(gameArea.maxX - containerSize))
            let y = CGFloat.random(in: containerSize...(gameArea.maxY - containerSize))
            
            pos = CGPoint(x: x, y: y)
        } while(isOverlaping(position: pos, containerSize: containerSize))
        
        return pos
    }
    
    private func isOverlaping(position: CGPoint, containerSize: CGFloat) -> Bool {
        if persons.isEmpty { return false}
        
        for person in persons {
            if person.distanceTo(position: position) < containerSize * 2 {
                return true
            }
        }
        return false
    }
    
    //MARK: - Inputs
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnd {
            return
        }
        
        if !isOn {
            startGame()
        }
        
        guard isOn else { return }
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = nodes(at: touchLocation)
        
        for node in touchedNode {
            
            if let personNode = node as? Person {
                personNode.touched()
            }
            
        }
        
    }
    
    //MARK: - GameOver/EndGame/WinGame
    internal func gameOver() {
        audioManager.stop(music: .game)
        audioManager.play(effect: .loser)
        stopGame()
        let gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontSize = 90
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 1000
        gameOverLabel.fontColor = .red
        addChild(gameOverLabel)
    }
    
    internal func stopGame() {
        isOn = false
        gameEnd = true
        for person in persons {
            person.physicsBody?.velocity = .zero
        }
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) {_ in
            PlaygroundPage.current.finishExecution()
        }
    }
    
    internal func winGame() {
        audioManager.stop(music: .game)
        audioManager.play(effect: .winner)
        stopGame()
        let gameOverLabel = SKLabelNode(text: "YOU WIN")
        gameOverLabel.fontSize = 90
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 1000
        gameOverLabel.fontColor = .black
        addChild(gameOverLabel)
    }
    
    let zPositions = (background: CGFloat(0), peoples: CGFloat(1), walls: CGFloat(2), text: CGFloat(3))
}

