/*:
# Preparation
 
I am Captain Rogerio. I realized that I still don't know your name, maybe it's time to introduce yourself.
*/

var name: String = /*#-editable-code*/"Your Name"/*#-end-editable-code*/
 
/*:
 Now that we’ve introduced ourselves, we’ll check what the predictions (forecast) are for today.
 * People represents how many people were simultaneously in your field of vision;
 * Time represents how many seconds you must endure to be victorious in your shift.

 The greater the number of people in a space, the greater are the chances of contamination.
 
 NOTE: Play with a different number of people to check the effects that this has on the spread of the virus.
 */
// A good number of peoples is 15, but you can try other value between 5 and 25.
//#-code-completion(everything, hide)
//#-code-completion(literal, show, integer)
var peoples: Int = /*#-editable-code*/<#T##peoples##Int#>/*#-end-editable-code*/

// A good time is 60 seconds, but you can try other value between 20 and 60.
var seconds: Int = /*#-editable-code*/<#T##seconds##Int#>/*#-end-editable-code*/
/*:
 # Rules:
 
 1. Everyone who is not wearing a mask should be clicked to put on your mask (😀 -> 😷).
 1. Masked people will take your mask off if they spend a lot of time close to people who are not wearing mask (😷 -> 😀).
 1. People without masks can become contaminated and thus do not put the mask on until they are cured (😀 -> 🤢).
 1. If you call the attention of people wearing masks, they get sad and end up crying. When they are crying they can't wear mask(😷 -> 😭).
 1. If everyone is wearing a mask, the ICU occupancy rate decreases and so people end up feeling safe to remove the mask gradually (😷 -> 😀))

 1. Our goal is to prevent the ICU's from becoming overcrowded, if that happens, we will be defeated. Hold on until the end of the shift without filling the ICU and come out victorious.

 When you are ready, click on Run My Code

 NOTE: When you run the code it enters FullScreen.


 * All audios were produced by me using GarageBand.
 * I hope you enjoyed the experience, I did with a lot of love :)
 
 Stay home, stay safe.
 */

//#-hidden-code
import SpriteKit
import PlaygroundSupport
import BookCore
import UIKit

let skView = SKView(frame: .zero)

let gameScene = GameScene(size: UIScreen.main.bounds.size, name: name, peoples: peoples, seconds: seconds)
gameScene.scaleMode = .aspectFit

skView.presentScene(gameScene)
skView.preferredFramesPerSecond =  60

PlaygroundPage.current.liveView = skView
PlaygroundPage.current.wantsFullScreenLiveView = true
//#-end-hidden-code




