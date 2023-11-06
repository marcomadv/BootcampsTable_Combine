//
//  TableViewModel.swift
//  TableBootCamps_KC
//
//  Created by Marco Muñoz on 5/11/23.
//

import Foundation
import Combine

final class TableViewModel {
    
    var apiProvider = ApiProvider()
    private var suscriptor: Set<AnyCancellable> = []
    
    @Published var bootcampsModel: [BootcampsModel] = []
    
    func onViewAppear() {
        apiProvider.getBootcamps()
        apiProvider.$bootcamps
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data  in
                self?.bootcampsModel = data })
            .store(in: &suscriptor)
    }
}

