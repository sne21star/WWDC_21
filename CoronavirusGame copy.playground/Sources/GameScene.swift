
import SpriteKit
import UIKit
import AVKit
import PlaygroundSupport

public class GameScene: SKScene, SKPhysicsContactDelegate{
    //Constants 
    let numberofAntigenOnScreen = 5
    let numberofAntibodies = 5
    let numberofBloodCells = 4
    
    var antigenSpeed: Int = 20
    var distance: CGFloat = 1.5 
    
    var antibody :[SKSpriteNode] = [SKSpriteNode]()
    var antigen :[SKSpriteNode] = [SKSpriteNode]()
    var bloodcell :[SKSpriteNode] = [SKSpriteNode]()
    
    var antibody_1 : SKSpriteNode! = nil 
    var antibody_2 : SKSpriteNode! = nil     
    var antibody_3 : SKSpriteNode! = nil     
    var antibody_4 : SKSpriteNode! = nil     
    var vaccine : SKSpriteNode! = nil     
    
    
    var antibody1_texture: [SKTexture] = [SKTexture(image:#imageLiteral(resourceName: "green_anitbody-1 (dragged).tiff") ?? #imageLiteral(resourceName: "green_anitbody-1 (dragged).tiff")), SKTexture(image:#imageLiteral(resourceName: "green_anitbody-2 (dragged).tiff") ?? #imageLiteral(resourceName: "green_anitbody-1 (dragged).tiff"))]
    var antibody2_texture: [SKTexture] = [SKTexture(image:#imageLiteral(resourceName: "yellow_anitbody-1 (dragged).tiff") ?? #imageLiteral(resourceName: "yellow_anitbody-1 (dragged).tiff")), SKTexture(image:#imageLiteral(resourceName: "yellow_anitbody-2 (dragged).tiff") ?? #imageLiteral(resourceName: "yellow_anitbody-1 (dragged).tiff"))]
    var antibody3_texture: [SKTexture] = [SKTexture(image:#imageLiteral(resourceName: "purple_anitbody-2 (dragged).tiff") ?? #imageLiteral(resourceName: "purple_anitbody-2 (dragged).tiff")), SKTexture(image:#imageLiteral(resourceName: "purple_anitbody-1 (dragged).tiff") ?? #imageLiteral(resourceName: "purple_anitbody-2 (dragged).tiff"))]
    var antibody4_texture: [SKTexture] = [SKTexture(image:#imageLiteral(resourceName: "gifAntibody_1-1 (dragged).tiff") ?? #imageLiteral(resourceName: "gifAntibody_1-1 (dragged).tiff")), SKTexture(image:#imageLiteral(resourceName: "gifAntibody_1-6 (dragged).tiff") ?? #imageLiteral(resourceName: "gifAntibody_1-1 (dragged).tiff"))]
    var vaccine_texture: [SKTexture] = [SKTexture(image:#imageLiteral(resourceName: "vaccine-1 (dragged).tiff") ?? #imageLiteral(resourceName: "vaccine-1 (dragged).tiff")), SKTexture(image:#imageLiteral(resourceName: "vaccine-2 (dragged).tiff") ?? #imageLiteral(resourceName: "1__#$!@%!#__vaccine-1 (dragged).tiff"))]
    

    var gameOver = false
    var movingAntiBody = false
    var movingAntiBody_1 = false
    var movingAntiBody_2 = false
    var movingAntiBody_3 = false
    var movingAntiBody_4 = false
    var moving_Vaccine = false
    
    var offset: CGPoint!
    var logoImages: [UIImage] = [#imageLiteral(resourceName: "antigen_green.png"),#imageLiteral(resourceName: "antigen_yellow.png"),#imageLiteral(resourceName: "antigen_purple.png"),#imageLiteral(resourceName: "antigen_blue.png"),#imageLiteral(resourceName: "coronavirus_green.png"),#imageLiteral(resourceName: "coronaviruses.png")]

    var points = 50 
    let scoreLabel = SKLabelNode()
    
    var antibody_1_pos = CGFloat()
    var antibody_2_pos = CGFloat()
    var antibody_3_pos = CGFloat()
    var antibody_4_pos = CGFloat()
    var vaccine_pos = CGFloat()
    var y_node_pos = CGFloat()
    
    
    public var remove_GameLabel =  SKAction.removeFromParent()
    public var gameOverLbl: SKLabelNode! = nil 
    let soundAction = SKAction.playSoundFileNamed("virus.mp3", waitForCompletion: false)
    let corona_bloodCell = SKAction.playSoundFileNamed("coronavirus_bloodCell.mp3", waitForCompletion: false)
    let antigen_antibody = SKAction.playSoundFileNamed("antibody_antigen.mp3", waitForCompletion: false)
    let vaccine_corona = SKAction.playSoundFileNamed("vaccine_corona.mp3", waitForCompletion: false)
    let virus_bloodCell = SKAction.playSoundFileNamed("antigen_bloodCell.mp3", waitForCompletion: false)
    let win_game = SKAction.playSoundFileNamed("win_game.mp3", waitForCompletion: false)
    let lose_game = SKAction.playSoundFileNamed("lose_game.mp3", waitForCompletion: false)
    
    let music = SKAction.playSoundFileNamed("backgroundMusic.mp3", waitForCompletion: true)
    
    let music_stop = SKAction.stop()
    let music_start = SKAction.play()
    let close_fail = SKAction.playSoundFileNamed("20Points.mp3", waitForCompletion: false)
    
    var timer:Timer?
    var timeLeft = 120
    let timeLabel = SKLabelNode()
    
    public override func sceneDidLoad() {
        super.sceneDidLoad()
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 50, y:  self.frame.height-50)
        scoreLabel.text = String(points)
        self.addChild(scoreLabel)
        antibody_1_pos = self.frame.midX-130
        antibody_2_pos = self.frame.midX-65
        antibody_3_pos = self.frame.midX+65
        antibody_4_pos = self.frame.midX+130
        vaccine_pos = self.frame.midX+180
        y_node_pos = 45.0
        
        distance /= 2
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        physicsWorld.contactDelegate = self
        
        //Background
        let bg = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "Screen Shot 2021-04-13 at 10.28.12 PM.png") ))
        
        bg.setScale(0.45)
        bg.zPosition = -10
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bg)
        createTimerLabel()
        
        self.run(music, completion: triggerGameOver)
    }
    
    func createTimerLabel(){
        timeLabel.fontSize = 40
        timeLabel.position = CGPoint(x: 400, y:  self.frame.height-50)
        timeLabel.text = "2:00"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,  selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        addChild(timeLabel)
        
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        var value1 = String(timeLeft / 60) + ":"
        var value2 = 0
        if(timeLeft > 59){
            value2 = abs(timeLeft - 60)
        }
        else{
            value2 = timeLeft
        }
        
        if(value2 < 10){
            value1 += "0" + String(value2)
        }
        else{
            value1 += String(value2)
        }
        
        timeLabel.text = value1
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
        }
    }
    
    public func startingPoints(){
        points = 50
    }
    public func remove_Nodes(){
        for node in self.children{
            if(node.name == "antigen"){
                node.removeFromParent()
            }
        }
    }
    
    public func resestButton(){
        antibody_1_pos = self.frame.midX-130
        antibody_2_pos = self.frame.midX-55
        antibody_3_pos = self.frame.midX+55
        antibody_4_pos = self.frame.midX+130
        vaccine_pos = self.frame.midX+180
        y_node_pos = 45.0
        antibody_1.position = CGPoint(x: antibody_1_pos, y: y_node_pos)
        antibody_2.position = CGPoint(x: antibody_2_pos, y: y_node_pos)
        antibody_3.position = CGPoint(x: antibody_3_pos, y: y_node_pos)
        antibody_4.position = CGPoint(x: antibody_4_pos, y: y_node_pos)
        vaccine.position = CGPoint(x: vaccine_pos, y: y_node_pos)
    }
    func moveAntigen(point: CGFloat, containerSize: CGFloat) -> CGFloat{
        return point + positionWithin(range: 0.95, containerSize: containerSize)
    }
    
    func positionWithin(range: CGFloat, containerSize: CGFloat) -> CGFloat{
        let partA = CGFloat(arc4random_uniform(100)) / 100.0
        let partB = (containerSize * range + (containerSize * (1.0 - range) * 0.5))
        return partA * partB
    }
    
    func distanceFrom(posA: CGPoint, posB: CGPoint) -> CGFloat {
        let x_2 = (posA.x - posB.x) * (posA.x - posB.x)
        let y_2 = (posA.y - posB.y) * (posA.y - posB.y)
        return sqrt(x_2 + y_2)
    }
    public override func didMove(to view: SKView) {
        antibody_1 = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "green_anitbody-1 (dragged).tiff")), color: .clear, size: CGSize(width: size.width * 0.075, height: size.height * 0.1))
        antibody_2 = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "yellow_anitbody-1 (dragged).tiff")), color: .clear, size: CGSize(width: size.width * 0.075, height: size.height * 0.1))
        antibody_3 = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "purple_anitbody-2 (dragged).tiff")), color: .clear, size: CGSize(width: size.width * 0.075, height: size.height * 0.1))
        antibody_4 = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "gifAntibody_1-1 (dragged).tiff")), color: .clear, size: CGSize(width: size.width * 0.075, height: size.height * 0.1))
        vaccine = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "vaccine.png")), color: .clear, size: CGSize(width: size.width * 0.075, height: size.height * 0.1))
        antibody_1.run(SKAction.repeatForever(SKAction.animate(with: antibody1_texture, timePerFrame: 0.1, resize: false, restore: true)))
        antibody_2.run(SKAction.repeatForever(SKAction.animate(with: antibody2_texture, timePerFrame: 0.1, resize: false, restore: true)))
        antibody_3.run(SKAction.repeatForever(SKAction.animate(with: antibody3_texture, timePerFrame: 0.1, resize: false, restore: true)))
        antibody_4.run(SKAction.repeatForever(SKAction.animate(with: antibody4_texture, timePerFrame: 0.1, resize: false, restore: true)))
        vaccine.run(SKAction.repeatForever(SKAction.animate(with: vaccine_texture, timePerFrame: 0.1, resize: false, restore: true)))
        
        antibody.append(antibody_1)
        antibody.append(antibody_2)
        antibody.append(antibody_3)
        antibody.append(antibody_4)
        antibody.append(vaccine)
        
        antibody_1.position = CGPoint(x: antibody_1_pos, y: y_node_pos)
        antibody_2.position = CGPoint(x: antibody_2_pos, y: y_node_pos)
        antibody_3.position = CGPoint(x: antibody_3_pos, y: y_node_pos)
        antibody_4.position = CGPoint(x: antibody_4_pos, y: y_node_pos)
        vaccine.position = CGPoint(x: vaccine_pos, y: y_node_pos)
        
        addChild(antibody_1)
        addChild(antibody_2)
        addChild(antibody_3)
        addChild(antibody_4)
        addChild(vaccine)
        
        var xPosition = 100
        for x in 1...numberofBloodCells{
            
            var bloodCell = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "bloodCell_Face.png")), color: .clear, size: CGSize(width: size.width * 0.05, height: size.height * 0.1))
            bloodCell.position = CGPoint(x: xPosition, y: 500)
            bloodCell.addBounds(radius: bloodCell.size.width * 0.75, edgeColor: .blue, filled: true)
            bloodCell.physicsBody =  SKPhysicsBody(circleOfRadius: bloodCell.size.width * (0.5))
            bloodCell.physicsBody?.isDynamic = false
            bloodCell.physicsBody?.contactTestBitMask = Bitmasks.coronavirus
            bloodCell.physicsBody?.categoryBitMask = Bitmasks.bloodCell
            bloodCell.name = "bloodCell"
            addChild(bloodCell)
            xPosition += 250
            bloodcell.append(bloodCell)
        }
        for x in 1...numberofAntibodies{
            antibody[x-1].physicsBody =  SKPhysicsBody(circleOfRadius: antibody_4.size.width * (0.5))
            antibody[x-1].physicsBody?.isDynamic = false
            
            if(x == 1){
                antibody[x-1].physicsBody?.categoryBitMask = Bitmasks.antibody_1
                antibody[x-1].physicsBody?.contactTestBitMask = Bitmasks.antigen_1
            }
            if(x == 2){
                antibody[x-1].physicsBody?.categoryBitMask = Bitmasks.antibody_2
                antibody[x-1].physicsBody?.contactTestBitMask = Bitmasks.antigen_2
            }
            if(x == 3){
                antibody[x-1].physicsBody?.categoryBitMask = Bitmasks.antibody_3
                antibody[x-1].physicsBody?.contactTestBitMask = Bitmasks.antigen_3
            }
            if(x == 4){
                antibody[x-1].physicsBody?.categoryBitMask = Bitmasks.antibody_4
                antibody[x-1].physicsBody?.contactTestBitMask = Bitmasks.antigen_4
            }
            
            if(x == 5){
                antibody[x-1].physicsBody?.categoryBitMask = Bitmasks.vaccine
                antibody[x-1].physicsBody?.contactTestBitMask = Bitmasks.coronavirus
            }
            
        }
        
        for _ in 1...numberofAntigenOnScreen{
            createAntigen()
        }
        
    }
    
    func createAntigen(){
        var value = Int.random(in: 0..<6)
        var virus = SKSpriteNode(texture: SKTexture(image:logoImages[value]), color: .clear, size: CGSize(width: size.width * 0.1, height: size.height * 0.08))
        
        var x_position = Int.random(in: 100..<Int(frame.width)-100)
        var y_position = Int.random(in: 100..<Int(frame.height)-100)
        virus.position = CGPoint(x: x_position, y: y_position)
        addChild(virus)
        antigen.append(virus)
        
        virus.physicsBody = SKPhysicsBody(circleOfRadius: virus.size.width * (0.5))
        virus.physicsBody?.affectedByGravity = false
        virus.physicsBody?.friction = 0
        virus.physicsBody?.angularDamping = 0
        virus.physicsBody?.restitution = 1.1
        virus.physicsBody?.allowsRotation = true
        virus.physicsBody?.applyImpulse(CGVector(dx: CGFloat(arc4random_uniform(UInt32(antigenSpeed))) - (CGFloat(antigenSpeed)), dy:CGFloat(arc4random_uniform(UInt32(antigenSpeed))) - (CGFloat(antigenSpeed))))
        virus.name = "antigen"
        virus.physicsBody?.isDynamic = true
        if((value+1) == 1){
            virus.physicsBody?.categoryBitMask = Bitmasks.antigen_1
            virus.physicsBody?.contactTestBitMask = Bitmasks.antibody_1
        }
        if((value+1) == 2){
            virus.physicsBody?.categoryBitMask = Bitmasks.antigen_2
            virus.physicsBody?.contactTestBitMask = Bitmasks.antibody_2
        }
        if((value+1) == 3){
            virus.physicsBody?.categoryBitMask = Bitmasks.antigen_3
            virus.physicsBody?.contactTestBitMask = Bitmasks.antibody_3
        }
        if((value+1) == 4){
            virus.physicsBody?.categoryBitMask = Bitmasks.antigen_4
            virus.physicsBody?.contactTestBitMask = Bitmasks.antibody_4
        }
        if((value+1) == 5 || (value+1) == 6){
            virus.physicsBody?.categoryBitMask = Bitmasks.coronavirus
            virus.physicsBody?.contactTestBitMask = Bitmasks.vaccine
        }
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver else { return }
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        for node in touchedNodes{
            if node == vaccine {
                movingAntiBody = true
                offset = CGPoint(x: touchLocation.x - vaccine.position.x, y: touchLocation.y - vaccine.position.y)
            }
            
            if node == antibody_4 {
                    movingAntiBody = true
                    offset = CGPoint(x: touchLocation.x - antibody_4.position.x, y: touchLocation.y - antibody_4.position.y)
            }
            if node == antibody_3 {
                movingAntiBody = true
                offset = CGPoint(x: touchLocation.x - antibody_3.position.x, y: touchLocation.y - antibody_3.position.y)
            }
            
            if node == antibody_2 {
                movingAntiBody = true
                offset = CGPoint(x: touchLocation.x - antibody_2.position.x, y: touchLocation.y - antibody_2.position.y)
            }
            if node == antibody_1 {
                movingAntiBody = true
                offset = CGPoint(x: touchLocation.x - antibody_1.position.x, y: touchLocation.y - antibody_1.position.y)
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver && movingAntiBody else {return}
        guard let touch = touches.first else { return}
        let touchLocation = touch.location(in: self)
        let newPlayerPosition = CGPoint(x: touchLocation.x - offset.x, y: touchLocation.y - offset.y)
        let touchedNodes = nodes(at: touchLocation)
        for node in touchedNodes{
            if node == vaccine {
                vaccine.run(SKAction.move(to: newPlayerPosition, duration: 0.001))
            }
            if node == antibody_4 {
                antibody_4.run(SKAction.move(to: newPlayerPosition, duration: 0.001))
            }
            if node == antibody_3 {
                antibody_3.run(SKAction.move(to: newPlayerPosition, duration: 0.001))
            }
            
            if node == antibody_2 {
                antibody_2.run(SKAction.move(to: newPlayerPosition, duration: 0.001))
            }
            if node == antibody_1 {
                antibody_1.run(SKAction.move(to: newPlayerPosition, duration: 0.001))
            }
        }
        
        
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingAntiBody = false
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.categoryBitMask == Bitmasks.bloodCell && contact.bodyB.categoryBitMask == Bitmasks.coronavirus)  || (contact.bodyA.categoryBitMask == Bitmasks.coronavirus && contact.bodyB.categoryBitMask == Bitmasks.bloodCell){
            points -= 15
            contact.bodyA.node!.run(corona_bloodCell)
            
            
        }
        
        if (contact.bodyA.categoryBitMask == Bitmasks.antibody_4 && contact.bodyB.categoryBitMask == Bitmasks.antigen_4) || (contact.bodyA.categoryBitMask == Bitmasks.antigen_4 && contact.bodyB.categoryBitMask == Bitmasks.antibody_4){
            points += 5
            if(contact.bodyB.categoryBitMask == Bitmasks.antigen_4){
                contact.bodyB.node!.removeFromParent()
            }
            else{
                contact.bodyA.node!.removeFromParent()
            }    
            contact.bodyA.node!.run(antigen_antibody)
            createAntigen()
        }
        else if (contact.bodyA.categoryBitMask == Bitmasks.antibody_3 && contact.bodyB.categoryBitMask == Bitmasks.antigen_3) || (contact.bodyA.categoryBitMask == Bitmasks.antigen_3 && contact.bodyB.categoryBitMask == Bitmasks.antibody_3){
            points += 5
            if(contact.bodyB.categoryBitMask == Bitmasks.antigen_3){
                contact.bodyB.node!.removeFromParent()
            }
            else{
                contact.bodyA.node!.removeFromParent()
            }    
            contact.bodyA.node!.run(antigen_antibody)
            createAntigen()
            
        }
        else if (contact.bodyA.categoryBitMask == Bitmasks.antibody_2 && contact.bodyB.categoryBitMask == Bitmasks.antigen_2) || (contact.bodyA.categoryBitMask == Bitmasks.antigen_2 && contact.bodyB.categoryBitMask == Bitmasks.antibody_2){
            points += 5
            if(contact.bodyB.categoryBitMask == Bitmasks.antigen_2){
                contact.bodyB.node!.removeFromParent()
            }
            else{
                contact.bodyA.node!.removeFromParent()
            }          
            contact.bodyA.node!.run(antigen_antibody)
            createAntigen()
            
        }
        else if (contact.bodyA.categoryBitMask == Bitmasks.antibody_1 && contact.bodyB.categoryBitMask == Bitmasks.antigen_1) || (contact.bodyA.categoryBitMask == Bitmasks.antigen_1 && contact.bodyB.categoryBitMask == Bitmasks.antibody_1){
            points += 5
            if(contact.bodyB.categoryBitMask == Bitmasks.antigen_1){
                contact.bodyB.node!.removeFromParent()
            }
            else{
                contact.bodyA.node!.removeFromParent()
            }
            contact.bodyA.node!.run(antigen_antibody)
            createAntigen()
            
        }
        else if (contact.bodyA.categoryBitMask == Bitmasks.coronavirus && contact.bodyB.categoryBitMask == Bitmasks.vaccine) || (contact.bodyA.categoryBitMask == Bitmasks.vaccine && contact.bodyB.categoryBitMask == Bitmasks.coronavirus){
            points += 20
            if(contact.bodyB.categoryBitMask == Bitmasks.coronavirus){
                contact.bodyB.node!.removeFromParent()
            }
            else{
                contact.bodyA.node!.removeFromParent()
            }
            contact.bodyA.node!.run(vaccine_corona)
            createAntigen()
            
        }
        
        scoreLabel.text = String(points)

        if(points <= 20){
            contact.bodyA.node!.run(close_fail)
        }
        

        if(points > 300){
            antigenSpeed = 40
        }
    }
    
    
    public func triggerGameOver(){
        gameOver = true 
        for thing in antigen{
            thing.physicsBody?.velocity = .zero
        }
        
        if(points < 499){
            gameOverLbl = SKLabelNode(text: "Oh no! You've been infected :( ")
            gameOverLbl.fontSize = 60.0 
            gameOverLbl.fontName = "Futura-CondensedExtraBold"
            gameOverLbl.position = CGPoint(x: frame.midX, y: frame.midY)
            gameOverLbl.zPosition = 3
            gameOverLbl.fontColor = .cyan
            run(lose_game)
            addChild(gameOverLbl)
        }
        else{
            gameOverLbl = SKLabelNode(text: "YEAH! YOU WON :)")
            gameOverLbl.fontName = "Futura-CondensedExtraBold"
            gameOverLbl.fontSize = 60.0 
            gameOverLbl.position = CGPoint(x: frame.midX, y: frame.midY)
            gameOverLbl.zPosition = 3
            gameOverLbl.fontColor = .cyan
            run(win_game)
            addChild(gameOverLbl)
        }
    }
    
}
