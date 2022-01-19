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
    var subscribes: [Cancellable] = []
    var eventSubscription: Cancellable!
    var dragon:Entity!
    var i = 0.0
    var inc = 0
    var sitting:AnimationResource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createARView()
        makeKomodo()
    }
    
    func createARView(){
        arView = ARView(frame: view.frame,
                        cameraMode: .nonAR,
                        automaticallyConfigureSession: false)
       
        view.addSubview(arView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        self.view.addGestureRecognizer(tap)
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 60
        camera.orientation = simd_quatf(angle: Float(self.deg2rad(-28)),
                                                                 axis: [1,0,0])
//        eventSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
//            camera.orientation = simd_quatf(angle: Float(self.deg2rad(-28)),
//                                                          axis: [1,0,0])
//
//            self.i = self.i - 0.2
//           //print(self.i)
//            if let d = self.dragon{
//
//            }
//        }
        camera.transform.translation = simd_make_float3(0,
                                                        0.4,
                                                        0.4)
        let cameraAnchor = AnchorEntity(world: .zero)
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
    }
    
 
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer){
       print("tapped")
        let tapLocation = sender.location(in: arView)
       
        if arView.entity(at: tapLocation) != nil{
                  
                    if(inc == 0){
                        inc = 1
                    dragon.playAnimation(dragon.availableAnimations[0].repeat(), transitionDuration: 2, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
                    }else{
                        inc = 0
                        dragon.playAnimation(sitting, transitionDuration: 2, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
                    }
                }
     }
    
    
    func makeKomodo(){
        do{
            dragon = try Entity.load(named: "komodoWalking")
            dragon.generateCollisionShapes(recursive: true)

        }catch{
            
        }
        sitting = try? Entity.load(named: "komodoLicking").availableAnimations.first!.repeat()
        let dragonAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(dragonAnchor)
        dragon.transform.scale *= 0.3
        dragonAnchor.addChild(dragon)
        dragon.transform.translation = simd_make_float3(0,
                                                        0,
                                                        -0.3)
        dragon.playAnimation(sitting!, transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
    }
    

    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }


}

