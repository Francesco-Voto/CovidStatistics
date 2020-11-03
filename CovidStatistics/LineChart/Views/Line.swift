//
//  Line.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 21/04/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//
import SwiftUI
import Combine

struct Line: View {
    
    private(set) var points: [(CGPoint)]
    
    var stroke: Int
    var color: Color
    var tapGesture: () -> Void
    
    @State private var showFull: Bool = false
    
    @Binding var showIndicator: Bool
    @Binding var selectedPoint: Int
    
    private var positiveSelectedPoint: Binding<Int> {
         Binding<Int>(get: {
             return self.selectedPoint >= 0 ? self.selectedPoint : 0
         }, set: {
            self.selectedPoint = $0
         })
     }

    
    init(data: [Int], stepX: CGFloat = .zero, stepY: CGFloat = .zero, stroke: Int, color: Color, tapGesture: @escaping () -> Void, selectedPoint: Binding<Int>, showIndicator: Binding<Bool>) {
        self.points = Line.line(data: data, step: CGPoint(x: stepX, y: stepY))
        
        self.color = color
        self.stroke = stroke
        self.tapGesture = tapGesture
        
        self._showIndicator = showIndicator
        self._selectedPoint = selectedPoint
        
    }
    
    static func line (data:[Int], step:CGPoint) -> [CGPoint] {
        var pointsArray = [CGPoint]()
        if (data.count < 0){
            return []
        }
        guard let offset = data.min() else { return [] }
        
        for i in 0..<data.count {
            let p = CGPoint(x: step.x * CGFloat(i), y: step.y * CGFloat(data[i]-offset))
            pointsArray.append(p)
        }
        return pointsArray
    }
    
    var path: Path {
        var path = Path()
        if(self.points.count < 2) {
            return path
        }
        
        path.move(to: self.points[0])
        
        for i in 1..<self.points.count {
            path.addLine(to: self.points[i])
        }
        return path
    }
    
    public var body: some View {
        ZStack {
            self.path
                .trim(from: 0, to: self.showFull ? 1:0)
                .stroke(self.color ,style: StrokeStyle(lineWidth: CGFloat(self.stroke), lineJoin: .round))
                .onTapGesture {
                    self.tapGesture()
            }
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .animation(Animation.easeOut(duration: 1.2))
            .onAppear {
                self.showFull = true
            }
            .drawingGroup()
            if(self.showIndicator) {
                Indicator()
                    .position(x: self.points[self.positiveSelectedPoint.wrappedValue].x, y: self.points[self.positiveSelectedPoint.wrappedValue].y)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
}


struct Line_Previews: PreviewProvider {
    @State var location = CGPoint(x: 0, y: 0)
    
    static var previews: some View {
        Text("View")
        
    }
}
