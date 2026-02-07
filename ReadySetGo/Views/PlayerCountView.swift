import SwiftUI

struct PlayerCountView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("Ready, Set, Go!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("How many players?")
                .font(.title2)
                .foregroundColor(.secondary)

            HStack(spacing: 20) {
                Button {
                    if viewModel.numberOfPlayers > viewModel.minPlayers {
                        viewModel.numberOfPlayers -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(viewModel.numberOfPlayers > viewModel.minPlayers ? .blue : .gray)
                }
                .disabled(viewModel.numberOfPlayers <= viewModel.minPlayers)

                Text("\(viewModel.numberOfPlayers)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .frame(minWidth: 80)

                Button {
                    if viewModel.numberOfPlayers < viewModel.maxPlayers {
                        viewModel.numberOfPlayers += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(viewModel.numberOfPlayers < viewModel.maxPlayers ? .blue : .gray)
                }
                .disabled(viewModel.numberOfPlayers >= viewModel.maxPlayers)
            }

            Button {
                viewModel.proceedToNames()
            } label: {
                Text("Next")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }
}
