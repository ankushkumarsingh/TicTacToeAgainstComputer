//
//  GameController.swift
//  ticTacToe
//
//  Created by citiadmin on 5/15/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation
protocol GameDelegate {
  func gameController(_ gameController: GameController, didMoveAtIndex: Int)
  func gameControllerPlayerXDidWin(_ gameController: GameController)
  func gameControllerPlayerODidWin(_ gameController: GameController)
  func gameControllerDidDraw(_ gameController: GameController)
  func gameControllerComputerStartThinking(_ gameController: GameController)
  func gameControllerComputerCompleteThinking(_ gameController: GameController)
}

enum GameStatus {
  case start, playing, over
}

enum WhoStarted {
  case computer, you
}

class GameController {
  
  var game: Game!
  var delegate: GameDelegate!
  var status: GameStatus
  var ai: AIEngine
  var firstMoveByPlayer : WhoStarted
  
  var vsComputer: Bool = true
  var computerFirst: Bool = false
  
  private var wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                      [0, 3, 6], [1, 4, 7], [2, 5, 8],
                      [0, 4, 8], [2, 4, 6]
  ]
  
  init() {
    self.game = Game(mode: .computer)
    self.status = .start
    self.firstMoveByPlayer = .computer
    self.ai = AIEngine(self.game)
  }
  
  func squareType(_ index: Int) -> SquareType {
    return game.board[index]
  }
  
  func moveAt(_ index: Int) {
    var type = SquareType.empty
    if .start == status {
      status = .playing
    }
    var player = currentPlayer()
    if player === game.playerX {
      type = .cross
    } else {
      type = .circle
    }
    game.board[index] = type
    player.moves.append(index)
    game.moves.append(index)
    
    delegate.gameController(self, didMoveAtIndex: index)
    
    if ai.isWin(&game.board) {
      if player === game.playerX {
        delegate.gameControllerPlayerXDidWin(self)
      } else {
        delegate.gameControllerPlayerODidWin(self)
      }
      
      status = .over
      return
    }
    
    if ai.isDraw() {
      delegate.gameControllerDidDraw(self)
      status = .over
      return
    }
    
    player = currentPlayer()
    
    if player.mode == .computer {
      delegate.gameControllerComputerStartThinking(self)
      ai.nextMove() { index in
        self.delegate.gameControllerComputerCompleteThinking(self)
        self.moveAt(index)
      }
      
    }
  }
  
  
  func reset() {
    status = .start
    game.reset()
    
    if vsComputer {
      game.mode = .computer
      if computerFirst {
        game.playerX.mode = .computer
        game.playerO.mode = .human
      } else {
        game.playerX.mode = .human
        game.playerO.mode = .computer
      }
    } else {
      game.mode = .player
      game.playerX.mode = .human
      game.playerO.mode = .human
    }
    
    if game.playerX.mode == .computer {
      delegate.gameControllerComputerStartThinking(self)
      ai.nextMove() { index in
        self.delegate.gameControllerComputerCompleteThinking(self)
        self.moveAt(index)
      }
      
    }
  }
  
  private func currentPlayer() -> Player {
    if game.moves.count % 2 == 0 {
      return game.playerX
    } else {
      return game.playerO
    }
  }
  
}
