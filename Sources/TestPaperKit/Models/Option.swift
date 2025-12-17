import Foundation

//选择题的选项
public struct Option: Identifiable, Codable {
    public let id: UUID
    public let text: String    //选项的描述
    public let isCorrect: Bool   //是否是正确的选项

    public init(text: String, isCorrect: Bool) {
        self.id = UUID()
        self.text = text
        self.isCorrect = isCorrect
    }
}
