//
//  GLUtility.m
//  OpenGL_Fun_OC
//
//  Created by 汤迪希 on 24/01/2018.
//  Copyright © 2018 DC. All rights reserved.
//

#import "GLUtility.h"

@implementation GLUtility

+ (GLuint)lodaShaderWithName:(NSString *)name
                        type:(GLUtilityShaderType)type {
    
    // 1. Create an empty shader
    //
    GLuint shader = glCreateShader(type);
    
    if (! shader) {
#if DEBUG
        NSLog(@"GLUtility: Create shader failed: %s, %d", __FUNCTION__, __LINE__);
#endif
        return 0;
    }
    
    // 2. Load shader source
    //
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"glsl"];
    
    NSError *sourceError = nil;
    const GLchar *source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&sourceError].UTF8String;
    
    if (sourceError) {
#if DEBUG
        NSLog(@"GLUtility: Load shader file error: %s, %d", __FUNCTION__, __LINE__);
#endif
        return 0;
    }
    glShaderSource(shader, 1, &source, NULL);
    
    // 3. Compile shader
    //
    glCompileShader(shader);
    
    GLint compiled = GL_FALSE;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (! compiled) {
#if DEBUG
        
        NSLog(@"GLUtility: Compile shader failed: %s, %d", __FUNCTION__, __LINE__);
        
        GLint infoLength = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLength);
        
        if (infoLength) {
            
            char *infoLog = malloc(sizeof(char) * infoLength);
            glGetShaderInfoLog(shader, infoLength, NULL, infoLog);
            
            NSLog(@"%s", infoLog);
            
            free(infoLog);
        }
#endif
        glDeleteShader(shader);
        
        return 0;
    }
    
    return shader;
}

+ (GLuint)programWithVertexShader:(GLuint)vertexShader
                   fragmentShader:(GLuint)fragmentShader {
    
    // 1. Create an empty program
    //
    GLuint program = glCreateProgram();
    
    if (! program) {
        NSLog(@"GLUtility: Create program failed: %s, %d", __FUNCTION__, __LINE__);
        return 0;
    }
    
    // 2. Validate the shaders
    //
    if (! vertexShader || ! fragmentShader) {
        NSLog(@"GLUtility: Invalid shader: %s, %d", __FUNCTION__, __LINE__);
        return 0;
    }
    
    // 3. Attach vertex and fragment shader
    //
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // 4. Link the program
    //
    glLinkProgram(program);
    
    GLint linked = 0;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    
    if (! linked) {

        NSLog(@"GLUtility: Link program failed: %s, %d", __FUNCTION__, __LINE__);
#if DEBUG
        GLint infoLength = 0;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLength);
        
        if (infoLength) {
            
            char *infoLog = malloc(sizeof(char) * infoLength);
            glGetProgramInfoLog(program, infoLength, NULL, infoLog);
            
            NSLog(@"%s", infoLog);
            
            free(infoLog);
        }
#endif
        glDeleteProgram(program);
        
        return 0;
    }
    
    // 5. No longer need the shader resource after linked
    //
    glDeleteShader(vertexShader);
    glDeleteProgram(fragmentShader);
    
    return program;
}

+ (GLubyte *)textureDatasWithImageName:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (!image) {
        NSLog(@"GLUtility: Load texture failed: invalid image name %s, %d", __FUNCTION__, __LINE__);
        
        return NULL;
    }
    
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    GLubyte *textureData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(textureData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
    
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), imageRef);
    
    CGContextRelease(spriteContext);
    
    return textureData;
}

const void* bufferOffset(NSUInteger offset) {
	return (const void*)(offset);
}

@end
