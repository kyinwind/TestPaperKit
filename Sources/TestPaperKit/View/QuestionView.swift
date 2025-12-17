//
//  Untitled.swift
//  TestPaper
//
//  Created by yangxuehui on 2025/12/17.
//

import SwiftUI


struct QuestionView: View {

    let question: Question
    @Binding var answer: UserAnswer
    let showAnswer: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(question.title)
                .font(.headline)

            switch question.type {
            case .singleChoice, .multipleChoice:
                ForEach(question.options ?? []) { option in
                    Toggle(
                        option.text,
                        isOn: Binding(
                            get: { answer.selectedOptionIDs.contains(option.id) },
                            set: { isOn in
                                if isOn {
                                    answer.selectedOptionIDs.insert(option.id)
                                } else {
                                    answer.selectedOptionIDs.remove(option.id)
                                }
                            }
                        )
                    )
                }

            case .fillBlank, .essay:
                TextField("请输入答案", text: Binding(
                    get: { answer.textAnswer ?? "" },
                    set: { answer.textAnswer = $0 }
                ))
                .textFieldStyle(.roundedBorder)
            }

            if showAnswer {
                Text("参考答案：\(question.correctAnswer ?? "略")")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    let o1 = Option(text: "A. 慧能大师", isCorrect: false)
    let o2 = Option(text: "B. 达摩祖师", isCorrect: true)
    let o3 = Option(text: "C. 弘忍大师", isCorrect: false)
    let o4 = Option(text: "D. 神秀大师", isCorrect: false)
    let options = [o1, o2, o3, o4]
    var q = Question(type: .singleChoice, title: "禅宗所尊奉的“初祖”是哪位高僧？", score: 5,options: options,correctAnswer: "" )
    var a:Set<UUID> = []
    a.insert(o1.id)
    @State var answer = UserAnswer(questionID: q.id,selectedOptionIDs: a)
    return QuestionView(question: q, answer: $answer, showAnswer: true)
}
