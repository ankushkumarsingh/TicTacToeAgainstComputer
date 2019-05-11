//
//  Player.swift
//  ticTacToe
//
//  Created by citiadmin on 5/15/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import Foundation

enum PlayerMode {
    case human, computer
}


class Player {
    var mode: PlayerMode
    var moves: [Int] = []
    
    init(mode: PlayerMode = .human) {
        self.mode = mode
    }
    
}
