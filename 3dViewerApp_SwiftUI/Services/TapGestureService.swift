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
    
    var onNodeTapped: ((SCNNode) -> Void)?
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let sceneView = gestureRecognizer.view as! SCNView
        let location = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if let hitResult = hitResults.first {
            let tappedNode = hitResult.node
            tappedObjectName = tappedNode.name
            print("Tapped object: \(tappedObjectName ?? "Unnamed Node")")
            
            //onNodeTapped?(tappedNode)
            checkForNode(tappedNode: tappedNode)
        }
    }
    
    private func checkForNode(tappedNode: SCNNode) {
        if tappedObjectName != "slide" {
            if (tappedNode.geometry?.materials.isEmpty) != nil {
                /// Change the texture of the tapped node
               addMaterialNode(tappedNode: tappedNode)
            }
            
            if !containsLightNode(tappedNode: tappedNode) {
                /// Create a light node
                cretaeLightNode(tappedNode: tappedNode)
            }
            else {
                removeLightNode(from: tappedNode)
                addMaterialNode(tappedNode: tappedNode)
            }
        }
    }
    
    private func addMaterialNode(tappedNode: SCNNode) {
        let newMaterial = SCNMaterial()
        newMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.5)  // Change to your desired texture
        tappedNode.geometry?.materials = [newMaterial]
    }
    
    private func containsLightNode(tappedNode: SCNNode) -> Bool {
        for childNode in tappedNode.childNodes {
            if childNode.light != nil {
                return true
            }
        }
        return false
    }
    
    private func cretaeLightNode(tappedNode: SCNNode) {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni  // Use .spot for a spotlight effect
        lightNode.light?.intensity = 10000.0 // Adjust intensity as needed
        lightNode.light?.color = tappedObjectName == "bulb_top" ? UIColor.white.withAlphaComponent(0.5) : UIColor.red.withAlphaComponent(0.5)// Adjust color as needed
        lightNode.position = tappedNode.position
        tappedNode.addChildNode(lightNode)
    }
    
    private func removeLightNode(from tappedNode: SCNNode) {
        // Remove the existing light node
        tappedNode.childNodes.forEach { childNode in
            if childNode.light != nil {
                childNode.removeFromParentNode()
            }
        }
    }
}
