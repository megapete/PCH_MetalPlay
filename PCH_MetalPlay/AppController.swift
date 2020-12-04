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
    
    override  func awakeFromNib() {
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else
        {
            print("Could not get Metal device!")
            return
        }
        
        print("My GPU is: \(defaultDevice)")
        self.mtkView.device = defaultDevice
        
        self.mtkView.clearColor = MTLClearColorMake(0, 0.5, 1, 1)
        
        guard let tempRenderer = Renderer(mtkView: self.mtkView) else
        {
            print("Renderer failed to intialize!")
            return
        }
        
        self.renderer = tempRenderer
        
        self.mtkView.delegate = renderer
    }
}
