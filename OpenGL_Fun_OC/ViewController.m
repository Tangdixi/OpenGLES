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

@property (nonatomic, strong) UISlider *colorSlider;

@end

@implementation ViewController

GLuint vertexLocation = 0;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViews];
    [self setupGL];
    self.view.transform = CGAffineTransformIdentity;
}

#pragma mark - Actions

- (void)colorSliderValueChanged:(UISlider *)sender {
    [self setupLightingWithGreen:sender.value * 255];
}

#pragma mark - Private

- (void)setupViews {
    self.view = self.glkView;
    
    [self.view addSubview:self.colorSlider];
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
	
	GLfloat vertices[24] = {
		0.5f, 0.5f, 0.5f,
		-0.5f, 0.5f, 0.5f,
		-0.5f, -0.5f, 0.5f,
		0.5f, -0.5f, 0.5f,
        0.5f, 0.5f, -0.5f,
        -0.5f, 0.5f, -0.5f,
        -0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
	};
	
	GLushort indices[36] = {
		0, 3, 2, 0, 2, 1,
        0, 1, 5, 0, 5, 4,
        0, 4, 7, 0, 7, 3,
        1, 2, 6, 1, 6, 5,
        3, 2, 6, 3, 6, 7,
        6, 5, 7, 5, 4, 7
	};
	
	if (! self.vbo && ! self.ebo) {
		
		// 1. Generate buffer object
		//
		glGenBuffers(1, &_vbo);
		glGenBuffers(1, &_ebo);
		
		// 2. Binding
		//
		glBindBuffer(GL_ARRAY_BUFFER, self.vbo);
		glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * sizeof(vertices), vertices, GL_STATIC_DRAW);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.ebo);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort) * sizeof(indices) , indices, GL_STATIC_DRAW);
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
							  3 * sizeof(GLfloat),
							  0);
		glEnableVertexAttribArray(vertexLocation);
        
        [self activePerspective];
        [self setupLightingWithGreen:60];
    }
    [self moveCamera];
}

- (void)activePerspective {
    
    // The mvp matrix
    //
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    CGFloat aspectRatio = screenWidth/screenHeight;
    
    GLint modelMatrixLocation = glGetUniformLocation(self.program, "modelMatrix");
    GLKMatrix4 modelMatrix4 = GLKMatrix4MakeRotation(degreedToRadius(45), 0, 1.0, 0);
    glUniformMatrix4fv(modelMatrixLocation, 1, GL_FALSE, modelMatrix4.m);
    
    GLint viewMatrixLocation = glGetUniformLocation(self.program, "viewMatrix");
    GLKMatrix4 viewMatrix4 = GLKMatrix4MakeTranslation(0, 0, -3);
    glUniformMatrix4fv(viewMatrixLocation, 1, GL_FALSE, viewMatrix4.m);
    
    GLint projectionMatrixLocation = glGetUniformLocation(self.program, "projectionMatrix");
    GLKMatrix4 projectionMatrix4 = GLKMatrix4MakePerspective(degreedToRadius(45.0), aspectRatio, 0.1, 100);
    glUniformMatrix4fv(projectionMatrixLocation, 1, GL_FALSE, projectionMatrix4.m);
}

- (void)moveCamera {
    
    self.currentAngle += degreedToRadius(1);
    if (self.currentAngle > (2.0 * M_PI)) {
        self.currentAngle = self.currentAngle - (2.0 * M_PI);
    }
    
    GLfloat radius = 6;
    GLfloat x = sinf(self.currentAngle) * radius;
    GLfloat z = cosf(self.currentAngle) * radius;
    
    GLint viewMatrixLocation = glGetUniformLocation(self.program, "viewMatrix");
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(x, 0, z,
                                                 0, 0, 0,
                                                 0, 1, 0);
    glUniformMatrix4fv(viewMatrixLocation, 1, GL_FALSE, viewMatrix.m);
}

- (void)setupLightingWithGreen:(CGFloat)greenValue {
    // The camera position is also the light source
    GLint cubeColorLocation = glGetUniformLocation(self.program, "color");
    GLKVector3 cubeColorVector3 = GLKVector3Make(1, 1, 1);
    glUniform3fv(cubeColorLocation, 1, cubeColorVector3.v);
    
    // 163, 58, 114
    GLint lightColorLocation = glGetUniformLocation(self.program, "lightColor");
    GLKVector3 lightColorVector3 = GLKVector3Make(163/255.0, greenValue/255.0, 114/255.0);
    glUniform3fv(lightColorLocation, 1, lightColorVector3.v);
}

- (void)drawWithVAO {

	// Setup the vao if needed
	//
	[self setupVAOs];
    
	// Draw the elements
	//
	glBindVertexArray (self.vao);
	glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_SHORT, 0);
	glBindVertexArray(0);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    self.currentTimeStamp = (self.currentTimeStamp + 1) % 60;
    
    glViewport (0, 0,
                (int)self.glkView.drawableWidth, (int)self.glkView.drawableHeight);
    
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glUseProgram(self.program);
	
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

- (UISlider *)colorSlider {
    if (! _colorSlider) {
        _colorSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _colorSlider.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 50);
        
        [_colorSlider addTarget:self action:@selector(colorSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _colorSlider;
}

@end
