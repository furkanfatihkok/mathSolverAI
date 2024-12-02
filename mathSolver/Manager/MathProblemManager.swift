//
//  MathProblemManager.swift
//  mathSolver
//
//  Created by FFK on 2.12.2024.
//

import UIKit
import Vision

final class MathProblemManager {
    static let shared = MathProblemManager()
    private init() {}
    
    func processImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "Invalid image", code: -1, userInfo: nil)))
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation]
            let recognizedText = observations?
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: " ")

            if let question = recognizedText, !question.isEmpty {
                let filteredQuestion = self.filterMathCharacters(from: question)
                if !filteredQuestion.isEmpty {
                    completion(.success(filteredQuestion))
                } else {
                    completion(.failure(NSError(domain: "No valid math characters detected", code: -2, userInfo: nil)))
                }
            } else {
                completion(.failure(NSError(domain: "Math problem not detected", code: -2, userInfo: nil)))
            }
        }

        do {
            try requestHandler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
    
    private func filterMathCharacters(from text: String) -> String {
        let mathPattern = "[0-9\\+\\-\\*/=\\(\\)\\.]+"
        let regex = try? NSRegularExpression(pattern: mathPattern, options: [])
        let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        
        let filteredText = matches?.compactMap { match -> String? in
            guard let range = Range(match.range, in: text) else { return nil }
            return String(text[range])
        }.joined(separator: " ") ?? ""
        
        return filteredText
    }
    
    func callAIAPI(question: String, completion: @escaping (Result<String, Error>) -> Void) {
        let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        let parameters: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant that solves math problems."],
                ["role": "user", "content": "Solve the following math problem: \(question)"]
            ],
            "temperature": 0.7,
            "max_tokens": 100
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received from API", code: -3, userInfo: nil)))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let choices = json["choices"] as? [[String: Any]],
                      let message = choices.first?["message"] as? [String: Any],
                      let content = message["content"] as? String else {
                    completion(.failure(NSError(domain: "Expected data not found in response", code: -4, userInfo: nil)))
                    return
                }

                completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
