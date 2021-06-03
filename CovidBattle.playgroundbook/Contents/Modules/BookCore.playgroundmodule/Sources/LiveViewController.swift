//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  A source file which is part of the auxiliary module named "BookCore".
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import SpriteKit
import PlaygroundSupport

@objc(BookCore_LiveViewController)
public class LiveViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIImageView(image: UIImage(named: "gameImage"))
        view.frame = self.view.frame

        self.view = view
        
//        let view = SKView()
//        let scene = GameScene(size: UIScreen.main.bounds.size, name: "Live View", peoples: 15, seconds: 60)
//        view.presentScene(scene)
//        self.view = view
    }
    
}

extension LiveViewController: PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    /*
     public func liveViewMessageConnectionOpened() {
     // Implement this method to be notified when the live view message connection is opened.
     // The connection will be opened when the process running Contents.swift starts running and listening for messages.
     }
     */
    
    /*
     public func liveViewMessageConnectionClosed() {
     // Implement this method to be notified when the live view message connection is closed.
     // The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
     // This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
     }
     */
    
    public func receive(_ message: PlaygroundValue) {
        
    }
    
}

