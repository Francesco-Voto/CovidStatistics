//
//  ProgressIndicator.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 04/05/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import SwiftUI

struct ProgressPolygonShape: Shape {
    var sides: Double = 7
    var scale: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set {
            sides = newValue.first
            scale = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0 * scale
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = sides != Double(Int(sides)) ? 1 : 0
        
        var vertex: [CGPoint] = []
        
        for i in 0..<Int(sides) + extra {
            
            let angle = (Double(i) * (360.0 / sides)) * (Double.pi / 180)
            
            // Calculate vertex
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            vertex.append(pt)
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        // Draw vertex-to-vertex lines
        drawVertexLines(path: &path, vertex: vertex, n: 0)
        
        return path
    }
    
    func drawVertexLines(path: inout Path, vertex: [CGPoint], n: Int) {
        
        if (vertex.count - n) < 3 { return }
        
        for i in (n+2)..<min(n + (vertex.count-1), vertex.count) {
            path.move(to: vertex[n])
            path.addLine(to: vertex[i])
        }
        
        drawVertexLines(path: &path, vertex: vertex, n: n+1)
    }
}

struct ProgressIndicator: View {

    var callback: () -> Void
    
    @State private var animationForward: Bool = true
    
    @State private var sides: Double = 0
    @State private var scale: Double = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
        ProgressPolygonShape(sides: sides, scale:scale)
                .stroke(Color.blue, lineWidth: 2)
                .animation(Animation
                    .easeInOut
            .speed(0.5))
                .layoutPriority(1)
        }.onReceive(timer) { time in
            
            if(self.sides == 6 && !self.animationForward){
                self.sides = 0
                return;
            }
            
            if(self.sides == 6 && self.animationForward){
                self.sides = 12
                return;
            }
            
            if(self.sides == 0 && !self.animationForward) {
                self.callback()
                self.sides = 6
                self.animationForward.toggle()
                return
            }
            
            if(self.sides == 0 && self.animationForward) {
                self.sides = 6
                return
            }
            
            
            if(self.sides == 12) {
                 self.sides = 6
                self.animationForward.toggle()
             }


        }.onDisappear(){
            self.sides = 1
            self.timer.upstream.connect().cancel()
        }
        .frame(width: 120, height: 120)
            
    }
}

struct ProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicator(callback: { print("finished")})
    }
}
