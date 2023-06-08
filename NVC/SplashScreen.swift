//
//  SplashScreen.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if self.isActive {
                MainView()
            } else {
                VStack {
                    Text("ChatNVC")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    Text("The unofficial Nonviolent Communication app")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: Double(42) / 255, green: Double(157) / 255, blue: Double(143) / 255))
                .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}


struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
