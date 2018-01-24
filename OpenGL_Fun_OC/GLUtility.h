//
//  GLUtility.h
//  OpenGL_Fun_OC
//
//  Created by 汤迪希 on 24/01/2018.
//  Copyright © 2018 DC. All rights reserved.
//

@import Foundation;
@import OpenGLES;

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
 @seealso GLUtilityShaderType
 */
+ (GLuint)lodaShaderWithName:(NSString *)name type:(GLUtilityShaderType)type;

+ (GLuint)programWithVertexShader:(GLuint)vertexShader fragmentShader:(GLuint)fragmentShader;

+ (GLuint)programWithName:(NSString *)name;

@end
