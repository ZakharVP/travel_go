//
//  StoryCell.swift
//  travel_go
//
//  Created by Захар Панченко on 02.09.2025.
//
import SwiftUI

struct StoryCell: View {
    let story: Story
    let size: CGSize = CGSize(width: 92, height: 140)
    
    var body: some View {
        VStack {
            ZStack {
                Image(story.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .cornerRadius(16)
                    .opacity(story.isViewed ? 0.7 : 1.0)
                
                if !story.isViewed {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blueUniversal, lineWidth: 4)
                        .frame(width: size.width, height: size.height)
                }
                
                VStack {
                    Spacer()
                    Text(story.smallText)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 76, height: 45, alignment: .topLeading)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 8)
                        .padding(.leading, 8)
                }
                .frame(width: size.width, height: size.height)
            }
            .frame(width: size.width, height: size.height)
        }
    }
}
