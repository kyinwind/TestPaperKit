//
//  SwiftUIView.swift
//  TestPaper
//
//  Created by yangxuehui on 2025/12/17.
//

import SwiftUI

public enum TestPhase {
    case doing        // 作答中
    case submitted    // 已交卷（不可再改）
}

@MainActor
final class TestPaperViewModel: ObservableObject {
    let paper: TestPaper
    @Published var answers: [UUID: UserAnswer] = [:]
    @Published var remainingTime: TimeInterval
    @Published var result: TestResult? = nil
    @Published var phase: TestPhase = .doing
    
    private var timer: Timer?
    
    init(paper: TestPaper) {
        self.paper = paper
        self.remainingTime = paper.duration
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.submit()
            }
        }
    }
    
    
    func submit() {
        // 防止重复交卷
        guard phase == .doing else { return }
        
        timer?.invalidate()
        timer = nil
        
        let scoreResult = ScoringEngine.score(
            paper: paper,
            answers: answers
        )
        
        self.result = TestResult(
            paper: paper,
            answers: answers,
            scoreResult: scoreResult
        )
        phase = .submitted // 已交卷，不可再改
    }
    func restart() {
        answers = [:]
        result = nil
        phase = .doing
    }
}

