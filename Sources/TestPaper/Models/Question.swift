import Foundation
//一道问题的结构体，包含多个选项
public struct Question: Identifiable, Codable {
    public let id: UUID
    public let type: QuestionType
    public let title: String
    public let score: Int
    public let options: [Option]?
    public let correctAnswer: String?

    public init(
        type: QuestionType,
        title: String,
        score: Int,
        options: [Option]? = nil,
        correctAnswer: String? = nil
    ) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.score = score
        self.options = options
        self.correctAnswer = correctAnswer
    }
}
