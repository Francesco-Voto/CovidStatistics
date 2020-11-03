//
//  ChartView.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 01/05/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import SwiftUI


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .top).animation(.easeIn)
        let removal = AnyTransition.move(edge: .top)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct ChartView: View {
    @State var currentValue: Int = 0
    
    @ObservedObject var viewModel: ChartViewModel
    
    //    func callback() {
    //        self.loaderHasFinished = true
    //    }
    
    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
           Colors.primary
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                //            if(self.viewModel.loading && !self.loaderHasFinished) {
                //                ProgressIndicator(callback: self.callback)
                //            } else {
                
                Spacer()
                Legenda(data: self.viewModel.statistics)
                Spacer()
                LineChart(data:self.viewModel.statistics)
                    .padding(.horizontal, 16)
                    .frame(height: 400)
                Spacer()
                
            }.onAppear(){
                self.viewModel.fetchStatistics()
            }
            if(self.viewModel.showIndicatorValue) {
                ZStack(alignment: .center) {
                      Rectangle()
                          .frame(width: 248, height: 48)
                          .cornerRadius(24)
                          .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                          .foregroundColor(Color.white)
                          
                    Text(self.viewModel.currentValue)
                        .font(.system(size: 24))
                    .padding()
                  }
                .transition(.moveAndFade)
               
                }
            }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
