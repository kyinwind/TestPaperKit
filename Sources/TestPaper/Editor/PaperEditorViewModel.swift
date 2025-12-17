import Foundation
import SwiftUI

@MainActor
public final class PaperEditorViewModel: ObservableObject {

    @Published public var paperName: String = ""
    @Published public var durationMinutes: Int = 40
    @Published public var questions: [Question] = []

    public init() {}

    public var totalScore: Int {
        questions.reduce(0) { $0 + $1.score }
    }

    public func buildPaper() throws -> TestPaper {
        guard totalScore == 100 else {
            throw NSError(domain: "ScoreError", code: 1)
        }
        return TestPaper(
            name: paperName,
            duration: TimeInterval(durationMinutes * 60),
            questions: questions
        )
    }

    public func exportJSON() throws -> String {
        let paper = try buildPaper()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(paper)
        return String(decoding: data, as: UTF8.self)
    }

    public func importJSON(_ json: String) throws {
        let data = Data(json.utf8)
        let paper = try JSONDecoder().decode(TestPaper.self, from: data)
        self.paperName = paper.name
        self.durationMinutes = Int(paper.duration / 60)
        self.questions = paper.questions
    }
}
