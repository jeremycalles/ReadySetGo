import SwiftUI

enum GamePhase {
    case playerCount
    case playerNames
    case playing
}

class GameViewModel: ObservableObject {
    @Published var phase: GamePhase = .playerCount
    @Published var numberOfPlayers: Int = 2
    @Published var playerNames: [String] = []
    @Published var players: [Player] = []
    @Published var showResetConfirmation: Bool = false

    let minPlayers = 1
    let maxPlayers = 8

    func proceedToNames() {
        playerNames = Array(repeating: "", count: numberOfPlayers)
        phase = .playerNames
    }

    func startGame() {
        players = playerNames.enumerated().map { index, name in
            Player(name: name, color: Player.color(for: index))
        }
        phase = .playing
    }

    var allNamesEntered: Bool {
        playerNames.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    func incrementScore(for player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players[index].score += 1
        }
    }

    func decrementScore(for player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }),
           players[index].score > 0 {
            players[index].score -= 1
        }
    }

    func resetScores() {
        for index in players.indices {
            players[index].score = 0
        }
    }

    func resetAll() {
        players = []
        playerNames = []
        numberOfPlayers = 2
        phase = .playerCount
    }
}
