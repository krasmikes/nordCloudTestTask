//
//  ApiClient.swift
//  NordCloudTestTask
//
//  Created by Apanasenko Mikhail on 02.05.2022.
//

import Foundation

struct ApiClient {
    private let url = URL(string: "https://5e3c202ef2cb300014391b5a.mockapi.io/testapi")
    private let session = URLSession.shared

    func getData(complition: @escaping (_ success: Bool, _ data: [Data]?) ->()) {
        guard let url = url else { return }

        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601Full
                if let dataDecoded = try? decoder.decode(ApiResponse.self, from: data) {
                    complition(true, dataDecoded.requests)
                } else {
                    complition(false, nil)
                }
            } else if let error = error {
                complition(false, nil)
            }
        }

        task.resume()
    }
}

struct ApiResponse: Decodable {
    let requests: [Data]
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601Full = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = DateFormatter.iso8601Full.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
