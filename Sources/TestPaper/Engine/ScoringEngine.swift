import Foundation

//这个结构体封装了试卷得分，只有得分
public struct ScoreResult {
    public let totalScore: Int
    public let perQuestion: [UUID: Int]   //这是一个字典，key是问题ID, value是这个问题的得分
}
//封装了试卷的所有信息，包括得分结果
public struct TestResult {
    public let paper: TestPaper
    public let answers: [UUID: UserAnswer]
    public let scoreResult: ScoreResult
}
//用户针对一个问题的回答
public struct UserAnswer {
    public let questionID: UUID
    public var selectedOptionIDs: Set<UUID> = []
    public var textAnswer: String = ""
}

//算分的引擎
public enum ScoringEngine {

    public static func score(
        paper: TestPaper,
        answers: [UUID: UserAnswer]
    ) -> ScoreResult {

        var total = 0
        var detail: [UUID: Int] = [:]

        for q in paper.questions {
            guard let answer = answers[q.id] else { continue }
            var score = 0

            switch q.type {
            case .singleChoice, .multipleChoice:
                let correct = q.options?.filter { $0.isCorrect }.map { $0.id } ?? []
                if Set(correct) == answer.selectedOptionIDs {
                    score = q.score
                }
            case .fillBlank:
                if q.correctAnswer?.trimmingCharacters(in: .whitespacesAndNewlines)
                    == answer.textAnswer.trimmingCharacters(in: .whitespacesAndNewlines) {
                    score = q.score
                }
            case .essay:
                score = 0
            }

            total += score
            detail[q.id] = score
        }

        return ScoreResult(totalScore: total, perQuestion: detail)
    }
}
