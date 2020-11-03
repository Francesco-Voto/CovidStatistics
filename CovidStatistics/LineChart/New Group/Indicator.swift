//
//  Indicator.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 01/05/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import SwiftUI

struct Indicator: View {
    var body: some View {
        ZStack{
            Circle()
                .fill(Colors.secondary)
            Circle()
                .stroke(Colors.baseText, style: StrokeStyle(lineWidth: 4))
        }
        .frame(width: 14, height: 14)
        .shadow(color: Color.gray, radius: 4, x: 0, y: 4)
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        Indicator()
    }
}
