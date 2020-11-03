//
//  ContentView.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 17/03/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack(alignment: .center) {
            ChartView(viewModel: ChartViewModel())
        }.background(Color.green)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       
        ContentView()
    }
}
