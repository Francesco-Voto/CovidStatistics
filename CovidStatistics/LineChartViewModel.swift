//
//  LineChartViewModel.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 23/04/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import RxSwift

final class LineChartViewModel {

    private let disposeBag = DisposeBag()
    var data:  [ChartData]
    
    init() {
         let csv = CsvParser.getCsv()
         CsvParser
             .parseCsv(csvElement: csv)
             .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
             .flatMap((element: [[String: String]]) -> Observable<ChartData> {
                
                })
             .subscribe(
             onNext: { element in
               print(element)
               data = element
           },
             onCompleted: {
             
           }
         ).disposed(by: disposeBag)
    }
}
