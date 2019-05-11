//
//  ViewController.swift
//  ticTacToe
//
//  Created by citiadmin on 5/14/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import UIKit

class ViewController: UIViewController,GameDelegate {

    @IBOutlet weak var gameBoard: UIImageView!
    @IBOutlet weak var s1: UIImageView!
    @IBOutlet weak var s2: UIImageView!
    @IBOutlet weak var s3: UIImageView!
    @IBOutlet weak var s4: UIImageView!
    @IBOutlet weak var s5: UIImageView!
    @IBOutlet weak var s6: UIImageView!
    @IBOutlet weak var s7: UIImageView!
    @IBOutlet weak var s8: UIImageView!
    @IBOutlet weak var s9: UIImageView!
    
    @IBOutlet weak var winAndLoss: UILabel!
    
    var squares :[UIImageView]!
    var circleImage: UIImage!
    var crossImage: UIImage!
    var gameController: GameController!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.squares = [UIImageView]()
        setUpSquares()
        //defaults.setInteger(yourInt, forKey: "intKey")
        let win = defaults.integerForKey(WIN_KEY)
        let loss = defaults.integerForKey(LOSS_KEY)
        let draw = defaults.integerForKey(DRAW_KEY)

        winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
        gameController = GameController()
        gameController.delegate = self
        circleImage = UIImage(imageLiteral: IMAGE_O)
        crossImage = UIImage(imageLiteral: IMAGE_X)
        gameController.reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func computerStarts(sender: UIButton) {
        gameBoard.userInteractionEnabled = true
        gameController.firstMoveByPlayer = .Computer
        gameController.vsComputer = true
        gameController.computerFirst = true
        gameController.status = GameStatus.Start
        resetBoard()
    }
    
    @IBAction func playerStarts(sender: UIButton) {
        gameBoard.userInteractionEnabled = true
        gameController.firstMoveByPlayer = .You
        gameController.vsComputer = true
        gameController.computerFirst = false
        gameController.status = GameStatus.Start
        resetBoard()
    }

    func resetBoard() {
        switch gameController.status {
        case .Playing:
            self.gameController.reset()
        case .Over:
            self.gameController.reset()
        case .Start:
            self.gameController.reset()
            
        }
        /// clear the images stored in the UIIMageView
        s1.image = nil
        s2.image = nil
        s3.image = nil
        s4.image = nil
        s5.image = nil
        s6.image = nil
        s7.image = nil
        s8.image = nil
        s9.image = nil
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch : UITouch = touches.first else {
            return
        }
        var index = 0
        if(CGRectContainsPoint(s1.frame, touch.locationInView(self.view)))
        {
            index = 0
        }
        if(CGRectContainsPoint(s2.frame, touch.locationInView(self.view)))
        {
            index = 1
        }
        if(CGRectContainsPoint(s3.frame, touch.locationInView(self.view)))
        {
            index = 2
        }
        if(CGRectContainsPoint(s4.frame, touch.locationInView(self.view)))
        {
            index = 3
        }
        if(CGRectContainsPoint(s5.frame, touch.locationInView(self.view)))
        {
            index = 4
        }
        if(CGRectContainsPoint(s6.frame, touch.locationInView(self.view)))
        {
            index = 5
        }
        if(CGRectContainsPoint(s7.frame, touch.locationInView(self.view)))
        {
            index = 6
        }
        if(CGRectContainsPoint(s8.frame, touch.locationInView(self.view)))
        {
            index = 7
        }
        if(CGRectContainsPoint(s9.frame, touch.locationInView(self.view)))
        {
            index = 8
        }
        reloadCellAt(index)
        self.gameController.moveAt(index)
    }
    
    func reloadCellAt(index: Int) {
        let imageView = self.squares[index]
        let squareType = gameController.squareType(index)
        switch squareType {
        case .Empty:
            imageView.image = nil
            
        case .Cross:
            imageView.image = self.crossImage
            
        case .Circle:
            imageView.image = self.circleImage
        }
    }
    
    private func setUpSquares() {
        squares.append(s1)
        squares.append(s2)
        squares.append(s3)
        squares.append(s4)
        squares.append(s5)
        squares.append(s6)
        squares.append(s7)
        squares.append(s8)
        squares.append(s9)
        squares.append(s1)
    }
    
    func winUpdateForYouAgainstComputer(){
        let win = defaults.integerForKey(WIN_KEY) + 1
        let loss = defaults.integerForKey(LOSS_KEY)
        let draw = defaults.integerForKey(DRAW_KEY)
        winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
        defaults.setInteger(win, forKey: WIN_KEY)
    }
    
    func lossUpdateForYouAgainstComputer(){
        let win = defaults.integerForKey(WIN_KEY)
        let loss = defaults.integerForKey(LOSS_KEY) + 1
        let draw = defaults.integerForKey(DRAW_KEY)
        winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
        defaults.setInteger(loss, forKey: LOSS_KEY)
    }
    
    func drawUpdateForYouAgainstComputer(){
        let win = defaults.integerForKey(WIN_KEY)
        let loss = defaults.integerForKey(LOSS_KEY)
        let draw = defaults.integerForKey(DRAW_KEY) + 1
        winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
        defaults.setInteger(draw, forKey: DRAW_KEY)
    }
    // MARK: GameDelegate
    func gameController(gameController: GameController, didMoveAtIndex: Int) {
        reloadCellAt(didMoveAtIndex)
    }
    
    func gameControllerPlayerXDidWin(gameController: GameController) {
        var title = ""
        if gameController.firstMoveByPlayer == .Computer {
            title = YOU_LOSE
            lossUpdateForYouAgainstComputer()
        } else if gameController.firstMoveByPlayer == .You {
            title = YOU_WIN
            winUpdateForYouAgainstComputer()
        }
        UIAlertView(title: title, message: CONGRATS, delegate: nil, cancelButtonTitle: OK).show()
    }
    
    func gameControllerPlayerODidWin(gameController: GameController) {
        var title = ""
        if gameController.firstMoveByPlayer == .Computer {
            title = YOU_WIN
            winUpdateForYouAgainstComputer()
        } else if gameController.firstMoveByPlayer == .You {
            title = YOU_LOSE
            lossUpdateForYouAgainstComputer()
        }
        UIAlertView(title: title, message: CONGRATS, delegate: nil, cancelButtonTitle: OK).show()
    }
    
    func gameControllerDidDraw(gameController: GameController) {
        drawUpdateForYouAgainstComputer()
        UIAlertView(title: DRAW, message: TRY_AGAIN, delegate: nil, cancelButtonTitle: OK).show()
    }
    
    func gameControllerComputerStartThinking(gameController: GameController) {
        gameBoard.userInteractionEnabled = false
    }
    
    func gameControllerComputerCompleteThinking(gameController: GameController) {
        gameBoard.userInteractionEnabled = true
    }
    
    deinit {
        print("ViewController released")
    }


}

