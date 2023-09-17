//
//  MultipleChoice.swift
//  GreenCircle
//
//  Created by Dan FuPo on 13/09/23.
//

import SwiftUI

import SwiftUI

struct MultipleChoice: View {
  @Binding var question: SurveyQuestion
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(question.questionText)
        .font(.headline)
      
      ForEach(0..<question.options!.count, id: \.self) { answer in
        Button(action: {
          question.response = question.options![answer]
        }) {
          HStack {
            Text(question.options![answer])
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundColor(question.response == question.options![answer] ? Color.blue : Color.black)
          }
          .padding()
          .background(question.response == question.options![answer] ? Color.yellow : Color.clear)
        }
        .clipShape(RoundedRectangle(cornerRadius: 9))
        .overlay(
          RoundedRectangle(cornerRadius: 9)
            .stroke(lineWidth: 1)
        )
        .padding(.bottom, 4)
      }
    }
  }
}

struct MultipleChoice_Previews: PreviewProvider {
  static var previews: some View {
    MultipleChoice(question: .constant(SurveyQuestion (
      questionType: .multipleChoice,
      questionText: "Which of the following features do you find most useful?",
      options: ["Fast Delivery", "Easy Returns", "Wide Product Range"],
      response: nil
    )))
  }
}

