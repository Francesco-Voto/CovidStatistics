//
//  CsvParser.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 25/03/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import Foundation
import SwiftCSV
import RxSwift

class CsvParser: NSObject {
    
    public static func getCsv() -> Observable<CSV> {
        
        let observable = Observable<CSV>.create { observer in
            do {
                DispatchQueue.global().async{
                    do {
                        let url = NSURL(string: "https://raw.githubusercontent.com/sarscov2-it/data/master/nation_cumulative.csv")! as URL
                           let csv = try String(contentsOf: url)
                           let csvFile: CSV = try CSV(string: csv)
                        
                        observer.onNext(csvFile)
                        
                    } catch let error {
                        
                        observer.onError(error)
                    }
                    
                    observer.onCompleted()
                }
        }
            return Disposables.create()
    }
        
        return observable
    }
    
//    private static func transformElement(element: [String : [String]]) -> Observable<Data> {
//        return Observable.just(Data())
////            date: element["date"],
////            hospitalized: element["hospitalized"],
////            intensive: element["intensive"],
////            selfQuarantine: element["selfQuarantine"],
////            active: element["active"],
////            healed: element["healed"],
////            dead: element["dead"],
////            total: element["total"],
////            tested: element["tested"],
//        
//    }
    
//    public static func parseCsv(csvElement: Observable<[String : [String]]>) -> Observable<Data> {
//        return csvElement
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .flatMap(transformElement)
//            .observeOn(MainScheduler.instance)
//    }
    
}
