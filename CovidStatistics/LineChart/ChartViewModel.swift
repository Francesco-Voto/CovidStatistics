//
//  ChartViewModel.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 02/05/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

extension Notification.Name {
    static let point = Notification.Name("point")
    static let index = Notification.Name("index")
    static let selected = Notification.Name("selected")
}

final class ChartViewModel: ObservableObject {
    
     private var cancelBag = Set<AnyCancellable>()
     private let csvHandler: CsvHandler
    
    @Published private(set) var statistics: [ChartData]
    @Published private(set) var loading: Bool
    
    @Published private(set) var currentValue: String
    @Published private(set) var showIndicatorValue: Bool
    
    private var selectedStatistic: ChartData?
    
    init(csvHandler: CsvHandler = CsvHandler()) {
        self.csvHandler = csvHandler
        self.statistics = [ChartData]()
        self.loading = true
        self.currentValue = "--"
        self.showIndicatorValue = false
        
        NotificationCenter.Publisher(center: .default, name: .selected, object: nil)
        .sink { [weak self]  notification in
            guard let self = self else { return }
            self.selectedStatistic = notification.object as? ChartData
            self.showIndicatorValue = self.selectedStatistic != nil
            self.currentValue = "--"
            
        }.store(in: &cancelBag)
        
        NotificationCenter.Publisher(center: .default, name: .point, object: nil)
        .sink { [weak self] notification in
            guard let self = self else { return }
            
            let index = notification.object as! Int
            
            guard index >= 0 else { return }
            
            guard let value = self.selectedStatistic?.points[index] else {
                 self.currentValue = "--"
                 return
            }
            self.currentValue = "\(String(describing: value))"
            
        }.store(in: &cancelBag)

    }
    
    func parseStatistics (element: [String: String]) {
             if self.statistics.count == 0 {
                self.statistics.append(ChartData(dataKey: "active", color: Colors.purple, points: [
                        (element["active"]! as NSString).integerValue], label: "Active" ))
            
                self.statistics.append(ChartData(dataKey: "self_quarantined", color: Colors.blue, points: [
                        (element["self_quarantined"]! as NSString).integerValue], label: "Self Quarantine" ))
            
                self.statistics.append(ChartData(dataKey: "intensive_care", color: Colors.red, points: [
                        (element["intensive_care"]! as NSString).integerValue], label: "Intensive Care" ))
            
                self.statistics.append(ChartData(dataKey: "total_confirmed", color: Colors.yellow, points: [
                        (element["total_confirmed"]! as NSString).integerValue], label: "Total" ))
                
                self.statistics.append(ChartData(dataKey: "hospitalized", color: Colors.orange, points: [
                        (element["hospitalized"]! as NSString).integerValue], label: "Hospitalized" ))
            
                self.statistics.append(ChartData(dataKey: "dead", color:
                    Colors.brown, points: [
                        (element["dead"]! as NSString).integerValue], label: "Dead" ))
            
                self.statistics.append(ChartData(dataKey: "tested", color:
                    Colors.teal, points: [
                        (element["tested"]! as NSString).integerValue], label: "Testesd" ))
            
                self.statistics.append(ChartData(dataKey: "healed", color: Colors.green, points: [
                    (element["healed"]! as NSString).integerValue], label: "Healed" ))
            } else {
                for (key, value) in element {
                    let index = self.statistics.firstIndex(where: {$0.dataKey == key})
                    if index != nil {
                        self.statistics[index!].points.append((value as NSString).integerValue)
                    }
                }
        }
        self.loading = true
    }
    
    func fetchStatistics(){
        self.loading = true
        self.csvHandler
            .fetchCsv()
            .sink(receiveCompletion: { completion in
                           switch completion {
                           case .finished:
                            self.loading = true
                            break
                           case .failure( _):
                            self.loading = true
                            break
                           }
                       },
                  receiveValue: { valueReceived in self.parseStatistics(element: valueReceived) })
            .store(in: &cancelBag)

    }
}
