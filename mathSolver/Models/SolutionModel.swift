//
//  SolutionModel.swift
//  mathSolver
//
//  Created by FFK on 3.12.2024.
//

import Foundation

struct Solution: Codable {
    let question: String
    let solution: String
    let steps: [String]
    let timestamp: Date
    let id: String

    init(question: String, solution: String, steps: [String], timestamp: Date = Date(), id: String = UUID().uuidString) {
        self.question = question
        self.solution = solution
        self.steps = steps
        self.timestamp = timestamp
        self.id = id
    }
}
