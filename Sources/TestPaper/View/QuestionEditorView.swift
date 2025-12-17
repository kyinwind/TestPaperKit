//
//  SwiftUIView.swift
//  TestPaper
//
//  Created by yangxuehui on 2025/12/17.
//

import SwiftUI

struct QuestionEditorView: View {
    
    @Binding var question: Question
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            
            TextField("题目标题", text: Binding(
                get: { question.title },
                set: { question = Question(
                    type: question.type,
                    title: $0,
                    score: question.score,
                    options: question.options,
                    correctAnswer: question.correctAnswer
                ) }
            ))
            
            
            Picker("题型", selection: Binding(
                get: { question.type },
                set: { newType in
                    question = Question(
                        type: newType,
                        title: question.title,
                        score: question.score,
                        options: newType == .essay || newType == .fillBlank ? nil : [],
                        correctAnswer: nil
                    )
                }
            )) {
                Text("单选").tag(QuestionType.singleChoice)
                Text("多选").tag(QuestionType.multipleChoice)
                Text("填空").tag(QuestionType.fillBlank)
                Text("问答").tag(QuestionType.essay)
            }
            
            
            Stepper("分值：\(question.score)", value: Binding(
                get: { question.score },
                set: { newScore in
                    question = Question(
                        type: question.type,
                        title: question.title,
                        score: newScore,
                        options: question.options,
                        correctAnswer: question.correctAnswer
                    )
                }
            ), in: 1...100)
            
            
            if let options = question.options {
                ForEach(options.indices, id: \.self) { idx in
                    HStack {
                        TextField("选项内容", text: Binding(
                            get: { options[idx].text },
                            set: { newText in
                                var newOptions = options
                                newOptions[idx] = Option(text: newText, isCorrect: options[idx].isCorrect)
                                question = Question(
                                    type: question.type,
                                    title: question.title,
                                    score: question.score,
                                    options: newOptions,
                                    correctAnswer: question.correctAnswer
                                )
                            }
                        ))
                        Toggle("正确", isOn: Binding(
                            get: { options[idx].isCorrect },
                            set: { isCorrect in
                                var newOptions = options
                                newOptions[idx] = Option(text: options[idx].text, isCorrect: isCorrect)
                                question = Question(
                                    type: question.type,
                                    title: question.title,
                                    score: question.score,
                                    options: newOptions,
                                    correctAnswer: question.correctAnswer
                                )
                            }
                        ))
                    }
                }
                
                
                Button("➕ 添加选项") {
                    var newOptions = options
                    newOptions.append(Option(text: "新选项", isCorrect: false))
                    question = Question(
                        type: question.type,
                        title: question.title,
                        score: question.score,
                        options: newOptions,
                        correctAnswer: question.correctAnswer
                    )
                }
            }
            
            
            if question.type == .fillBlank || question.type == .essay {
                TextField("参考答案", text: Binding(
                    get: { question.correctAnswer ?? "" },
                    set: { answer in
                        question = Question(
                            type: question.type,
                            title: question.title,
                            score: question.score,
                            options: question.options,
                            correctAnswer: answer
                        )
                    }
                ))
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    @State var q = Question(type: .singleChoice, title: "这是一道单选题", score: 10)
    QuestionEditorView(question: $q) // 使用$符号传递绑定
}
