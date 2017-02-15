//
//  ViewController.swift
//  open_gl_tut
//
//  Created by scm197 on 2/13/17.
//  Copyright © 2017 scm197. All rights reserved.
//

import GLKit

class ViewController: GLKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // set up the view
        let glkView: GLKView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        glkView.drawableColorFormat = .RGBA8888
      
        // set up the opengl state machine
        EAGLContext.setCurrent(glkView.context)
        
        setup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // updates before drawing each frame
    func update()
    {

    }

    
    // setup the view for each frame
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
       print("frame")

       glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
    }
    
  
    // Customize the view using open gl
    // set up the shader grahpics pipeline
    func setup()
    {
        glClearColor(1, 0.5, 0.1, 0.8)
       
       
       // create the char** str file which will be use by openGl to compile
        
        // the vertex shader str is compiled and the program is applied to each vertex
        let vertexShaderSourceStr : NSString = "void main() \n {  \n     gl_Position = vec4(1.0 , 1.0 , 0 , 1.0); \n  }  \n"
        
        // the fragment shader str is compiled and the program is applied to each fragment
        let fragmentShaderSourceStr : NSString = "void main() \n {  \n     gl_FragColor = vec4(1.0 , 0.8 , 0 , 1.0); \n  }  \n"
     
        
        
       // Create the vertex shader
        
        let vertexShader : GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        var vertexShaderSourceStrUTF8 = vertexShaderSourceStr.utf8String
       
        // associate the program with the shader identifier
        glShaderSource(vertexShader, 1, &vertexShaderSourceStrUTF8 , nil)
      
        // compile the string into the vertex shader binary
        glCompileShader(vertexShader)
       
        // get compile status and error from the shader
        
        var vertexShaderCompileStatusMem : GLint = GL_FALSE       // create memory to store the result from the c api
        
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &vertexShaderCompileStatusMem)

        guard vertexShaderCompileStatusMem == GL_TRUE else
        {
            // compilation failed
            
            // get length of error log
            var vertexShaderCompileErrorLogLenMem : GLint = 0
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH) , &vertexShaderCompileErrorLogLenMem)
            
            // get the error log from opengl
            var vertexShaderCompileErrorLogStrMem = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(vertexShaderCompileErrorLogLenMem))
            
            glGetShaderInfoLog(vertexShader, vertexShaderCompileErrorLogLenMem , nil , vertexShaderCompileErrorLogStrMem)
            
            // convert the char** error to a string
            let vertexShaderCompileErrorLogStr = NSString(utf8String: vertexShaderCompileErrorLogStrMem)
            
            print("vertexSharder Compile Error : \(vertexShaderCompileErrorLogStr)")
            return
       
        }


        
        
        // Create the fragment shader
        let fragmentShader : GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
       
        var fragmentShaderSourceStrUTF8 = fragmentShaderSourceStr.utf8String
        
        // associate the program with the shader identifier
        glShaderSource(fragmentShader, 1, &fragmentShaderSourceStrUTF8 , nil)
        
        // compile the string into the fragment shader binary
        glCompileShader(fragmentShader)
        
        // get compile status and error from the shader
        var fragmentShaderCompileStatusMem : GLint = GL_FALSE    // create memory to store the result from the c api
        
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentShaderCompileStatusMem)
        
        guard fragmentShaderCompileStatusMem == GL_TRUE else
        {
            // compilation failed
            
            // get length of error log
            var fragmentShaderCompileErrorLogLenMem : GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH) , &fragmentShaderCompileErrorLogLenMem)
            
            // get the error log from opengl
            var fragmentShaderCompileErrorLogStrMem = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(fragmentShaderCompileErrorLogLenMem))
            
            glGetShaderInfoLog(fragmentShader, fragmentShaderCompileErrorLogLenMem , nil , fragmentShaderCompileErrorLogStrMem)
            
            // convert the char** error to a string
            let fragmentShaderCompileErrorLogStr = NSString(utf8String: fragmentShaderCompileErrorLogStrMem)
            
            print("fragmentSharder Compile Error : \(fragmentShaderCompileErrorLogStr)")
            return
        }
       
        // Have access to both the vertex and frag shaders. 
        // Create the opengl program : pipeline
        
        let program : GLuint = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glLinkProgram(program)
      
        // debugging for link errors
        var programLinkStatusMem : GLint = GL_FALSE
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &programLinkStatusMem)
       
        guard programLinkStatusMem == GL_TRUE else
        {
            // linking failed. Report to console
            // get length of log
            var programLinkErrorLogLen : GLint = 0 ;
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH) , &programLinkErrorLogLen)

            // get log
            var programLinkErrorLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(programLinkErrorLogLen))
            glGetProgramInfoLog(program, programLinkErrorLogLen, nil, programLinkErrorLog)
           
            let programLinkErrorStr =  NSString(utf8String:programLinkErrorLog )
            
            print("linking error : \(programLinkErrorStr)")
            
            return 
        }
        
        
        
        
        
    }
    
    
    
    
    
}

