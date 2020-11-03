//
//  SceneDelegate.swift
//  CovidStatistics
//
//  Created by Francesco Voto on 17/03/2020.
//  Copyright © 2020 Francesco Voto. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var valueArray = [ChartData]()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
//             let csv = CsvParser.getCsv()
//             CsvParser
//                 .parseCsv(csvElement: csv)
//                 .subscribe(
//                 onNext: { element in
//                    if self.valueArray.count == 0 {
//                        self.valueArray.append(ChartData(dataKey: "active", color: Color.yellow, points: [
//                            (element["active"]! as NSString).integerValue], label: "Active" ))
//
//                        self.valueArray.append(ChartData(dataKey: "self_quarantined", color: Color.pink, points: [
//                            (element["self_quarantined"]! as NSString).integerValue], label: "Self Quarantine" ))
//
//                        self.valueArray.append(ChartData(dataKey: "intensive_care", color: Color.red, points: [
//                                               (element["intensive_care"]! as NSString).integerValue], label: "Intensive Care" ))
//
//                        self.valueArray.append(ChartData(dataKey: "total_confirmed", color: Color.purple, points: [
//                                               (element["total_confirmed"]! as NSString).integerValue], label: "Total" ))
//                        self.valueArray.append(ChartData(dataKey: "hospitalized", color: Color.orange, points: [
//                                               (element["hospitalized"]! as NSString).integerValue], label: "Hospitalized" ))
//
//                        self.valueArray.append(ChartData(dataKey: "dead", color: Color.black, points: [
//                                                                  (element["dead"]! as NSString).integerValue], label: "Dead" ))
//
//                        self.valueArray.append(ChartData(dataKey: "tested", color: Color.gray, points: [
//                                                                  (element["tested"]! as NSString).integerValue], label: "Testesd" ))
//
//                        self.valueArray.append(ChartData(dataKey: "healed", color: Color.green, points: [
//                                                                                     (element["healed"]! as NSString).integerValue], label: "Healed" ))
//                    } else {
//                        for (key, value) in element {
//                            let index = self.valueArray.firstIndex(where: {$0.dataKey == key})
//
//                            if index != nil {
//                                self.valueArray[index!].points.append((value as NSString).integerValue)
//                        }
//
//                    }
//
//               }
//
//                 },
//                 onCompleted: {
//                    let view = ContentView(data: self.valueArray).environment(\.managedObjectContext, context)
//
//                    // Use a UIHostingController as window root view controller.
//                    if let windowScene = scene as? UIWindowScene {
//                        let window = UIWindow(windowScene: windowScene)
//                        window.rootViewController = UIHostingController(rootView: view)
//                        self.window = window
//                        window.makeKeyAndVisible()
//                    }
//
//                    }
//        ).disposed(by: disposeBag)
        
        let view = ContentView().environment(\.managedObjectContext, context)
        
                            if let windowScene = scene as? UIWindowScene {
                                let window = UIWindow(windowScene: windowScene)
                                window.rootViewController = UIHostingController(rootView: view)
                                self.window = window
                                window.makeKeyAndVisible()
                            }
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

struct SceneDelegate_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
