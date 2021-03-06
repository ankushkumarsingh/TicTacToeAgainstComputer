//
//  AIEngine.swift
//  ticTacToe
//
//  Created by citiadmin on 5/15/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation

/**
 *  AI engine for computer
 *  AI algorithm comes from the Minimax algorithm
 */
class AIEngine {
  
  enum PlayerSide {
    case x, o
  }
  
  enum GameScore: Int {
    case zero = 0, win = 10, lose = -10
  }
  
  private let recursiveDepth = 2
  
  let wins = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ]
  
  private let init_pos_values = [
    3, 2, 3,
    2, 4, 2,
    3, 2, 3
  ]
  
  var game: Game
  
  init(_ game: Game) {
    self.game = game
  }
  
  func isWin(_ board: inout [SquareType]) -> Bool {
    var result = false
    for indecies in wins {
      let square = board[indecies[0]]
      if square == .empty {
        continue
      }
      
      if board[indecies[0]] == board[indecies[1]] && board[indecies[1]] == board[indecies[2]] {
        result = true
        break
      }
    }
    
    return result
  }
  
  func isDraw() -> Bool {
    return game.moves.count == gameBoardSize
  }
  
  
  func isDraw(_ board: inout [SquareType]) -> Bool {
    var isFull = true
    for square in board {
      if .empty == square {
        isFull = false
        break
      }
    }
    
    return isFull && !isWin(&board)
  }
  
//  func isWin(_ board: inout [SquareType]) -> Bool {
//    var win = false
//    for indecies in wins {
//      if board[indecies[0]] == .empty {
//        continue
//      }
//      if board[indecies[0]] == board[indecies[1]] && board[indecies[1]] == board[indecies[2]] {
//        win = true
//        break
//      }
//    }
//
//    return win
//  }
  
  func isGameOver(_ board: inout [SquareType]) -> Bool {
    return isWin(&board) || isDraw(&board)
  }
  
  func gameScore(_ board: inout [SquareType]) -> Int {
    var score: Int = 0
    for indecies in wins {
      if board[indecies[0]] == .empty {
        continue
      }
      
      let square = board[indecies[0]]
      if board[indecies[0]] == board[indecies[1]] && board[indecies[1]] == board[indecies[2]] {
        score = (square == .cross) ? GameScore.win.rawValue : GameScore.lose.rawValue
        break
      }
    }
    
    return score
  }
  
  /**
   ALPHA-BETA Pruning
   
   ALPHA-BETA cutoff is a method for reducing the number of nodes explored in the Minimax strategy. For the nodes it explores it computes, in addition to the score, an alpha value and a beta value.
   
   ALPHA value of a node
   It is a value never greater than the true score of this node.
   Initially it is the score of that node, if the node is a leaf, otherwise it is -infinity.
   Then at a MAX node it is set to the largest of the scores of its successors explored up to now, and at a MIN node to the alpha value of its predecessor.
   
   BETA value of a node
   It is a value never smaller than the true score of this node. Initially it is the score of that node, if the node is a leaf, otherwise it is +infinity.
   Then at a MIN node it is set to the smallest of the scores of its successors explored up to now, and at a MAX node to the beta value of its predecessor.
   
   It Is Guaranteed That:
   
   The score of a node will always be no less than the alpha value and no greater than the beta value of that node.
   As the algorithm evolves, the alpha and beta values of a node may change, but the alpha value will never decrease, and the beta value will never increase.
   When a node is visited last, its score is set to the alpha value of that node, if it is a MAX node, otherwise it is set to the beta value.
   */
  
  func maxValue(_ board: inout [SquareType], depth: Int, alpha: Int, beta:Int) -> Int {
    
    let score = gameScore(&board)
    if isGameOver(&board) || depth == 0 || alpha >= beta {
      return score
    }
    
    var bestValue = Int.min
    for i in 0..<gameBoardSize {
      if board[i] == .empty {
        board[i] = .cross
        let value = minValue(&board, depth: depth - 1, alpha: max(bestValue, alpha), beta: beta)
        bestValue = max(value, bestValue)
        board[i] = .empty
      }
    }
    
    return bestValue
  }
  
  func minValue(_ board: inout [SquareType], depth: Int, alpha: Int, beta: Int) -> Int {
    
    let score = gameScore(&board)
    if isGameOver(&board) || depth == 0 || alpha >= beta {
      return score
    }
    
    var bestValue = Int.max
    for i in 0..<gameBoardSize {
      if board[i] == .empty {
        board[i] = .circle
        let value = maxValue(&board, depth: depth - 1, alpha: alpha, beta: min(bestValue, beta))
        bestValue = min(value, bestValue)
        board[i] = .empty
      }
    }
    
    return bestValue
  }
  
  func minimax(_ board: inout [SquareType], side: PlayerSide, depth: Int) -> Int {
    var moves: [Int] = []
    if side == .x {
      var bestScore = Int.min
      for i in 0..<gameBoardSize {
        if board[i] == .empty {
          board[i] = .cross
          let score = minValue(&board, depth: depth, alpha: GameScore.lose.rawValue, beta: GameScore.win.rawValue)
          if score > bestScore {
            moves.removeAll(keepingCapacity: false)
            bestScore = score
            moves.append(i)
          } else if score == bestScore {
            moves.append(i)
          }
          board[i] = .empty
        }
      }
    } else {
      var bestScore = Int.max
      for i in 0..<gameBoardSize {
        if board[i] == .empty {
          board[i] = .circle
          let score = maxValue(&board, depth: depth, alpha: GameScore.lose.rawValue, beta: GameScore.win.rawValue)
          if score < bestScore {
            moves.removeAll(keepingCapacity: false)
            bestScore = score
            moves.append(i)
          } else if score == bestScore {
            moves.append(i)
          }
          board[i] = .empty
        }
      }
      
    }
    
    return moves.count > 0 ? moves[Int(arc4random()) % moves.count] : 0
  }
  
  func nextMove(closure: @escaping (Int) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      var index : Int!
      if self.game.moves.count <= 2 {
        // Help computer to chose best position for the first round
        // Center is the best, and then is corners
        if self.game.board[4] == .empty {
          index = 4
        } else {
          index = [0,2,3,8][Int(arc4random()) % 4]
        }
      } else {
        if self.game.moves.count % 2 == 0 {
          index = self.minimax(&self.game.board, side: .x, depth: self.recursiveDepth)
        } else {
          index = self.minimax(&self.game.board, side: .o, depth: self.recursiveDepth)
        }
      }
      DispatchQueue.main.async {
        closure(index)
      }
    }
  }
  
}

