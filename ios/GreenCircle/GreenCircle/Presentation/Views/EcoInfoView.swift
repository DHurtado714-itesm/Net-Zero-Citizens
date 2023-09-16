//
//  EcoInfoView.swift
//  GreenCircle
//
//  Created by Dani Gutiérrez on 14/09/23.
//

import Foundation
import SwiftUI

struct EcoInfoView: View {
  @State var isPressedSeeMore: [Int: Bool] = [:]
  @StateObject var ecoInfoViewModel = EcoInfoViewModel()

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack {
          ForEach(ecoInfoViewModel.ecoInfoArray, id: \.ecoinfoId) { ecoInfo in
            EcoInfoCard(isPressedSeeMore: $isPressedSeeMore, ecoInfo: ecoInfo)
          }
        }
      }.navigationTitle("Últimas noticias")
    }.onAppear {
      Task {
        await ecoInfoViewModel.fetchAllEcoInfo()
      }
    }
  }
}

struct EcoInfoCard: View {
  @Binding var isPressedSeeMore: [Int: Bool]
  let ecoInfo: EcoInfo
  var body: some View {
    ZStack {
      VStack {
        AsyncImage(url: URL(string: ecoInfo.coverImage ?? "")) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
        } placeholder: {
          ProgressView().frame(width: 150, height: 150)
        }
        HStack {
          VStack(alignment: .leading) {
            let regexPattern = "[.!?\\s\\p{Emoji}]"
            if let ecoText = ecoInfo.description, ecoText.count > 75 {
              let limitedText = String(ecoText.prefix(150))
              Text("\(limitedText) ")
                  .font(.system(size: 12))
              Text("Ver más...")
                .font(.system(size: 12))
                .foregroundColor(.blue)
                .onTapGesture {
                  if let url = URL(string: ecoInfo.postLink) {
                    UIApplication.shared.open(url)
                  }
                }.frame(maxWidth: .infinity, alignment: .trailing)
            } else {
              Text(ecoInfo.description ?? "").font(.system(size: 12))
            }
          }.padding()
        }
      }
    }.frame(maxWidth: 344)
      .overlay(RoundedRectangle(cornerRadius: 10)
        .stroke(.black, lineWidth: 0.4))
  }
}
