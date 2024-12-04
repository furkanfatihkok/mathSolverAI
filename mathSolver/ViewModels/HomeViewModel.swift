//
//  HomeViewModel.swift
//  mathSolver
//
//  Created by FFK on 29.11.2024.
//

import UIKit
import Vision

final class HomeViewModel {
    private let mathProblemManager = MathProblemManager.shared
    
    var solvedResult: ((String, String) -> Void)?
    var showError: ((String) -> Void)?
    
    func processImage(image: UIImage) {
        mathProblemManager.processImage(image: image) { [weak self] result in
            switch result {
            case .success(let question):
                self?.callAIAPI(question: question)
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            }
        }
    }
    
    private func callAIAPI(question: String) {
        mathProblemManager.callAIAPI(question: question) { [weak self] result in
            switch result {
            case .success(let solution):
                self?.solvedResult?(question, solution)
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            }
        }
    }
}
