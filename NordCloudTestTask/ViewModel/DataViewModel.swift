//
//  DataViewModel.swift
//  NordCloudTestTask
//
//  Created by Apanasenko Mikhail on 04.05.2022.
//

import Foundation
import UIKit

class DataViewModel {

    private var data: [Data] = [Data]()

    var reloadCollectionView: (()->())?
    var noMissedCalls: (()->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }

    var cellsViewModels: [CellViewModel] = [CellViewModel]() {
        didSet {
            if cellsViewModels.isEmpty {
                noMissedCalls?()
            } else {
                reloadCollectionView?()
            }
        }
    }

    func createCellsViewModels(data: [Data]) {
        var result = [CellViewModel]()
        for d in data {
            let icon = d.state == .missed ? UIImage(named: "missed-call")! : UIImage()
            let duration = d.duration
            let name = d.client.name
            let phone = d.client.address
            let time = dateFormatter.string(from: d.created)
            let bottomSheetViewModel = BottomSheetViewModel(
                title: "Business number",
                label: d.businessNumber.label,
                number: d.businessNumber.number
            )

            result.append(
                CellViewModel(
                    callIcon: icon,
                    duration: duration,
                    name: name,
                    phone: phone,
                    time: time,
                    bottomSheetViewModel: bottomSheetViewModel
                )
            )
        }

        cellsViewModels = result
    }

    var numberOfCells: Int {
        return cellsViewModels.count
    }

    func getCellViewModel(at indexPath: IndexPath ) -> CellViewModel {
        return cellsViewModels[indexPath.row]
    }

    func getBottomSheetViewModel(at indexPath: IndexPath) -> BottomSheetViewModel {
        return cellsViewModels[indexPath.row].bottomSheetViewModel
    }

    func getData() {
        showLoading?()
        ApiClient().getData { [weak self] success, data in
            guard let `self` = self else { return }

            self.hideLoading?()
            if success, let data = data {
                self.saveData(data: data)
                self.createCellsViewModels(data: data)
            } else {
                if self.loadDataFromUserDefaults() {
                    self.createCellsViewModels(data: self.data)
                } else {
                    self.noMissedCalls?()
                }
            }
        }
    }

    private func saveData(data: [Data]) {
        self.data = data
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }

    private func loadDataFromUserDefaults() -> Bool {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Data].self, from: data) {
                self.data = decoded
                return true
            }
        }
        return false
    }
}
