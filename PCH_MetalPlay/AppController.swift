//
//  AppController.swift
//  PCH_MetalPlay
//
//  Created by Peter Huber on 2020-12-04.
//

import Cocoa
import Metal
import MetalKit

let π:Double = 3.1415926535897932384626433832795

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
        
        let vertices = [Vertex(color: [1,1,1,1], pos: [-0.5, -0.9]), Vertex(color: [1,1,1,1], pos: [0.0, 0.9]), Vertex(color: [1,1,1,1], pos: [0.0, 0.9]), Vertex(color: [1,1,1,1], pos: [0.5, -0.9])]
        
        self.renderLines(vertices: vertices)
    }
    
    @IBAction func handleTest4(_ sender: Any) {
        
        // exercise 1.2(a), done with individual lines
        
        // white color
        let color:vector_float4 = [1.0, 1.0, 1.0, 1.0]
        
        let outerRadius:Float = 0.9
        let innerRadius:Float = 0.2
        
        let deltaTheta:Float = Float(2.0 * π / 5.0)
        
        var currentOuterAngle = Float(π / 2.0)
        var currentInnerAngle = currentOuterAngle + deltaTheta / 2.0
        
        var vertices:[Vertex] = []
        
        for _ in 0..<5
        {
            let innerPos:vector_float2 = [cos(currentInnerAngle) * innerRadius, sin(currentInnerAngle) * innerRadius]
            let outerPos1:vector_float2 = [cos(currentOuterAngle) * outerRadius, sin(currentOuterAngle) * outerRadius]
            let outerPos2:vector_float2 = [cos(currentOuterAngle + deltaTheta) * outerRadius, sin(currentOuterAngle + deltaTheta) * outerRadius]
            
            vertices.append(Vertex(color: color, pos: innerPos))
            vertices.append(Vertex(color: color, pos: outerPos1))
            vertices.append(Vertex(color: color, pos: innerPos))
            vertices.append(Vertex(color: color, pos: outerPos2))
            
            currentInnerAngle += deltaTheta
            currentOuterAngle += deltaTheta
        }
        
        self.renderLines(vertices: vertices)
    }
    
    @IBAction func handleTest5(_ sender: Any) {
        
        // exercise 1.2(b), done with individual lines
        
        // white color
        let color:vector_float4 = [1.0, 1.0, 1.0, 1.0]
        
        let outerRadius:Float = 0.9
        let innerRadius:Float = 0.2
        
        let deltaTheta:Float = Float(2.0 * π / 5.0)
        
        var currentOuterAngle = Float(π / 2.0)
        var currentInnerAngle = currentOuterAngle + deltaTheta / 2.0
        
        var vertices:[Vertex] = []
        
        for _ in 0..<5
        {
            let innerPos:vector_float2 = [cos(currentInnerAngle) * innerRadius, sin(currentInnerAngle) * innerRadius]
            let outerPos1:vector_float2 = [cos(currentOuterAngle) * outerRadius, sin(currentOuterAngle) * outerRadius]
            let outerPos2:vector_float2 = [cos(currentOuterAngle + deltaTheta) * outerRadius, sin(currentOuterAngle + deltaTheta) * outerRadius]
            
            vertices.append(Vertex(color: color, pos: innerPos))
            vertices.append(Vertex(color: color, pos: outerPos1))
            vertices.append(Vertex(color: color, pos: innerPos))
            vertices.append(Vertex(color: color, pos: outerPos2))
            
            vertices.append(Vertex(color: color, pos: [0, 0]))
            vertices.append(Vertex(color: color, pos: innerPos))
            
            vertices.append(Vertex(color: color, pos: [0, 0]))
            vertices.append(Vertex(color: color, pos: outerPos2))
            
            currentInnerAngle += deltaTheta
            currentOuterAngle += deltaTheta
        }
        
        self.renderLines(vertices: vertices)
    }
    
    func renderLines(vertices:[Vertex])
    {
        self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1)
        
        // let vertices = [Vertex(color: [1,1,1,1], pos: [-0.5, -0.9]), Vertex(color: [1,1,1,1], pos: [0.0, 0.9]), Vertex(color: [1,1,1,1], pos: [0.0, 0.9]), Vertex(color: [1,1,1,1], pos: [0.5, -0.9])]
        
        guard let tempRenderer = LineRenderer(mtkView: self.mtkView) else
        {
            print("LineRenderer failed to intialize!")
            return
        }
        
        tempRenderer.vertexBuffer = self.mtkView.device!.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        
        self.lineRenderer = tempRenderer
        
        self.mtkView.delegate = self.lineRenderer
    }
    
}
