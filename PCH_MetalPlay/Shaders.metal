//
//  Shaders.metal
//  PCH_MetalPlay
//
//  Created by Peter Huber on 2020-12-04.
//

#include <metal_stdlib>
#include "ShaderDefinitions.h"
using namespace metal;

struct VertexOut {
    float4 color;
    float4 pos [[position]];
};

vertex VertexOut PCH_VertexShader(const device Vertex *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    Vertex in = vertexArray[vid];
    
    VertexOut out;
    
    out.color = in.color;
    
    out.pos = float4(in.pos.x, in.pos.y, 0, 1);
    
    return out;
}

fragment float4 PCH_FragmentShader(VertexOut interpolated[[stage_in]])
{
    return interpolated.color;
}

