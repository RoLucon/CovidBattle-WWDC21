//
//  SpriteNodeWithShadow.swift
//  PlaygroundBook
//
//  Created by Rogerio Lucon on 06/04/21.
//

import SpriteKit

public class RepeatSpriteNode: SKNode {
    var anchorPoint: CGPoint { CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)}
    var offset: CGFloat = 0
    private var imageNamed: String
    public override var frame: CGRect { calculateAccumulatedFrame() }
    
    init(coverArea frame: CGSize, imageNamed: String, direction: Direction) {
        self.imageNamed = imageNamed
        
        super.init()
        
        let refNode = SKSpriteNode(imageNamed: imageNamed)
        let scaleFactor = refNode.frame.width / frame.height
        let numberOfNodes: Int = Int(frame.width / (refNode.frame.width / scaleFactor))
        offset = refNode.frame.width / 2
        for i in 0...numberOfNodes + 1 {
            let node = SKSpriteNode(imageNamed: imageNamed)
            node.size = CGSize(width: node.frame.width / scaleFactor, height: node.frame.height / scaleFactor)
            self.addChild(node)
            node.position = CGPoint(x: Int(node.frame.width) * (i + 1), y: 0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func repeatNodeHorizontal(){
        let refNode = SKSpriteNode(imageNamed: imageNamed)
        let scaleFactor = refNode.frame.width / frame.height
        let numberOfNodes: Int = Int(frame.width / (refNode.frame.width / scaleFactor))
        offset = refNode.frame.width / 2
        for i in 0...numberOfNodes + 1 {
            let node = SKSpriteNode(imageNamed: imageNamed)
            node.size = CGSize(width: node.frame.width / scaleFactor, height: node.frame.height / scaleFactor)
            self.addChild(node)
            node.position = CGPoint(x: Int(node.frame.width) * (i + 1), y: 0)
        }
    }
    
}

public enum Direction {
    case horizontal, vertical, all
}
