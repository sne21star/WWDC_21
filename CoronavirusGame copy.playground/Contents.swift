import SpriteKit
import PlaygroundSupport
import UIKit
let skView = SKView(frame: .zero)


let gameScene = GameScene(size: UIScreen.main.bounds.size)
gameScene.scaleMode = .fill

skView.presentScene(gameScene)
skView.preferredFramesPerSecond = 60

let button_reset = UIButton(frame: CGRect(x: 150, y: 40, width: 100, height: 50))
button_reset.backgroundColor = #colorLiteral(red: 0.17647058823529413, green: 0.4980392156862745, blue: 0.7568627450980392, alpha: 1.0)
button_reset.setTitle("RESET", for: .normal )
button_reset.layer.cornerRadius = 10
    /*
let start = UIButton(frame: CGRect(x: 250, y: 40, width: 100, height: 50))
start.backgroundColor = #colorLiteral(red: 0.27450980392156865, green: 0.48627450980392156, blue: 0.1411764705882353, alpha: 1.0)
start.setTitle("START", for: .normal )
start.layer.cornerRadius = 10
skView.addSubview(start)
*/
skView.addSubview(button_reset)

class reset_Responser: NSObject
{
    @objc func resetPositionOfAntibodies()
    {
        gameScene.resestButton()    
    }
}


let responder_reset = reset_Responser()
button_reset.addTarget(responder_reset, action: #selector(reset_Responser.resetPositionOfAntibodies), for:.touchUpInside)
    /*

class start_Game: NSObject
{
    @objc func resetGame()
    {
        gameScene.create_antigenSpeed()
        gameScene.startingPoints()
        gameScene.remove_Nodes()
        gameScene.gameOverLbl.run(gameScene.remove_GameLabel)
        gameScene.sceneDidLoad()
        skView.presentScene(gameScene)
    }
}

let responder_start = start_Game()
start.addTarget(responder_start, action: #selector(start_Game.resetGame), for:.touchUpInside)
 */






PlaygroundPage.current.liveView = skView
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.needsIndefiniteExecution = true



