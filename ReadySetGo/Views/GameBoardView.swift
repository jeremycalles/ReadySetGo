import SwiftUI

struct GameBoardView: View {
    var viewModel: GameViewModel
    @State private var activeAlert: GameAlert?

    private let tileCornerRadius: CGFloat = 24
    private let tileSpacing: CGFloat = 8

    var body: some View {
        VStack(spacing: 0) {
            gameGrid
            bottomBar
        }
        .alert(
            activeAlert?.title ?? "",
            isPresented: showAlertBinding,
            presenting: activeAlert
        ) { alert in
            Button("Cancel", role: .cancel) {}
            Button(alert.actionTitle, role: .destructive) {
                alert.action(viewModel)
            }
        } message: { alert in
            Text(alert.message)
        }
    }

    // MARK: - Game Grid

    private var gameGrid: some View {
        GeometryReader { geometry in
            let layout = gridLayout(for: geometry.size)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: tileSpacing), count: layout.columns),
                spacing: tileSpacing
            ) {
                ForEach(viewModel.players) { player in
                    PlayerTileView(
                        player: player,
                        width: layout.tileWidth,
                        height: layout.tileHeight,
                        cornerRadius: tileCornerRadius,
                        onTap: { viewModel.incrementScore(for: player) },
                        onLongPress: { activeAlert = .decrementScore(player) }
                    )
                }
            }
            .padding(tileSpacing)
        }
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Button { activeAlert = .resetScores } label: {
                Label("Reset Scores", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.interactive(), in: .capsule)
            }

            Button { activeAlert = .newGame } label: {
                Label("New Game", systemImage: "arrow.triangle.2.circlepath")
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

    // MARK: - Layout

    private struct GridLayout {
        let columns: Int
        let tileWidth: CGFloat
        let tileHeight: CGFloat
    }

    private func gridLayout(for size: CGSize) -> GridLayout {
        let playerCount = viewModel.players.count
        let columns = playerCount <= 2 ? 1 : 2
        let rows = Int(ceil(Double(playerCount) / Double(columns)))
        let totalHSpacing = tileSpacing * CGFloat(columns + 1)
        let totalVSpacing = tileSpacing * CGFloat(rows + 1)
        return GridLayout(
            columns: columns,
            tileWidth: (size.width - totalHSpacing) / CGFloat(columns),
            tileHeight: (size.height - totalVSpacing) / CGFloat(rows)
        )
    }

    // MARK: - Alert Binding

    private var showAlertBinding: Binding<Bool> {
        Binding(
            get: { activeAlert != nil },
            set: { if !$0 { activeAlert = nil } }
        )
    }
}

// MARK: - Game Alert

private enum GameAlert: Identifiable {
    case resetScores
    case newGame
    case decrementScore(Player)

    var id: String {
        switch self {
        case .resetScores: "resetScores"
        case .newGame: "newGame"
        case .decrementScore(let player): "decrement-\(player.id)"
        }
    }

    var title: String {
        switch self {
        case .resetScores: "Reset Scores"
        case .newGame: "New Game"
        case .decrementScore: "Decrease Score"
        }
    }

    var message: String {
        switch self {
        case .resetScores:
            "Are you sure you want to reset all scores to 0?"
        case .newGame:
            "This will reset everything and go back to player setup."
        case .decrementScore(let player):
            "Remove 1 point from \(player.name)?"
        }
    }

    var actionTitle: String {
        switch self {
        case .resetScores: "Reset"
        case .newGame: "Reset Everything"
        case .decrementScore: "Decrease"
        }
    }

    func action(_ viewModel: GameViewModel) {
        switch self {
        case .resetScores:
            viewModel.resetScores()
        case .newGame:
            viewModel.resetAll()
        case .decrementScore(let player):
            viewModel.decrementScore(for: player)
        }
    }
}

// MARK: - Player Tile

private struct PlayerTileView: View {
    let player: Player
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let onTap: () -> Void
    let onLongPress: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(player.name)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text("\(player.score)")
                .font(.system(size: 48, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.95))
                .contentTransition(.numericText())
                .animation(.snappy, value: player.score)
        }
        .frame(width: width, height: height)
        .background(player.color.gradient)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(player.name), score \(player.score)")
        .accessibilityHint("Tap to add a point, long press to remove a point")
        .sensoryFeedback(.impact, trigger: player.score)
        .onTapGesture(perform: onTap)
        .onLongPressGesture(perform: onLongPress)
    }
}
