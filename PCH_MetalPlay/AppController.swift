//
//  AppController.swift
//  PCH_MetalPlay
//
//  Created by Peter Huber on 2020-12-04.
//

import Cocoa
import Metal
import MetalKit

class AppController: NSObject {

    @IBOutlet weak var mtkView: MTKView!
    var renderer:Renderer!
    var lineRenderer:LineRenderer!
    
    // My own (converted from Apple's Objective-C) texture loading function
    func loadTextureUsingMetalKit(url:URL, device:MTLDevice) -> MTLTexture?
    {
        let loader = MTKTextureLoader(device: device)
        
        do {
            
            let texture = try loader.newTexture(URL: url, options: nil)
            return texture
        }
        catch {
            
            let alert = NSAlert(error: error)
            let _ = alert.runModal()
            return nil
        }
    }
    
    
    override func awakeFromNib() {
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else
        {
            print("Could not get Metal device!")
            return
        }
        
        print("My GPU is: \(defaultDevice)")
        
        // For fun, this is how to find ALL the GPUs available. On Macs, the MTLCreateSystemDefaultDevice() call above returns the "discrete" GPU (if any) which is usually the one we'll want if we're using Metal.
        let allDevices = MTLCopyAllDevices()
        var index = 1
        for nextDevice in allDevices
        {
            print("GPU #\(index): \(nextDevice)")
            index += 1
        }
        
        self.mtkView.device = defaultDevice
        
        
        
        /*
        guard let tempRenderer = Renderer(mtkView: self.mtkView) else
        {
            print("Renderer failed to intialize!")
            return
        }
        
        self.renderer = tempRenderer
        
        self.mtkView.delegate = renderer
 
        */
    }
    
    @IBAction func handleTest1(_ sender: Any) {
        
        self.mtkView.clearColor = MTLClearColorMake(0, 0.5, 1, 1)
        
        guard let tempRenderer = Renderer(mtkView: self.mtkView) else
        {
            print("Renderer failed to intialize!")
            return
        }
        
        self.renderer = tempRenderer
        
        self.mtkView.delegate = renderer
    }
    
    @IBAction func handleTest2(_ sender: Any) {
        
        self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1)
        
        guard let tempRenderer = Renderer(mtkView: self.mtkView) else
        {
            print("Renderer failed to intialize!")
            return
        }
        
        self.renderer = tempRenderer
        
        self.mtkView.delegate = renderer
    }
    
    @IBAction func handleTest3(_ sender: Any) {
        
        self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1)
        
        let vertices = [Vertex(color: [1,1,1,1], pos: [-0.5, -0.9]), Vertex(color: [1,1,1,1], pos: [0.0, 0.9])]
        
        guard let tempRenderer = LineRenderer(mtkView: self.mtkView, vertices: vertices) else
        {
            print("LineRenderer failed to intialize!")
            return
        }
        
        self.lineRenderer = tempRenderer
        
        self.mtkView.delegate = self.lineRenderer
    }
    
}
