import SpriteKit

public class ProgressBarNode: SKNode {
    
    var realFrame: CGRect!
    
    var borderNode: SKSpriteNode = { SKSpriteNode(color: .white, size: CGSize(width: 500, height: 80)) }()
    
    var barNode: SKSpriteNode = { SKSpriteNode(color: .red, size: CGSize(width: 500 - 20, height: 60)) }()
    
    public override init() {
        super.init()
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        addChild(borderNode)
        addChild(barNode)
        
        barNode.zPosition += 5
        
        barNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        barNode.position.x = -(barNode.size.width / 2) 
        
        realFrame = calculateAccumulatedFrame()
    }
    
    public func updateProgress(_ amount: CGFloat) {
        let correctAmount = min(max(0,amount),1)
        
        barNode.run(.scaleX(to: correctAmount, duration: 0.2))
    }
}
