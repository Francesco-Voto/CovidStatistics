//
//  LineChart.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 21/04/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import SwiftUI

struct LineChart: View {
    
    var data: [ChartData]
    
    @State var selectedStatistic: ChartData? {
        didSet {
            NotificationCenter.default.post(name: .selected, object: selectedStatistic)
        }
    }
    
    @State var index: Int = -1 {
        didSet {
            NotificationCenter.default.post(name: .point, object: index)
        }
    }
    
    @State var showIndicator: Bool = false
    
    static var stepWidth: CGFloat = .zero
    static var stepHeight: CGFloat = .zero
    

    func stepX(size: CGSize) -> CGFloat {
        if self.data[0].points.count < 2 {
            LineChart.stepWidth = 0
            return 0
        }
        LineChart.stepWidth = size.width / CGFloat(self.data[0].points.count-1)
        return size.width / CGFloat(self.data[0].points.count-1)
    }
    
    func stepY(size: CGSize) -> CGFloat {
        var min: Int?
        var max: Int?
        
        if let globalMax = data.flatMap({ $0.points }).max(), let globalMin = data.flatMap({ $0.points }).min() {
            min = globalMin
            max = globalMax
            
            LineChart.stepHeight = size.height / CGFloat(max! + min!)
            return LineChart.stepHeight
        }
        
        LineChart.stepHeight = 0
        return 0
    }
    
    
    private func tapGesture (line: ChartData) {
        if self.selectedStatistic?.dataKey == line.dataKey {
            self.selectedStatistic = nil
        } else {
            self.selectedStatistic = line
        }
    }
    
    private func getStroke (line: ChartData) -> Int {
        if self.selectedStatistic == nil {
            return 4
        }
        
        if self.selectedStatistic?.dataKey == line.dataKey {
            return 7
        }

        return 2
    }
    
    private func getColor (line: ChartData) -> Color {
        if self.selectedStatistic == nil {
            return line.color
        }
        
        if self.selectedStatistic?.dataKey == line.dataKey {
            return line.color
        }

        return line.color.opacity(0.3)
    }
    
    private func getShowIndicator (line: ChartData) -> Binding<Bool> {
        if self.selectedStatistic?.dataKey == line.dataKey {
            return self.$showIndicator
        }

        return Binding<Bool>.constant(false)
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            ZStack{
                ForEach(self.data, id: \.self) {
                        chartData in
                        Line(
                            data: chartData.points,
                            stepX: self.stepX(size: geometry.frame(in: .local).size),
                            stepY: self.stepY(size: geometry.frame(in: .local).size),
                            stroke: self.getStroke(line: chartData),
                            color: self.getColor(line: chartData),
                            tapGesture: {
                                self.tapGesture(line: chartData)
                            },
                            selectedPoint: self.$index,
                            showIndicator: self.getShowIndicator(line: chartData)
                        )
                    }
   
                }
                    
                .frame(width: geometry.frame(in: .local).size.width, height: geometry.frame(in: .local).size.height)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Colors.primaryDark, lineWidth: 7)
                )
            .drawingGroup()
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.showIndicator = true
                        self.index = Int(floor((value.location.x-15) / LineChart.stepWidth))
                    })
                    .onEnded({ value in
                        self.showIndicator = false
                    })
            )
            
        }
        
    }
}

struct LineView_Previews: PreviewProvider {
    @State var selectedData: ChartData? = nil
    
    static var previews: some View {
        VStack() {
           Text("Ciao")
        }
        
    }
}
