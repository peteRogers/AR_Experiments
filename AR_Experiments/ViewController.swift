//
//  ViewController.swift
//  AR_Experiments
//
//  Created by Peter Rogers on 17/12/2021.
//

import UIKit
import RealityKit
import CoreMotion
import Combine

class ViewController: UIViewController {
    var arView:ARView!
    
    var sceneEventsUpdateSubscription: Cancellable!
    var dragon:Entity!
    var i = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView = ARView(frame: view.frame,
                        cameraMode: .nonAR,
                        automaticallyConfigureSession: false)
        view.addSubview(arView)
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 60
        
        let cameraAnchor = AnchorEntity(world: .zero)
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        makeDragon()
        
        sceneEventsUpdateSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            
            self.dragon.transform.rotation = simd_quatf(angle: Float(self.deg2rad(self.i)), axis:simd_make_float3(1,0, 0))
            self.i = self.i + 0.1
            print(self.i)
        }

        
    }
    
    
    func makeDragon(){
        do{
        dragon = try Entity.load(named: "vapourMist")
           // fatalError("not loading")
        
        }catch{
            
        }
        
       // loadAnimations()
        let dragonAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(dragonAnchor)
        dragon.transform.scale *= 0.05
        dragonAnchor.addChild(dragon)
       // dragon.transform.rotation = simd_quatf(angle: Float(deg2rad(180)), axis:simd_make_float3(1,0, 0))
        dragon.transform.translation = simd_make_float3(0,
                                                        0,
                                                        -0.3)
      //  dragon.transform.rotation = simd_quatf(angle: Float(deg2rad(180)), axis:simd_make_float3(1,0, 0))
     //   dragon.transform.rotation = simd_quatf(angle: Float(deg2rad(180)), axis:simd_make_float3(0,1, 1//))
//        subscribes.append(arView.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: dragon){event in
//            print("looped")
//            dragon.playAnimation(self.animationList[0], transitionDuration: 1, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
//            //komodo.
//
//
//        })
//
       // dragon.playAnimation(flyForward, transitionDuration: 1, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
//        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
//            if(self.l == true){
//                dragon.playAnimation(self.flyRight, transitionDuration: 1, blendLayerOffset: 0, separateAnimatedValue:false, startsPaused: false)
//                self.l = false
//                print("right")
//            }else{
//                dragon.playAnimation(self.flyLeft, transitionDuration: 1, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
//                self.l = true
//                print("left")
//            }
            
        dragon.playAnimation(dragon.availableAnimations[0].repeat(), transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue:false, startsPaused: false)

//        }
        
    }
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }


}

