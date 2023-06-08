//
//  AboutView.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About This App")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Text("This app was created by Jesse Shepard & ChatGPT.")
                .foregroundColor(.white)
                .padding()
            Text("Contact: jsagile@fastmail.com")
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: Double(42) / 255, green: Double(157) / 255, blue: Double(143) / 255))
        .ignoresSafeArea()
        .navigationBarTitle("About", displayMode: .inline)
        .foregroundColor(.white)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
