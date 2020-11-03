//
//  ChartData.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 22/04/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import SwiftUI

struct ChartData: Hashable {
    
    let dataKey: String
    let color: Color
    var points: [Int]
    let label: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dataKey)
    }
}
