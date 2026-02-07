import SwiftUI

struct GameBoardView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showResetScoresAlert = false
    @State private var showNewGameAlert = false
    @State private var showDecrementAlert = false
    @State private var playerToDecrement: Player?

    private let tileCornerRadius: CGFloat = 24
    private let tileSpacing: CGFloat = 8

    var body: some View {
        VStack(spacing: 0) {
            // Player buttons filling available space
            GeometryReader { geometry in
                let playerCount = viewModel.players.count
                let columns = playerCount <= 2 ? 1 : 2
                let rows = Int(ceil(Double(playerCount) / Double(columns)))
                let totalHSpacing = tileSpacing * CGFloat(columns + 1)
                let totalVSpacing = tileSpacing * CGFloat(rows + 1)
                let buttonWidth = (geometry.size.width - totalHSpacing) / CGFloat(columns)
                let buttonHeight = (geometry.size.height - totalVSpacing) / CGFloat(rows)

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: tileSpacing), count: columns),
                    spacing: tileSpacing
                ) {
                    ForEach(viewModel.players) { player in
                        VStack(spacing: 8) {
                            Text(player.name)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)

                            Text("\(player.score)")
                                .font(.system(size: 48, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white.opacity(0.95))
                        }
                        .frame(width: buttonWidth, height: buttonHeight)
                        .background(player.color.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: tileCornerRadius, style: .continuous))
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: tileCornerRadius, style: .continuous))
                        .onTapGesture {
                            viewModel.incrementScore(for: player)
                        }
                        .onLongPressGesture {
                            playerToDecrement = player
                            showDecrementAlert = true
                        }
                    }
                }
                .padding(tileSpacing)
            }

            // Bottom bar with reset buttons
            HStack(spacing: 12) {
                Button {
                    showResetScoresAlert = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset Scores")
                    }
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.interactive(), in: .capsule)
                }

                Button {
                    showNewGameAlert = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("New Game")
                    }
                    .font(.headline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.interactive(), in: .capsule)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        
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
        .alert("Decrease Score", isPresented: $showDecrementAlert) {
            Button("Cancel", role: .cancel) {
                playerToDecrement = nil
            }
            Button("Decrease", role: .destructive) {
                if let player = playerToDecrement {
                    viewModel.decrementScore(for: player)
                }
                playerToDecrement = nil
            }
        } message: {
            if let player = playerToDecrement {
                Text("Remove 1 point from \(player.name)?")
            }
        }
    }
}
