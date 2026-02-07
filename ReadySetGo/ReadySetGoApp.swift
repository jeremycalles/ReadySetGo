import SwiftUI

@main
struct ReadySetGoApp: App {
    @StateObject private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch viewModel.phase {
                case .playerCount:
                    PlayerCountView(viewModel: viewModel)
                case .playerNames:
                    PlayerNamesView(viewModel: viewModel)
                case .playing:
                    GameBoardView(viewModel: viewModel)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.phase)
        }
    }
}

// Make GamePhase conform to Equatable for animation
extension GamePhase: Equatable {}
