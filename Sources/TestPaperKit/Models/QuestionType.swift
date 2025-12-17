import Foundation

public enum QuestionType: String, Codable {
    case singleChoice   //单选
    case multipleChoice //多选
    case fillBlank //填空
    case essay //问答
}
