#include <metal_stdlib>
using namespace metal;

#include "metal-definitions.h"

struct Fragment {
    float4 pos [[position]];
    float4 color;
};

vertex Fragment vs(const device  Vertex* vertices [[buffer(0)]], unsigned int id [[vertex_id]]) {
    Vertex v = vertices[id];
    return {
        .pos = float4(v.pos, 0, 1),
        .color = float4(1.0, 0.5, 0.2, 1.0)
    };
}

fragment float4 fs(Fragment in [[stage_in]]) {
    return in.color;
}