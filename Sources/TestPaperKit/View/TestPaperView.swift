//
//  SwiftUIView.swift
//  TestPaper
//
//  Created by yangxuehui on 2025/12/17.
//

import SwiftUI

public struct TestPaperView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm: TestPaperViewModel
    
    public init(paper: TestPaper) {
        _vm = StateObject(wrappedValue: TestPaperViewModel(paper: paper))
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Text(vm.paper.name)
                    .font(.title)
                
                Text("剩余时间：\(Int(vm.remainingTime / 60)) 分")
                
                ForEach(vm.paper.questions) { question in
                    QuestionView(
                        question: question,
                        answer: Binding(
                            get: { vm.answers[question.id] ?? UserAnswer(questionID: question.id) },
                            set: { vm.answers[question.id] = $0 }
                        ),
                        showAnswer: vm.phase == .submitted
                    )
                    .disabled(vm.phase == .submitted) // ⭐️关键
                }
                
                
                if vm.phase == .doing {
                    Button("交卷") {
                        vm.submit()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    VStack(spacing: 12) {
                        if let result = vm.result {
                            ResultView(result: result)
                        }
                        HStack{
                            Spacer()
                            Button("退出") {
                                dismiss()
                            }
                            Spacer()
                            Button("重新做一次") {
                                vm.restart()
                            }
                            Spacer()
                        }
                    }
                }
                
            }
            .padding()
        }
    }
}


#Preview {
    let o1 = Option(text: "A. 慧能大师", isCorrect: false)
    let o2 = Option(text: "B. 达摩祖师", isCorrect: true)
    let o3 = Option(text: "C. 弘忍大师", isCorrect: false)
    let o4 = Option(text: "D. 神秀大师", isCorrect: false)
    let options = [o1, o2, o3, o4]
    var q1 = Question(type: .singleChoice, title: "禅宗所尊奉的“初祖”是哪位高僧？", score: 5,options: options,correctAnswer: "" )
    
    let q2 = Question(type: .singleChoice, title: "禅宗所尊奉的“初祖”是哪位高僧？", score: 5,options: options,correctAnswer: "")
    var tp = TestPaper(name: "禅宗佛学知识测验试题", duration: 40, questions: [q1,q2])
    
    return TestPaperView(paper: tp)
}
