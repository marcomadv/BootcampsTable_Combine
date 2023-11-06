//
//  GetBootcamps.swift
//  TableBootCamps_KC
//
//  Created by Marco Muñoz on 4/11/23.
//

import Foundation
import Combine

final class ApiProvider: ObservableObject {
    
    @Published var bootcamps: [BootcampsModel] = Array<BootcampsModel>()
    private var suscriptor = Set<AnyCancellable>()
    
    private let urlBootcamps = "https://dragonball.keepcoding.education/api/data/bootcamps"
    
    func getBootcamps() {
        let url = URL(string: urlBootcamps)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {
                if $0.response.getStatusCode() == 200 {
                    return $0.data
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .decode(type: [BootcampsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .replaceError(with: Array<BootcampsModel>())
            .sink(receiveValue: {
                self.bootcamps = $0})
            .store(in: &suscriptor)
    }
}

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}

