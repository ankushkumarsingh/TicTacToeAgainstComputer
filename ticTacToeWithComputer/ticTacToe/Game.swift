//
//  Game.swift
//  ticTacToe
//
//  Created by citiadmin on 5/15/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation

enum GameMode {
    case computer, player, auto
}

enum SquareType:String {
    case empty  = "-"
    case cross  = "X"
    case circle = "O"
}

let gameBoardSize = 9

class Game {
    var mode: GameMode
    var playerX: Player     // Always the first player
    var playerO: Player     // Always the second player
    var board: [SquareType]
    var moves: [Int] = []
    
  init(mode: GameMode = .auto) {
        self.mode = mode
        self.board = Array<SquareType>(repeating: .empty, count: gameBoardSize)
    
        switch mode {
        case .computer:
          self.playerO = Player(mode: .computer)
            self.playerX = Player()
            
        case .player:
            self.playerX = Player()
            self.playerO = Player()
            
        case .auto:
            // TODO: play game automatically with two computer player
          self.playerX = Player(mode: .computer)
          self.playerO = Player(mode: .computer)

        }
    }
    
    func setMode(mode: GameMode) {
        self.mode = mode
    }
    
    
    
    
    func reset() {
      board = Array<SquareType>(repeating: .empty, count: gameBoardSize)
      playerX.moves.removeAll(keepingCapacity: false)
      playerO.moves.removeAll(keepingCapacity: false)
      moves.removeAll(keepingCapacity: false)
        
    }
}
