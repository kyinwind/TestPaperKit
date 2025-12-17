//
//  SwiftUIView.swift
//  TestPaper
//
//  Created by yangxuehui on 2025/12/17.
//

import SwiftUI

struct PaperEditorView: View {
    @StateObject private var vm = PaperEditorViewModel()
    @State private var jsonText: String = ""
    @State private var errorMessage: String?
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    
                    TextField("试卷名称", text: $vm.paperName)
                        .textFieldStyle(.roundedBorder)
                    
                    
                    Stepper("考试时长：\(vm.durationMinutes) 分钟",
                            value: $vm.durationMinutes,
                            in: 1...300)
                    
                    
                    Divider()
                    
                    
                    ForEach(vm.questions.indices, id: \.self) { index in
                        QuestionEditorView(question: $vm.questions[index])
                    }
                    
                    
                    Button("➕ 添加题目") {
                        vm.questions.append(
                            Question(
                                type: .singleChoice,
                                title: "新题目",
                                score: 10,
                                options: [],
                                correctAnswer: nil
                            )
                        )
                    }
                    
                    
                    Text("当前总分：\(vm.totalScore)")
                        .foregroundColor(vm.totalScore == 100 ? .green : .red)
                    
                    
                    Divider()
                    
                    
                    Button("导出 JSON") {
                        do {
                            jsonText = try vm.exportJSON()
                        } catch {
                            errorMessage = "总分必须等于 100 分"
                        }
                    }
                    
                    
                    Button("从 JSON 导入") {
                        do {
                            try vm.importJSON(jsonText)
                        } catch {
                            errorMessage = "JSON 格式错误"
                        }
                    }
                    
                    
                    TextEditor(text: $jsonText)
                        .frame(height: 240)
                        .border(.gray)
                    
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("试卷编辑器")
        }
    }
}

#Preview {
    PaperEditorView()
}
