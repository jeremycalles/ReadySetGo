import SwiftUI

struct Player: Identifiable {
    let id: UUID
    var name: String
    var score: Int
    var color: Color

    init(name: String, color: Color) {
        self.id = UUID()
        self.name = name
        self.score = 0
        self.color = color
    }

    static let colorPalette: [Color] = [
        .red, .blue, .green, .orange, .purple,
        .pink, .teal, .indigo
    ]

    static func color(for index: Int) -> Color {
        colorPalette[index % colorPalette.count]
    }
}
