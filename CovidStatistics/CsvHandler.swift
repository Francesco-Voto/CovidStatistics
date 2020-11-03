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
import Combine

class CsvHandler: NSObject {
    
    static func getCsv() -> Future<CSV, Error> {
        return Future<CSV, Error> { promise in
            do {
                let csvData = try String(contentsOf: NSURL(string: "https://raw.githubusercontent.com/sarscov2-it/data/master/nation_cumulative.csv")! as URL)
                let csv: CSV = try CSV(string: csvData)
                promise(.success(csv))
            } catch let error {
                promise(.failure(error))
            }
        }
    }
    
    static func parseCsv(csv: CSV) -> AnyPublisher<[String:String], Error>{

        return Record<[String:String], Error> { promise in
            do {
                var array = [[String:String]]()
                
                try csv.enumerateAsDict {
                    dict in array.append(dict)
                }
                
                for s in array {
                    promise.receive(s)
                }
            } catch let error {
                promise.receive(completion: .failure(error))
            }
            
            promise.receive(completion: .finished)
        }.eraseToAnyPublisher()
    }
    
    public func fetchCsv() -> AnyPublisher<[String:String], Error> {
        return CsvHandler.getCsv()
            .subscribe(on: DispatchQueue.global())
            .flatMap(CsvHandler.parseCsv)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

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
    
    private static func transformElement(element: CSV) -> Observable<[String: String]> {
        let observable = Observable<[String:String]>.create { observer in
            do{
                
                try element.enumerateAsDict {
                    dict in observer.onNext(dict)
                }
                
            } catch let error {
                observer.onError(error)
            }

            observer.onCompleted()
            
            return Disposables.create()
        }
        
        return observable
    }
    
    public static func parseCsv(csvElement: Observable<CSV>) -> Observable<[String:String]> {
        return csvElement
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap(transformElement)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
    
}

