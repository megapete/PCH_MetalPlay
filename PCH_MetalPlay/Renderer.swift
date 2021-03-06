//
//  Renderer.swift
//  PCH_MetalPlay
//
//  Created by Peter Huber on 2020-12-04.
//

import Cocoa
import Metal
import MetalKit


class Renderer: NSObject, MTKViewDelegate {
    
    let device:MTLDevice
    let commandQueue:MTLCommandQueue
    let pipelineState:MTLRenderPipelineState
    let vertexBuffer:MTLBuffer
    
    init?(mtkView:MTKView)
    {
        self.device = mtkView.device!
        self.commandQueue = device.makeCommandQueue()!
        
        do {
            self.pipelineState = try Renderer.buildRenderPipelineWith(device: self.device, metalKitView: mtkView)
        }
        catch {
            print("Unable to compile render pipeline state! The error is: \(error)")
            return nil
        }
        
        let vertices = [Vertex(color: [1,0,0,1], pos: [-1,-1]), Vertex(color: [0,1,0,1], pos: [0,1]), Vertex(color: [0,0,1,1], pos: [1,-1])]
        
        self.vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        
    }
    
    class func buildRenderPipelineWith(device:MTLDevice, metalKitView:MTKView) throws -> MTLRenderPipelineState
    {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        // makeDefaultLibrary creates a library using all of the compiled Metal shader files in the project
        let library = device.makeDefaultLibrary()
        
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "PCH_VertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "PCH_FragmentShader")
        
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        
    }
    
    func draw(in view: MTKView)
    {
        guard let commandBuffer = self.commandQueue.makeCommandBuffer() else
        {
            return
        }
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else
        {
            return
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else
        {
            return
        }
        
        renderEncoder.setRenderPipelineState(self.pipelineState)
        
        renderEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        
        commandBuffer.commit()
    }
    

}
