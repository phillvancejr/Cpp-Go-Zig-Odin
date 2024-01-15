#include <AppKit/AppKit.h>
#include <MetalKit/MetalKit.h>
#include "metal-definitions.h"

auto width = 500.0f;
auto height = 500.0f;

id<MTLCommandQueue> command_queue;
id<MTLBuffer> vertex_buffer;
id<MTLRenderPipelineState> pipeline_state;

@interface App: NSObject<NSApplicationDelegate,MTKViewDelegate>
@end

@implementation App
-(bool) applicationShouldTerminateAfterLastWindowClosed: (NSApplication*) sender {
    return true;
}

-(void) mtkView: (MTKView*) view 
        drawableSizeWillChange: (CGSize) size {}

-(void) drawInMTKView: (MTKView*) view {
    auto command_buffer = [command_queue commandBuffer];
    auto render_pass_descriptor = [view currentRenderPassDescriptor];
    render_pass_descriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.2,0.3,0.3,1);
    // render_pass_descriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    // render_pass_descriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    auto encoder = [command_buffer renderCommandEncoderWithDescriptor: render_pass_descriptor];

    [encoder setRenderPipelineState: pipeline_state];
    [encoder    setVertexBuffer: vertex_buffer
                offset: 0
                atIndex: 0];
    [encoder    drawPrimitives: MTLPrimitiveTypeTriangle
                vertexStart: 0
                vertexCount: 3];

    [encoder endEncoding];
    auto drawable = [view currentDrawable];
    [command_buffer presentDrawable: drawable];
    [command_buffer commit];
}
@end

int main() {
    auto frame = NSMakeRect(0,0,width,height);
    auto window = [[NSWindow alloc] initWithContentRect: frame
                                    styleMask: NSWindowStyleMaskTitled | NSWindowStyleMaskClosable
                                    backing: NSBackingStoreBuffered
                                    defer: false];

    // initialize
    auto device = MTLCreateSystemDefaultDevice();
    command_queue = [device newCommandQueue];
    auto app = [[App alloc] init];
    // vertices
    auto vertices = {
        Vertex{{-0.5f, -0.5f}}, // left  
        Vertex{{ 0.5f, -0.5f}}, // right 
        Vertex{{ 0.0f,  0.5f}} // top 
    };
    // initialize buffer with data
    vertex_buffer = [device newBufferWithBytes: vertices.begin()
                            length: vertices.size() * sizeof(decltype(vertices)::value_type) // C++ decltype magic
                            options: MTLResourceCPUCacheModeDefaultCache];
    /*
    Note that above I used a std::initializer_list<Vertex> to hold the vertices and thus used ::begin and the ::size * T::value_type
    If I had used a simple Vertex[] array instead I could have used &vertices and sizeof vertices
    */
    // load shaders
    auto pipeline_descriptor = [[MTLRenderPipelineDescriptor alloc] init];
    NSError* err = nullptr;

    auto library = [device  newLibraryWithURL: [NSURL URLWithString: @"shaders.metallib"]
                            error: &err];

    if (err != nullptr) {
        puts("ERROR!");
    }

    [pipeline_descriptor setVertexFunction: [library newFunctionWithName: @"vs"]];
    [pipeline_descriptor setFragmentFunction: [library newFunctionWithName: @"fs"]];
    pipeline_descriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;

    err = nullptr;
    pipeline_state = [device    newRenderPipelineStateWithDescriptor: pipeline_descriptor 
                                error: &err];

    if (err != nullptr) {
        puts("ERROR!");
    }

    [window setTitle: @"C++ Metal"];
    [window makeKeyAndOrderFront: nullptr];
    [window center];
    auto metal_view = [[MTKView alloc]  initWithFrame: frame
                                        device: device];
    [metal_view setDelegate: app];
    [metal_view setNeedsDisplay: false];
    [window setContentView: metal_view];

    [NSApp setActivationPolicy: NSApplicationActivationPolicyRegular];
    [NSApp activateIgnoringOtherApps: true];
    [[NSApplication sharedApplication] setDelegate: app];
    [[NSApplication sharedApplication] run];
    
}