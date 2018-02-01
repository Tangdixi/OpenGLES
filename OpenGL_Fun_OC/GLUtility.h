//
//  GLUtility.h
//  OpenGL_Fun_OC
//
//  Created by 汤迪希 on 24/01/2018.
//  Copyright © 2018 DC. All rights reserved.
//

@import Foundation;
@import OpenGLES;
@import CoreGraphics;
@import UIKit;

typedef NS_ENUM(GLuint, GLUtilityShaderType) {
    GLUtilityShaderTypeNone = 0,
    GLUtilityShaderTypeVertex = GL_VERTEX_SHADER,
    GLUtilityShaderTypeFragment = GL_FRAGMENT_SHADER
};

@interface GLUtility : NSObject

/**
 @brief Load a shader from a .glsl file in the bundle
 @param name The name of the shader
 @param type The shader type, aka, vertex or fragment
 @return The shader's ID
 @seealso GLUtilityShaderType
 */
+ (GLuint)lodaShaderWithName:(NSString *)name type:(GLUtilityShaderType)type;

/**
 @brief Create a program with a vertex and fragment shader
 @param vertexShader The vertex shader id
 @param fragmentShader The fragment shader id
 @return The program's ID
 */
+ (GLuint)programWithVertexShader:(GLuint)vertexShader fragmentShader:(GLuint)fragmentShader;

/**
 @brief Load an image and convert it into a GLbyte's raw data
 @param imageName The image name, only for .png format
 */
+ (GLubyte *)textureDatasWithImageName:(NSString *)imageName;

CGFloat degreedToRadius(CGFloat degreed);

@end
