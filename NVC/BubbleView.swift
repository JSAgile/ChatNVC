//
//  BubbleView.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI
import AVFoundation

struct BubbleView: View {
    @State private var isPressed = false
    @Binding var poppedCount: Int
    @ObservedObject var viewModel = BubbleViewModel()

    var body: some View {
        Button(action: {
            print("isPressed before toggle: \(isPressed)")
            isPressed.toggle()
            print("isPressed after toggle: \(isPressed)")
            if isPressed {
                print("Bubble was pressed")
                viewModel.playPopSound()
                poppedCount += 1
            } else {
                viewModel.playUnpopSound()
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [
                            Color(red: 0.91, green: 0.77, blue: 0.42),
                            Color(red: 0.35, green: 0.65, blue: 0.53)
                        ]), center: .center, startRadius: 15, endRadius: 35)
                    )
                    .frame(width: 75, height: 75)
                    .scaleEffect(isPressed ? 0.8 : 1.0)
                RoundedRectangle(cornerRadius: 50)
                    .stroke(
                        Color(red: 0.13, green: 0.51, blue: 0.46),
                        lineWidth: isPressed ? 5 : 2
                    )
                    .frame(width: 75, height: 75)
                    .scaleEffect(isPressed ? 0.8 : 1.0)
            }
            .animation(.spring())
        })
    }
}

struct BubblePopView: View {
    @State private var isLandscape = false
    let portraitColumns = 5
    let landscapeColumns = 8
    let portraitRows = 5
    let landscapeRows = 3
    @State private var poppedCount = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text(
                    "Your NVC AI is thinking of how to communicate the underlying feelings and needs." +
                    " Breathe a moment and pop some bubbles while you wait."
                )
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .font(.system(size: 16))
                .minimumScaleFactor(0.5)
                .fixedSize(horizontal: false, vertical: true)
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 20),
                        count: isLandscape ? landscapeColumns : portraitColumns
                    ),
                    spacing: 20
                ) {
                    ForEach(
                        1...(
                            isLandscape
                                ? landscapeColumns * landscapeRows
                                : portraitColumns * portraitRows
                        ),
                        id: \.self
                    ) { _ in
                        BubbleView(poppedCount: $poppedCount)
                            .frame(maxWidth: 60, maxHeight: 60)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .onAppear {
                isLandscape = geometry.size.width > geometry.size.height
            }
            .onChange(of: geometry.size) { size in
                isLandscape = size.width > size.height
            }
            .onChange(of: poppedCount) { _ in
                if poppedCount >= (
                    isLandscape
                        ? landscapeColumns * landscapeRows
                        : portraitColumns * portraitRows
                ) {
                    poppedCount = 0
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(red: Double(38) / 255, green: Double(70) / 255, blue: Double(83) / 255)
                .opacity(0.8)
        )
    }
}

struct BubbleView_Previews: PreviewProvider {
    @State static var dummyPoppedCount = 0
    static var previews: some View {
        BubbleView(poppedCount: $dummyPoppedCount)
    }
}

class BubbleViewModel: ObservableObject {
    var players: [AVAudioPlayer?] = []
    init() {
        setupAudioSession()
    }
    func playPopSound() {
         playSound(named: "pop")
     }

     func playUnpopSound() {
         playSound(named: "unpop")
     }
    private func playSound(named soundName: String) {
            if let bundlePath = Bundle.main.path(forResource: soundName, ofType: "mp3") {
                let url = URL(fileURLWithPath: bundlePath)
                do {
                    if let availablePlayer = players.first(where: { $0?.isPlaying == false }) {
                        availablePlayer?.play()
                    } else {
                        let player = try AVAudioPlayer(contentsOf: url)
                        players.append(player)
                        player.play()
                    }
                } catch {
                    print("audioPlayer error \(error.localizedDescription)")
                }
            }
        }
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true, options: [])
        } catch {
            print("Setting up the audio session failed: \(error)")
        }
    }
}
