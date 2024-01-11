//
//  TapGestureService.swift
//  3dViewerApp_SwiftUI
//
//  Created by Saša Brezovac on 11.01.2024..
//

import Foundation
import SwiftUI
import SceneKit

class TapGestureService: NSObject {
    @Binding var tappedObjectName: String?
    
    init(tappedObjectName: Binding<String?>) {
        _tappedObjectName = tappedObjectName
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let sceneView = gestureRecognizer.view as! SCNView
        let location = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if let hitResult = hitResults.first {
            let tappedNode = hitResult.node
            tappedObjectName = tappedNode.name
            print("Tapped object: \(tappedObjectName ?? "Unnamed Node")")
        }
    }
}
