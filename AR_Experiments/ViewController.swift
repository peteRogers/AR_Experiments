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
    var eventSubscription: Cancellable!
    var dragon:Entity!
    var i = 0.0
    var inc = 0
    var licking:AnimationResource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createARView()
        createCamera()
        makeKomodo()
       
        //adds tap detection for use interaction
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        eventSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            //*** ADD CODE THAT RUNS EVERY FRAME - SUPER PRECISE
            
        }
    }
    
    func createARView(){
        //creates non ar i.e. no real world camera etc, so its like a normal 3D view
        arView = ARView(frame: view.frame,
                        cameraMode: .nonAR,
                        automaticallyConfigureSession: false)
       
        view.addSubview(arView)
    }
    
    
    func createCamera(){
        
        //this code creates a camera the values should chnage to configure where the camera should point
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 60
        camera.orientation = simd_quatf(angle: Float(self.deg2rad(-28)),
                                        axis: [1,0,0])
        
        camera.transform.translation = simd_make_float3(0,
                                                        0.4,
                                                        0.4)
        let cameraAnchor = AnchorEntity(world: .zero)
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
    }
    
  
    
    
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: arView)
        //not elegant but it plays the next animation on the tap using inc variable
        if arView.entity(at: tapLocation) != nil{
            if(inc == 0){
                inc = 1
                dragon.playAnimation(dragon.availableAnimations[0].repeat(), transitionDuration: 2, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
            }else{
                inc = 0
                dragon.playAnimation(licking, transitionDuration: 2, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
            }
        }
    }
    
    
    func makeKomodo(){
        //loads komodo model with the texture surface and creates collision shapes needed for tap testing
        do{
            dragon = try Entity.load(named: "vapourMist")
            dragon.generateCollisionShapes(recursive: true)
            
        }catch{
            print("why no loading komodo walking?")
        }
        
        // I just want the animation here
        licking = try? Entity.load(named: "komodoLicking").availableAnimations.first!.repeat()
        //set the position and size for the dragon
        let dragonAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(dragonAnchor)
        dragon.transform.scale *= 0.3
        dragon.transform.translation = simd_make_float3(0,
                                                        0,
                                                        -0.3)
        dragonAnchor.addChild(dragon)
        //play other loaded animation on textured model (clever)!
        dragon.playAnimation(licking!, transitionDuration: 0, blendLayerOffset: 0, separateAnimatedValue: false, startsPaused: false)
    }
    
    
        func deg2rad(_ number: Double) -> Double {
            return number * .pi / 180
        }
}

