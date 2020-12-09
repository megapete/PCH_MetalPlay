//
//  LineRenderer.swift
//  PCH_MetalPlay
//
//  Created by Peter Huber on 2020-12-08.
//

import Cocoa
import Metal
import MetalKit

class LineRenderer: NSObject, MTKViewDelegate {
    
    var device:MTLDevice
    let commandQueue:MTLCommandQueue
    let pipelineState:MTLRenderPipelineState
    var vertexBuffer:MTLBuffer?
    
    init?(mtkView:MTKView)
    {
        self.device = mtkView.device!
        self.commandQueue = device.makeCommandQueue()!
        
        do {
            self.pipelineState = try LineRenderer.buildRenderPipelineWith(device: self.device, metalKitView: mtkView)
        }
        catch {
            print("Unable to compile render pipeline state! The error is: \(error)")
            return nil
        }
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
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        
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
        
        guard let vertexBuffer = self.vertexBuffer else
        {
            return
        }
        
        renderEncoder.setRenderPipelineState(self.pipelineState)
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        let vertexCount = vertexBuffer.length / MemoryLayout<Vertex>.stride
        let instanceCount = vertexCount / 2
        
        renderEncoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: vertexCount, instanceCount: instanceCount, baseInstance: 0)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        
        commandBuffer.commit()
        
    }
    

}
