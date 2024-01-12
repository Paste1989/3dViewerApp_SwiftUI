//
//  3DSceneView.swift
//  3dViewerApp_SwiftUI
//
//  Created by Saša Brezovac on 11.01.2024..
//

import SwiftUI
import SceneKit

struct Viewer3d: UIViewRepresentable {
    @Binding var scene: SCNScene?
    @Binding var tappedObjectName: String?
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false // object rotating on true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:))))
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) { }
    
    func makeCoordinator() -> TapGestureService {
            TapGestureService(tappedObjectName: $tappedObjectName)
        }
}

#Preview {
    ContentView()
}
