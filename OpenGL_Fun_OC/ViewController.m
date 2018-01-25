//
//  ViewController.m
//  OpenGL_Fun_OC
//
//  Created by 汤迪希 on 24/01/2018.
//  Copyright © 2018 DC. All rights reserved.
//

#import "ViewController.h"
#import "GLUtility.h"

@interface ViewController () <
    GLKViewDelegate
> {
    GLuint vbo;
    GLuint ebo;
}

@property (nonatomic, assign) GLuint program;
@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) EAGLContext *context;

@end

@implementation ViewController

GLuint vertexLocation = 0;
GLuint colorLocation = 1;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViews];
    [self setupGL];
}

#pragma mark - Configuration

- (void)setupViews {
    self.view = self.glkView;
}

- (void)setupGL {

    [EAGLContext setCurrentContext:self.context];
    
    GLuint cubeVertexShader = [GLUtility lodaShaderWithName:@"cube_vertex"
                                                       type:GLUtilityShaderTypeVertex];
    
    GLuint cubeFragmentShader = [GLUtility lodaShaderWithName:@"cube_fragment"
                                                         type:GLUtilityShaderTypeFragment];
    
    self.program = [GLUtility programWithVertexShader:cubeVertexShader
                                       fragmentShader:cubeFragmentShader];
}

#pragma mark - Private

- (void)drawWithoutVBO {
    
    GLfloat vertices[9] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f,
    };
    
    glEnableVertexAttribArray(vertexLocation);
    glVertexAttribPointer(vertexLocation,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          vertices);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}

- (void)drawWithVBO {
    
    GLfloat vertices[3 * (3 + 4)] = {
        0.0f,  0.5f, 0.0f,
        1.0f,  0.0f, 0.0f, 1.0f,
        -0.5f, -0.5f, 0.0f,
        0.0f,  1.0f, 0.0f, 1.0f,
        0.5f, -0.5f, 0.0f,
        0.0f,  0.0f, 1.0f, 1.0f
    };
    
    GLushort indices[3] = {
        0, 1, 2
    };
    
    if (! vbo && ! ebo) {
     
        // 1. Generate buffer object
        //
        glGenBuffers(1, &vbo);
        glGenBuffers(1, &ebo);
        
        // 2. Binding
        //
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 21, vertices, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort) * 3 , indices, GL_STATIC_DRAW);
        
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    
    glVertexAttribPointer(vertexLocation,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          7 * sizeof(GLfloat),
                          0);
    glEnableVertexAttribArray(vertexLocation);
    
    glVertexAttribPointer(colorLocation,
                          4,
                          GL_FLOAT,
                          GL_FALSE,
                          7 * sizeof(GLfloat),
                          (const void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(colorLocation);
    
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, 0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glDisableVertexAttribArray(vertexLocation);
    glDisableVertexAttribArray(colorLocation);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (void)drawWithVAO {
    
    
    
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glViewport ( 0, 0, (int)self.glkView.drawableWidth, (int)self.glkView.drawableHeight);
    glClearColor(0.4, 0.4, 0.4, 1.0);
    glClear ( GL_COLOR_BUFFER_BIT );
    glUseProgram(self.program);
    
//    [self drawWithoutVBO];
    [self drawWithVBO];
}

#pragma mark - Lazy Loading

- (GLKView *)glkView {
    
    if (! _glkView) {
        _glkView = [[GLKView alloc] initWithFrame:self.view.bounds];
        _glkView.delegate = self;
        _glkView.context = self.context;
        _glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        _glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    }
    return _glkView;
}

- (EAGLContext *)context {
    
    if (! _context) {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    }
    return _context;
}

@end
