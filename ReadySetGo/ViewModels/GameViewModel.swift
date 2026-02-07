import SwiftUI

enum GamePhase: Equatable {
    case playerCount
    case playerNames
    case playing
}

@Observable
class GameViewModel {
    var phase: GamePhase = .playerCount
    var numberOfPlayers: Int = 2
    var playerNames: [String] = []
    var players: [Player] = []

    let minPlayers = 1
    let maxPlayers = 8

    // MARK: - Navigation

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

    // MARK: - Validation

    var allNamesEntered: Bool {
        playerNames.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    // MARK: - Score Management

    func incrementScore(for player: Player) {
        guard let index = players.firstIndex(where: { $0.id == player.id }) else { return }
        players[index].score += 1
    }

    func decrementScore(for player: Player) {
        guard let index = players.firstIndex(where: { $0.id == player.id }),
              players[index].score > 0 else { return }
        players[index].score -= 1
    }

    func resetScores() {
        for index in players.indices {
            players[index].score = 0
        }
    }

    // MARK: - Game Reset

    func resetAll() {
        players = []
        playerNames = []
        numberOfPlayers = 2
        phase = .playerCount
    }
}
