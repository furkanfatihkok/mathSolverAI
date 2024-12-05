//
//  HistoryViewModel.swift
//  mathSolver
//
//  Created by FFK on 3.12.2024.
//

import Foundation

final class HistoryViewModel {
    private var groupedSolutions: [String: [Solution]] = [:]
    private var sortedKeys: [String] = []
    
    func saveSolution(_ solution: Solution, completion: @escaping (Result<Void, Error>) -> Void) {
        print("saveSolution called for solution: \(solution)") 
        HistoryManager.shared.saveSolution(solution) { result in
            switch result {
            case .success:
                print("Solution saved successfully.")
                completion(.success(()))
            case .failure(let error):
                print("Error saving solution: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteAllSolutions(completion: @escaping (Result<Void, Error>) -> Void) {
        HistoryManager.shared.deleteAllSolutions { [weak self] result in
            switch result {
            case .success:
                self?.groupedSolutions.removeAll()
                self?.sortedKeys.removeAll()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteSolution(_ solution: Solution, completion: @escaping (Result<Void, Error>) -> Void) {
        HistoryManager.shared.deleteSolution(solution) { [weak self] result in
            switch result {
            case .success:
                self?.groupedSolutions.forEach { (key, solutions) in
                    self?.groupedSolutions[key] = solutions.filter { $0.id != solution.id }
                }
                self?.sortedKeys = self?.groupedSolutions.keys.sorted(by: { $0 > $1 }) ?? []
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
 
    func fetchHistory(completion: @escaping (Result<Void, Error>) -> Void) {
        HistoryManager.shared.fetchHistory { [weak self] result in
            switch result {
            case .success(let solutions):
                self?.groupedSolutions = Dictionary(grouping: solutions) { solution -> String in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, yyyy"
                    return dateFormatter.string(from: solution.timestamp)
                }
                self?.sortedKeys = self?.groupedSolutions.keys.sorted(by: { $0 > $1 }) ?? []
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getGroupedSolutions() -> [String: [Solution]] {
        return groupedSolutions
    }

    func getSortedKeys() -> [String] {
        return sortedKeys
    }
}
