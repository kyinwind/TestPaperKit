//
//  SwiftUIView.swift
//  TestPaper
//
//  Created by yangxuehui on 2025/12/17.
//

import SwiftUI

public struct ResultView: View {

    public let result: TestResult

    public init(result: TestResult) {
        self.result = result
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Divider()

                ForEach(result.paper.questions) { question in
                    QuestionResultView(
                        question: question,
                        userAnswer: result.answers[question.id],
                        score: result.scoreResult.perQuestion[question.id] ?? 0
                    )
                }
                Text("总分:\(result.scoreResult.totalScore)")
                    .font(.title)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

private extension ResultView {

    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("考试结果")
                .font(.largeTitle)
                .bold()

            Text("试卷：\(result.paper.name)")
            Text("总分：\(result.scoreResult.totalScore) / 100")
                .font(.title2)
                .foregroundColor(.blue)
        }
    }
}

struct QuestionResultView: View {

    let question: Question
    let userAnswer: UserAnswer?
    let score: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                Text(question.title)
                    .font(.headline)

                Spacer()

                Text("\(score) / \(question.score) 分")
                    .foregroundColor(score == question.score ? .green : .red)
            }

            switch question.type {
            case .singleChoice, .multipleChoice:
                choiceResult

            case .fillBlank:
                fillBlankResult

            case .essay:
                essayResult
            }

            Divider()
        }
    }
}
private extension QuestionResultView {

    var choiceResult: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(question.options ?? []) { option in
                HStack {
                    Text(option.text)

                    if option.isCorrect {
                        Text("✔︎")
                            .foregroundColor(.green)
                    }

                    if userAnswer?.selectedOptionIDs.contains(option.id) == true {
                        Text("(你的选择)")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
private extension QuestionResultView {

    var fillBlankResult: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("你的答案：\(userAnswer?.textAnswer ?? "—")")
            Text("参考答案：\(question.correctAnswer ?? "")")
                .foregroundColor(.green)
        }
    }
}
private extension QuestionResultView {

    var essayResult: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("你的作答：")
            Text(userAnswer?.textAnswer ?? "未作答")
                .foregroundColor(.secondary)

            if let ref = question.correctAnswer {
                Text("参考答案：\(ref)")
                    .foregroundColor(.green)
            }
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
    let a1 = UserAnswer(questionID: q1.id, selectedOptionIDs: [o2.id])
    let a2 = UserAnswer(questionID: q2.id, selectedOptionIDs: [o2.id])
    let answers = [a1.questionID:a1, a2.questionID:a2]
    let vm = TestPaperViewModel(paper: tp)
    let sr = ScoringEngine.score(paper: tp, answers: answers)
    let r = TestResult(paper: tp, answers: answers, scoreResult: sr)
    ResultView(result: r)
}
