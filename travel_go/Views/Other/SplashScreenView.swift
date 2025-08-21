//
//  SplashScreenView.swift
//  travel_go
//
//  Created by Захар Панченко on 11.08.2025.
//
import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                //Color.white
                Image(.startSplashScreen)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    Image(.homeIndicator)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 134, height: 5)
                        .offset(y: -abs(geometry.safeAreaInsets.bottom)-8)
                }
            }
        }
        .persistentSystemOverlays(.hidden)
    }
}

