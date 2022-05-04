//
//  Data.swift
//  NordCloudTestTask
//
//  Created by Apanasenko Mikhail on 02.05.2022.
//

import Foundation

struct Data: Codable {
    let id: String
    let state: State
    let client: Client
    let type: EventType
    let created: Date
    let businessNumber: BusinessNumber
    let origin: Origin
    let favorite: Bool
    let duration: String
}

extension Data {
    enum State: String, Codable {
        case missed
    }

    struct Client: Codable {
        let name: String?
        let address: String

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case address
        }
    }

    enum EventType: String, Codable {
        case call
    }

    struct BusinessNumber: Codable {
        let number: String
        let label: String
    }

    enum Origin: String, Codable {
        case inbound
    }
}
