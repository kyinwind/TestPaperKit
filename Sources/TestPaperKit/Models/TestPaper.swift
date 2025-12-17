import Foundation
import SwiftUI
//一套试卷的结构，包含试卷名称、时长和题目列表
public struct TestPaper: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let duration: TimeInterval   //限制时长，例如40分钟
    public let questions: [Question]

    public init(
        name: String,
        duration: TimeInterval,
        questions: [Question]
    ) {
        self.id = UUID()
        self.name = name
        self.duration = duration
        self.questions = questions
    }

    public var totalScore: Int {
        questions.reduce(0) { $0 + $1.score }
    }
    
    static public func importJSON(_ json: String) throws -> TestPaper{
        let data = Data(json.utf8)
        let paper = try JSONDecoder().decode(TestPaper.self, from: data)
        return paper
    }
}
