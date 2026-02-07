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
                .foregroundStyle(.secondary)

            HStack(spacing: 20) {
                Button {
                    if viewModel.numberOfPlayers > viewModel.minPlayers {
                        viewModel.numberOfPlayers -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(viewModel.numberOfPlayers > viewModel.minPlayers ? .primary : .tertiary)
                        .frame(width: 56, height: 56)
                        .glassEffect(.regular.interactive(), in: .circle)
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
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(viewModel.numberOfPlayers < viewModel.maxPlayers ? .primary : .tertiary)
                        .frame(width: 56, height: 56)
                        .glassEffect(.regular.interactive(), in: .circle)
                }
                .disabled(viewModel.numberOfPlayers >= viewModel.maxPlayers)
            }

            Button {
                viewModel.proceedToNames()
            } label: {
                Text("Next")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .glassEffect(.regular.interactive(), in: .capsule)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }
}
