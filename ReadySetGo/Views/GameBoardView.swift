import SwiftUI

struct GameBoardView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showResetScoresAlert = false
    @State private var showNewGameAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // Player buttons filling available space
            GeometryReader { geometry in
                let playerCount = viewModel.players.count
                let columns = playerCount <= 2 ? 1 : 2
                let rows = Int(ceil(Double(playerCount) / Double(columns)))
                let buttonWidth = geometry.size.width / CGFloat(columns)
                let buttonHeight = geometry.size.height / CGFloat(rows)

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: columns),
                    spacing: 0
                ) {
                    ForEach(viewModel.players) { player in
                        Button {
                            viewModel.incrementScore(for: player)
                        } label: {
                            VStack(spacing: 8) {
                                Text(player.name)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)

                                Text("\(player.score)")
                                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white.opacity(0.95))
                            }
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(player.color)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // Bottom bar with reset buttons
            HStack(spacing: 16) {
                Button {
                    showResetScoresAlert = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset Scores")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(12)
                }

                Button {
                    showNewGameAlert = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("New Game")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
        }
        .ignoresSafeArea(.container, edges: .top)
        .alert("Reset Scores", isPresented: $showResetScoresAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                viewModel.resetScores()
            }
        } message: {
            Text("Are you sure you want to reset all scores to 0?")
        }
        .alert("New Game", isPresented: $showNewGameAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset Everything", role: .destructive) {
                viewModel.resetAll()
            }
        } message: {
            Text("This will reset everything and go back to player setup.")
        }
    }
}
