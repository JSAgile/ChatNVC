//
//  API.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import Foundation
import DotEnv

var openAIKey: String {
    var env: DotEnv?

    if let url = Bundle.main.url(forResource: ".env", withExtension: nil) {
        do {
            env = try DotEnv.read(path: url.path)
            env?.load()
        } catch {
            print("Error loading .env file")
        }
    }

    guard let apiKey = ProcessInfo.processInfo.environment["OpenAI_API_KEY"] else {
        fatalError("Missing API Key environment variable")
    }
    
    return apiKey
}

enum APIError: Error {
    case urlSessionError(Error)
    case decodingError(Error)
    case serverError(String)
    case unknownError
}

struct APIResponse: Codable {
    struct Choice: Codable {
        let text: String
    }

    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

struct APIErrorResponse: Codable {
    struct ErrorDetail: Codable {
        let message: String
        let type: String
        let param: String?
        let code: String?
    }
    let error: ErrorDetail?
}

func getGPT3Response(prompt: String, completion: @escaping (Result<String, APIError>) -> ()) {
    let url = URL(string: "https://api.openai.com/v1/completions")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let json: [String: Any] = ["model": "text-davinci-003",
                               "prompt": prompt,
                               "temperature": 0.8,
                               "max_tokens": 3000]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    request.httpBody = jsonData

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error in URLSession dataTask: \(error)") // Debug print
            completion(.failure(.urlSessionError(error)))
        } else if let data = data {
            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")

            let decoder = JSONDecoder()
            if let response = try? decoder.decode(APIResponse.self, from: data),
               let result = response.choices.first?.text {
                completion(.success(result))
            } else if let response = try? decoder.decode(APIErrorResponse.self, from: data),
                      let errorMessage = response.error?.message {
                completion(.failure(.serverError(errorMessage)))
            } else {
                let decodingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data"])
                completion(.failure(.decodingError(decodingError)))
            }
        } else {
            completion(.failure(.unknownError))
        }
    }
    task.resume()
}
