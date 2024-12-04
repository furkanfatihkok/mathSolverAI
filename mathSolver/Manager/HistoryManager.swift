//
//  HistoryManager.swift
//  mathSolver
//
//  Created by FFK on 3.12.2024.
//

import UIKit
import FirebaseFirestore

final class HistoryManager {
    static let shared = HistoryManager()
    private let database = Firestore.firestore()

    private init() {}

    func saveSolution(_ solution: Solution, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try database.collection("history").document(solution.id).setData(from: solution) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    func fetchHistory(completion: @escaping (Result<[Solution], Error>) -> Void) {
        database.collection("history")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let solutions = snapshot?.documents.compactMap { document in
                        try? document.data(as: Solution.self)
                    } ?? []
                    completion(.success(solutions))
                }
            }
    }
}
