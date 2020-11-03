//
//  Legenda.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 30/04/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import SwiftUI

struct Legenda: View {
    
    var data: [ChartData]
    
     public var body: some View {
        HStack {
            ForEach(0 ..< 2, id: \.self) { row in
                VStack(alignment: .leading) {
                    ForEach(0 ..< self.data.count/2, id: \.self) { column in
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(self.data[column + (row * 4)].color)
                                    .frame(width: 24, height: 24)
                                    .animation(.linear)
                                    .shadow(color: Color.gray, radius: 4, x: 0, y: 8)
                                    .onTapGesture {
                                        
                                    }
                                    
                                Text(self.data[column + (row * 4)].label)
                                    .bold()
                                    .font(.system(size: 16))
                                    .foregroundColor(Colors.inverseText)
                                    }
                    }
                        }
                    }
                }
            }
        }


struct Legenda_Previews: PreviewProvider {
    static var previews: some View {
        Legenda(data: [])
    }
        
    }


    

