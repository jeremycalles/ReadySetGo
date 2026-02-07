import SwiftUI

struct PlayerNamesView: View {
    @ObservedObject var viewModel: GameViewModel
    @FocusState private var focusedField: Int?

    var body: some View {
        VStack(spacing: 24) {
            Text("Enter Player Names")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<viewModel.numberOfPlayers, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(Player.color(for: index))
                                .frame(width: 24, height: 24)

                            TextField("Player \(index + 1)", text: $viewModel.playerNames[index])
                                .font(.title3)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .focused($focusedField, equals: index)
                                .submitLabel(index < viewModel.numberOfPlayers - 1 ? .next : .done)
                                .onSubmit {
                                    if index < viewModel.numberOfPlayers - 1 {
                                        focusedField = index + 1
                                    } else {
                                        focusedField = nil
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Button {
                viewModel.startGame()
            } label: {
                Text("Start Game")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.allNamesEntered ? Color.green : Color.gray)
                    .cornerRadius(16)
            }
            .disabled(!viewModel.allNamesEntered)
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .onAppear {
            focusedField = 0
        }
    }
}
