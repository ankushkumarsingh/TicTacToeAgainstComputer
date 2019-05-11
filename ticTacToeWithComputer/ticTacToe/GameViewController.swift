//
//  ViewController.swift
//  ticTacToe
//
//  Created by citiadmin on 5/14/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import UIKit

class GameViewController: UIViewController,GameDelegate {
  
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
  
  let defaults = UserDefaults.standard
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.squares = [UIImageView]()
    setUpSquares()
    //defaults.setInteger(yourInt, forKey: "intKey")
    let win = defaults.integer(forKey: WIN_KEY)
    let loss = defaults.integer(forKey: LOSS_KEY)
    let draw = defaults.integer(forKey: DRAW_KEY)
    
    winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
    gameController = GameController()
    gameController.delegate = self
    circleImage = UIImage(named: IMAGE_O)
    crossImage = UIImage(named: IMAGE_X)
    gameController.reset()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func computerStarts(sender: UIButton) {
    gameBoard.isUserInteractionEnabled = true
    gameController.firstMoveByPlayer = .computer
    gameController.vsComputer = true
    gameController.computerFirst = true
    gameController.status = GameStatus.start
    resetBoard()
  }
  
  @IBAction func playerStarts(sender: UIButton) {
    gameBoard.isUserInteractionEnabled = true
    gameController.firstMoveByPlayer = .you
    gameController.vsComputer = true
    gameController.computerFirst = false
    gameController.status = GameStatus.start
    resetBoard()
  }
  
  func resetBoard() {
    switch gameController.status {
    case .playing:
      self.gameController.reset()
    case .over:
      self.gameController.reset()
    case .start:
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch : UITouch = touches.first else {
      return
    }
    var index = 0
    if(s1.frame.contains(touch.location(in: self.view)))
    {
      index = 0
    }
    if(s2.frame.contains(touch.location(in: self.view)))
    {
      index = 1
    }
    if(s3.frame.contains(touch.location(in: self.view)))
    {
      index = 2
    }
    if(s4.frame.contains(touch.location(in: self.view)))
    {
      index = 3
    }
    if(s5.frame.contains(touch.location(in: self.view)))
    {
      index = 4
    }
    if(s6.frame.contains(touch.location(in: self.view)))
    {
      index = 5
    }
    if(s7.frame.contains(touch.location(in: self.view)))
    {
      index = 6
    }
    if(s8.frame.contains(touch.location(in: self.view)))
    {
      index = 7
    }
    if(s9.frame.contains(touch.location(in: self.view)))
    {
      index = 8
    }
    reloadCellAt(index)
    self.gameController.moveAt(index)
  }
  
  func reloadCellAt(_ index: Int) {
    let imageView = self.squares[index]
    let squareType = gameController.squareType(index)
    switch squareType {
    case .empty:
      imageView.image = nil
      
    case .cross:
      imageView.image = self.crossImage
      
    case .circle:
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
    let win = defaults.integer(forKey: WIN_KEY) + 1
    let loss = defaults.integer(forKey: LOSS_KEY)
    let draw = defaults.integer(forKey: DRAW_KEY)
    winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
    defaults.set(win, forKey: WIN_KEY)
  }
  
  func lossUpdateForYouAgainstComputer(){
    let win = defaults.integer(forKey: WIN_KEY)
    let loss = defaults.integer(forKey: LOSS_KEY) + 1
    let draw = defaults.integer(forKey: DRAW_KEY)
    winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
    defaults.set(loss, forKey: LOSS_KEY)
  }
  
  func drawUpdateForYouAgainstComputer(){
    let win = defaults.integer(forKey: WIN_KEY)
    let loss = defaults.integer(forKey: LOSS_KEY)
    let draw = defaults.integer(forKey: DRAW_KEY) + 1
    winAndLoss.text = String(win) + DIVIDER + String(loss) + DIVIDER + String(draw)
    defaults.set(draw, forKey: DRAW_KEY)
  }
  // MARK: GameDelegate
  func gameController(_ gameController: GameController, didMoveAtIndex: Int) {
    reloadCellAt(didMoveAtIndex)
  }
  
  func gameControllerPlayerXDidWin(_ gameController: GameController) {
    var title = ""
    if gameController.firstMoveByPlayer == .computer {
      title = YOU_LOSE
      lossUpdateForYouAgainstComputer()
    } else if gameController.firstMoveByPlayer == .you {
      title = YOU_WIN
      winUpdateForYouAgainstComputer()
    }
    UIAlertView(title: title, message: CONGRATS, delegate: nil, cancelButtonTitle: OK).show()
  }
  
  func gameControllerPlayerODidWin(_ gameController: GameController) {
    var title = ""
    if gameController.firstMoveByPlayer == .computer {
      title = YOU_WIN
      winUpdateForYouAgainstComputer()
    } else if gameController.firstMoveByPlayer == .you {
      title = YOU_LOSE
      lossUpdateForYouAgainstComputer()
    }
    UIAlertView(title: title, message: CONGRATS, delegate: nil, cancelButtonTitle: OK).show()
  }
  
  func gameControllerDidDraw(_ gameController: GameController) {
    drawUpdateForYouAgainstComputer()
    UIAlertView(title: DRAW, message: TRY_AGAIN, delegate: nil, cancelButtonTitle: OK).show()
  }
  
  func gameControllerComputerStartThinking(_ gameController: GameController) {
    gameBoard.isUserInteractionEnabled = false
  }
  
  func gameControllerComputerCompleteThinking(_ gameController: GameController) {
    gameBoard.isUserInteractionEnabled = true
  }
  
  deinit {
    print("ViewController released")
  }
  
  
}

