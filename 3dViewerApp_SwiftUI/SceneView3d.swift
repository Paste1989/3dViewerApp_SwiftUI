//
//  SceneView3d.swift
//  3dViewerApp_SwiftUI
//
//  Created by Saša Brezovac on 11.01.2024..
//

import SwiftUI
import SceneKit

struct SceneView3d: View {
    @State var scene: SCNScene? = .init(named: "slide.scn")
    
    //MARK: - View Properties
    @State var isVerticalLook: Bool = false
    @GestureState var offset: CGFloat = 0
    //MARK: - Custom Properties
    @State var isSliderInUse: Bool = false
    @State var degrees: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HeaderView()
            
            Viewer3d(scene: $scene)
                .frame(height: 350)
                .padding(.top, -50)
                .padding(.bottom, -15)
                .zIndex(-10)
            
            CustomSlider()
            
            //MARK: - Custom Part
            Slider(value: $degrees, in: 0...3.15)
                .frame(width: 200)
                .onChange(of: degrees) { newValue in
                   rotate3DModelBySlider()
                }
            
            HStack(spacing: 0) {
                Button {
                    rotate3DmodelByButton()
                } label: {
                    Text("Turn around 3D model")
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .padding()
    }
    
    
    //MARK: - Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 0) {
            
            Button {
                //go back
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous).fill(.white.opacity(0.2))
                    }
            }
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) { isVerticalLook.toggle() }
            } label: {
                Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
                    .rotationEffect(.init(degrees: isVerticalLook ? 0 : 90))
                    .frame(width: 42, height: 42)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous).fill(.white.opacity(0.2))
                    }
            }
        }
    }
    
    //MARK: - Custom Slider
    @ViewBuilder
    func CustomSlider() -> some View {
        GeometryReader{ _ in
            Rectangle()
                .trim(from: 0, to: 0.474)
                .stroke(.linearGradient(colors: [
                    .clear,
                    .clear,
                    .white.opacity(0.2),
                    .white.opacity(0.6),
                    .white,
                    .white.opacity(0.6),
                    .white.opacity(0.2),
                    .clear,
                    .clear
                ], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [3], dashPhase: 1))
                .offset(x: offset)
                .overlay {
                    //MARK: - Seeker View
                    HStack(spacing: 3) {
                        Image(systemName: "arrowtriangle.left")
                            .font(.caption)
                        
                        Image(systemName: "arrowtriangle.right")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                    }
                    .offset(y: -12)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { value, out, _ in
                                out = value.location.x - 20
                            })
                    )
                }
        }
        .frame(height: 20)
        .onChange(of: offset) { newValue in
            roatate3dModel(animate: offset == .zero)
        }
        .animation(.easeInOut(duration: 0.4), value: offset == .zero)
        .padding(.vertical, 50)
    }
    
    //MARK: - Rotating 3d model
    func roatate3dModel(animate: Bool = false) {
        if animate {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.4
        }
        
        let newAngle = (offset * .pi) / 180
        if isVerticalLook {
            scene?.rootNode.eulerAngles.y = Float(newAngle)
        }
        else {
            scene?.rootNode.eulerAngles.x = Float(newAngle)
        }
        
        if animate {
            SCNTransaction.commit()
        }
    }
    
    //MARK: - Custom - Rotating 3d model via Slider
    func rotate3DModelBySlider() {
        isSliderInUse = true
        
        if isSliderInUse {
            if isVerticalLook {
                scene?.rootNode.eulerAngles.y = Float(degrees)
            }
            else {
                scene?.rootNode.eulerAngles.x = Float(degrees)
            }
        }
    }
    
    //MARK: Custom - - Rotating 3d model via Button
    func rotate3DmodelByButton() {
        if scene?.rootNode.eulerAngles.y == 0 {
            scene?.rootNode.eulerAngles.y = Float(3.15)
        }
        else {
            scene?.rootNode.eulerAngles.y = Float(0)
        }
    }
}

#Preview {
    SceneView3d()
}
