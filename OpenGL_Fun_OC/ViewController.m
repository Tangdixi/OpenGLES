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
>

@property (nonatomic, assign) GLuint program;
@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, assign) GLuint vbo;
@property (nonatomic, assign) GLuint ebo;

@property (nonatomic, assign) GLuint vao;
@property (nonatomic, assign) GLuint texture;

@property (nonatomic, assign) GLint currentTimeStamp;
@property (nonatomic, assign) CGFloat currentAngle;

@end

@implementation ViewController

GLuint vertexLocation = 0;
GLuint normalLocation = 1;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViews];
    [self setupGL];
}

#pragma mark - Private

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

- (void)setupVBO {
	
	GLfloat vertices[] = {
		
		-0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
		0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
		0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
		0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
		-0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
		-0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
		
		-0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
		0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
		0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
		0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
		-0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
		-0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
		
		-0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
		-0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
		-0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
		-0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
		-0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
		-0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
		
		0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
		0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
		0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
		0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
		0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
		0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
		
		-0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
		0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
		0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
		0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
		-0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
		-0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
		
		-0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
		0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
		0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
		0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
		-0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
		-0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
	};

	
	if (! self.vbo) {
		
		// 1. Generate buffer object
		//
		glGenBuffers(1, &_vbo);
		
		// 2. Binding
		//
		glBindBuffer(GL_ARRAY_BUFFER, self.vbo);
		glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * sizeof(vertices), vertices, GL_STATIC_DRAW);
	}
}

- (void)setupVAOs {
	
	[self setupVBO];
	
	if (! self.vao) {
		
		// 1. Generate vertex array object
		//
		glGenVertexArrays(1, &_vao);
		
		// 2. Binding
		//
		glBindVertexArray(self.vao);
		
		// 3. Assign the values
		//
		glBindBuffer(GL_ARRAY_BUFFER, self.vbo);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.ebo);
		
		glVertexAttribPointer(vertexLocation,
							  3,
							  GL_FLOAT,
							  GL_FALSE,
							  6 * sizeof(GLfloat),
							  0);
		glEnableVertexAttribArray(vertexLocation);
		
		glVertexAttribPointer(normalLocation,
							  3,
							  GL_FLOAT,
							  GL_FALSE,
							  6 * sizeof(GLfloat),
							  (void *)(sizeof(GLfloat) * 3));
		glEnableVertexAttribArray(normalLocation);
		
        [self setupLighting];
    }
    [self moveCamera];
}

- (void)moveCamera {

	// The mvp matrix
	//
	CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
	CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
	CGFloat aspectRatio = screenWidth/screenHeight;
	
	// Get uniform locations
	//
	GLint modelViewMatrixLocation = glGetUniformLocation(self.program, "modelViewMatrix");
	GLint modelViewProjectionMatrixLocation = glGetUniformLocation(self.program, "modelViewProjectionMatrix");
	GLint normalMatrixLocation = glGetUniformLocation(self.program, "normalMatrix");
	
	// Calculate the camera
	//
	self.currentAngle += degreedToRadius(1);
	if (self.currentAngle > (2.0 * M_PI)) {
		self.currentAngle = self.currentAngle - (2.0 * M_PI);
	}
	
	GLfloat radius = 3;
	GLfloat x = sinf(self.currentAngle) * radius;
	GLfloat z = cosf(self.currentAngle) * radius;
	
	GLKMatrix4 modelViewMatrix4 = GLKMatrix4MakeLookAt(x, 1.5, z,
												 0, 0, 0,
												 0, 1, 0);
	GLKMatrix4 projectionMatrix4 = GLKMatrix4MakePerspective(degreedToRadius(45.0),
															 aspectRatio,
															 0.1,
															 100);
	GLKMatrix4 modelViewProjectionMatrix4 = GLKMatrix4Multiply(projectionMatrix4, modelViewMatrix4);
	GLKMatrix4 normalMatrix4 = GLKMatrix4InvertAndTranspose(modelViewMatrix4, NULL);

	glUniformMatrix4fv(modelViewMatrixLocation, 1, GL_FALSE, modelViewMatrix4.m);
	glUniformMatrix4fv(modelViewProjectionMatrixLocation, 1, GL_FALSE, modelViewProjectionMatrix4.m);
	glUniformMatrix4fv(normalMatrixLocation, 1, GL_FALSE, normalMatrix4.m);
	
}

- (void)setupLighting {
    
    // The camera position is also the light source
    GLint cubeColorLocation = glGetUniformLocation(self.program, "ambientColor");
    GLKVector3 cubeColorVector3 = GLKVector3Make(0.1, 0.1, 0.1);
    glUniform3fv(cubeColorLocation, 1, cubeColorVector3.v);
    
    GLint lightColorLocation = glGetUniformLocation(self.program, "diffuseColor");
    GLKVector3 lightColorVector3 = GLKVector3Make(1, 133.0/255, 34.0/255);
    glUniform3fv(lightColorLocation, 1, lightColorVector3.v);
	
	GLint lightPositionLocation = glGetUniformLocation(self.program, "lightPosition");
	GLKVector3 lightPositionVector3 = GLKVector3Make(0.5, 0.5, 1.7);
	glUniform3fv(lightPositionLocation, 1, lightPositionVector3.v);
}

- (void)drawWithVAO {

	// Setup the vao if needed
	//
	[self setupVAOs];
    
	// Draw the elements
	//
	glBindVertexArray (self.vao);
	glDrawArrays(GL_TRIANGLES, 0, 36);
	glBindVertexArray(0);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    self.currentTimeStamp = (self.currentTimeStamp + 1) % 60;
    
    glViewport (0, 0,
                (int)self.glkView.drawableWidth, (int)self.glkView.drawableHeight);
    
    glClearColor(0, 0, 0, 1.0);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glUseProgram(self.program);
	
	glEnable(GL_DEPTH_TEST);
	
	[self setupVAOs];
	[self drawWithVAO];
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
