//
//  SplashScreenView.swift
//  CryptoPrices
//
//  Created by Nilusha Niwanthaka Wimalasena on 26/8/25.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var scale = 0.8
    @State private var opacity = 0.0
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "bitcoinsign.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))

                Text(NSLocalizedString("splash.title", comment: "Splash Screen App Title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(opacity)

                Text(NSLocalizedString("splash.subtitle", comment: "Splash Screen Subtitle"))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                scale = 1.0
                opacity = 1.0
                rotation = 360
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                coordinator.hideSplashScreen()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
