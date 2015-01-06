#define DEGREES_TO_RADIANS(x) ((x) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(x) ((x) / M_PI * 180.0)

#import "NEONMatrix.h"

typedef Vertex3D Vector3D;

static inline GLfloat Vertex3DDistanceBetweenVertices 
    (Vertex3D vertex1, Vertex3D vertex2)
{
    GLfloat deltaX, deltaY, deltaZ;
    
    deltaX = vertex2.x - vertex1.x;
    deltaY = vertex2.y - vertex1.y;
    deltaZ = vertex2.z - vertex1.z;
    
    return sqrtf((deltaX * deltaX) + 
                 (deltaY * deltaY) + 
                 (deltaZ * deltaZ));
}
static inline GLfloat Vector3DMagnitude(Vector3D vector)
{
    return sqrtf((vector.x * vector.x) + 
                 (vector.y * vector.y) + 
                 (vector.z * vector.z)); 
}
static inline GLfloat Vector3DDotProduct
(Vector3D vector1, Vector3D vector2)
{		
    return (vector1.x*vector2.x) + 
    (vector1.y*vector2.y) + 
    (vector1.z*vector2.z);
}
static inline Vector3D Vector3DCrossProduct
    (Vector3D vector1, Vector3D vector2)
{
    Vector3D ret;
    ret.x = (vector1.y * vector2.z) - (vector1.z * vector2.y);
    ret.y = (vector1.z * vector2.x) - (vector1.x * vector2.z);
    ret.z = (vector1.x * vector2.y) - (vector1.y * vector2.x);
    return ret;
}
static inline void Vector3DNormalize(Vector3D *vector)
{
    GLfloat vecMag = Vector3DMagnitude(*vector);
    if ( vecMag == 0.0 )
    {
        vector->x = 1.0;
        vector->y = 0.0;
        vector->z = 0.0;
        return;
    }
    vector->x /= vecMag;
    vector->y /= vecMag;
    vector->z /= vecMag;
}
static inline Vector3D Vector3DMakeWithStartAndEndPoints
(Vertex3D start, Vertex3D end)
{
    Vector3D ret;
    ret.x = end.x - start.x;
    ret.y = end.y - start.y;
    ret.z = end.z - start.z;
    return ret;
}
static inline Vector3D Vector3DMakeNormalizedVectorWithStartAndEndPoints
(Vertex3D start, Vertex3D end)
{
    Vector3D ret = Vector3DMakeWithStartAndEndPoints(start, end);
    Vector3DNormalize(&ret);
    return ret;
} 
static inline void Vector3DFlip (Vector3D *vector)
{
    vector->x = -vector->x;
    vector->y = -vector->y;
    vector->z = -vector->z;
}
typedef struct {
    GLubyte	red;
    GLubyte green;
    GLubyte blue;
    GLubyte alpha;
} Color4B;


static inline void Vector3DCopy(Vector3D *source,Vector3D *destination)
{
    destination->x = source->x;
    destination->y = source->y;
    destination->z = source->z;
}

static inline void Color4fCopy(Color4B *source,Color4B *destination)
{
    destination->blue = source->blue;
    destination->green = source->green;
    destination->red = source->red;
    destination->alpha = source->alpha;
}

static inline void Vector3DCopyS(Vector3D source,Vector3D *destination)
{
    destination->x = source.x;
    destination->y = source.y;
    destination->z = source.z;
}


static inline void Color4fCopyS(Color4B source,Color4B *destination)
{
    destination->blue = source.blue;
    destination->green = source.green;
    destination->red = source.red;
    destination->alpha = source.alpha;
}

typedef float Matrix3D[16];
static inline void Matrix3DSetIdentity(Matrix3D matrix)
{
    matrix[0] = matrix[5] = matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
}
static inline void Matrix3DSetTranslation
    (Matrix3D matrix, GLfloat xTranslate, 
     GLfloat yTranslate, GLfloat zTranslate)
{
    matrix[0] = matrix[5] = matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] =  matrix[3] =  matrix[4] = 0.0;
    matrix[6] = matrix[7] =  matrix[8] =  matrix[9] = 0.0;    
    matrix[11] = 0.0;
    matrix[12] = xTranslate;
    matrix[13] = yTranslate;
    matrix[14] = zTranslate;   
}
static inline void Matrix3DSetScaling
    (Matrix3D matrix, GLfloat xScale, 
     GLfloat yScale, GLfloat zScale)
{
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[0] = xScale;
    matrix[5] = yScale;
    matrix[10] = zScale;
    matrix[15] = 1.0;
}
static inline void Matrix3DSetUniformScaling
    (Matrix3D matrix, GLfloat scale)
{
    Matrix3DSetScaling(matrix, scale, scale, scale);
}
static inline void Matrix3DSetZRotationUsingRadians
    (Matrix3D matrix, GLfloat radians)
{
    matrix[0] = cosf(radians);
    matrix[1] = sinf(radians);
    matrix[4] = -matrix[1];
    matrix[5] = matrix[0];
    matrix[2] = matrix[3] = matrix[6] = matrix[7] = matrix[8] = 0.0;
    matrix[9] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[10] = matrix[15] = 1.0;
}
static inline void Matrix3DSetZRotationUsingDegrees
    (Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetZRotationUsingRadians(matrix, DEGREES_TO_RADIANS(degrees));
}
static inline void Matrix3DSetXRotationUsingRadians
(Matrix3D matrix, GLfloat radians)
{
    matrix[0] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[7] = matrix[8] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    
    matrix[5] = cosf(radians);
    matrix[6] = -sinf(radians);
    matrix[9] = -matrix[6];
    matrix[10] = matrix[5];
}
static inline void Matrix3DSetXRotationUsingDegrees
(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetXRotationUsingRadians(matrix,DEGREES_TO_RADIANS(degrees));
}
static inline void Matrix3DSetYRotationUsingRadians
(Matrix3D matrix, GLfloat radians)
{
    matrix[0] = cosf(radians);
    matrix[2] = sinf(radians);
    matrix[8] = -matrix[2];
    matrix[10] = matrix[0];
    matrix[1] = matrix[3] = matrix[4] = matrix[6] = matrix[7] = 0.0;
    matrix[9] = matrix[11] = matrix[13] = matrix[12] = matrix[14] = 0.0;
    matrix[5] = matrix[15] = 1.0;
}
static inline void Matrix3DSetYRotationUsingDegrees
(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetYRotationUsingRadians(matrix, DEGREES_TO_RADIANS(degrees));
}
static inline void Matrix3DSetRotationByRadians
(Matrix3D matrix, GLfloat radians, Vector3D vector)
{
    GLfloat mag = sqrtf((vector.x * vector.x) + 
                        (vector.y * vector.y) + 
                        (vector.z * vector.z));
    if (mag == 0.0)
    {
        vector.x = 1.0;
        vector.y = 0.0;
        vector.z = 0.0;
    }
    else if (mag != 1.0)
    {
        vector.x /= mag;
        vector.y /= mag;
        vector.z /= mag;
    }
    
    GLfloat c = cosf(radians);
    GLfloat s = sinf(radians);
    matrix[3] = matrix[7] = matrix[11] = 0.0;
    matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[15] = 1.0;
    
    matrix[0]  = (vector.x * vector.x) * (1-c) + c;
    matrix[1]  = (vector.y * vector.x) * (1-c) + (vector.z * s);
    matrix[2]  = (vector.x * vector.z) * (1-c) - (vector.y * s);
    matrix[4]  = (vector.x * vector.y) * (1-c) - (vector.z * s);
    matrix[5]  = (vector.y * vector.y) * (1-c) + c;
    matrix[6]  = (vector.y * vector.z) * (1 - c) + (vector.x*s);
    matrix[8]  = (vector.x * vector.z) * (1 - c) + (vector.y*s);
    matrix[9]  = (vector.y * vector.z) * (1 - c) - (vector.x*s);
    matrix[10] = (vector.z * vector.z) * (1 - c) + c;
}
static inline void Matrix3DSetRotationByDegrees
    (Matrix3D matrix, GLfloat degrees, Vector3D vec)
{
    Matrix3DSetRotationByRadians(matrix, DEGREES_TO_RADIANS(degrees), vec);
}


static inline void Matrix3DSetOrthoProjection(Matrix3D matrix, GLfloat left, 
    GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far)
{
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = matrix[6] = 0.f;
    matrix[7] = matrix[8] = matrix[9] = matrix[11] = 0.f;
    matrix[0] = 2.f / (right - left);
    matrix[5] = 2.f / (top - bottom);
    matrix[10] = -2.f / (far - near);
    matrix[12] = (right + left) / (right - left);
    matrix[13] = (top + bottom) / (top - bottom);
    matrix[14] = (far + near) / (far - near);
    matrix[15] = 1.f;
}
static inline void Matrix3DSetFrustumProjection(Matrix3D matrix, 
                                                GLfloat left, GLfloat right, 
                                                GLfloat bottom, GLfloat top, 
                                                GLfloat zNear, GLfloat zFar)
{
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.f;
    matrix[6] = matrix[7] = matrix[12] = matrix[13] = matrix[15] = 0.f;
    
    
    matrix[0] = 2 * zNear / (right - left);
    matrix[5] = 2 * zNear / (top - bottom);
    matrix[8] = (right + left) / (right - left);
    matrix[9] = (top + bottom) / (top - bottom);
    matrix[10] = -(zFar + zNear) / (zFar - zNear);
    matrix[11] = -1.f;
    matrix[14] = -(2 * zFar * zNear) / (zFar - zNear);
}

static inline void Matrix3DCopyS(Matrix3D source,Matrix3D destination)
{
    for (int i =0;i<16;i++)
    {
        destination[i] = source[i];
    }
}

static inline void Matrix3DCopy(Matrix3D *source,Matrix3D *destination)
{
    for (int i =0;i<16;i++)
    {
        *(destination)[i]= *(source)[i];
    }
}

static inline void Matrix3DSetPerspectiveProjectionWithFieldOfView
    (Matrix3D matrix, GLfloat fieldOfVision, GLfloat near,
     GLfloat far, GLfloat aspectRatio)
{
    GLfloat size = near * tanf(DEGREES_TO_RADIANS(fieldOfVision) / 2.0); 
    Matrix3DSetFrustumProjection( matrix,
                                 -size, 
                                 size,
                                 -size / aspectRatio,
                                 size / aspectRatio,
                                 near,
                                 far);


}

static inline  void CGRectToVertex3D(CGRect _rect,Vertex3D* vertices)
{
    vertices[0] = (Vertex3D){.x = _rect.origin.x, .y = _rect.origin.y, .z = 0};
    vertices[1] = (Vertex3D){.x = _rect.origin.x + _rect.size.width , .y = _rect.origin.y, .z = 0};
    vertices[2] = (Vertex3D){.x = _rect.origin.x + _rect.size.width , .y = _rect.origin.y + _rect.size.height, .z = 0};
    
    vertices[3] = (Vertex3D){.x = _rect.origin.x, .y = _rect.origin.y, .z = 0};
    vertices[4] = (Vertex3D){.x = _rect.origin.x, .y = _rect.origin.y + _rect.size.height, .z = 0};
    vertices[5] = (Vertex3D){.x = _rect.origin.x + _rect.size.width, .y = _rect.origin.y + _rect.size.height, .z = 0};
}




typedef struct
{
    GLfloat	s;
    GLfloat t;
} TextureCoord;

static inline void TextureCoordCopy(TextureCoord *source,TextureCoord *destination)
{
    destination->s = source->s;
    destination->t = source->t;

}


static inline void TextureCoordCopyS(TextureCoord source,TextureCoord *destination)
{
    destination->s = source.s;
    destination->t = source.t;
}

static inline  void CGRectToTextureCoord(CGRect _rect,TextureCoord *texCoord)
{
    texCoord[0] = (TextureCoord){.s = _rect.origin.x, .t = _rect.origin.y +_rect.size.height};
    texCoord[1] = (TextureCoord){.s = _rect.origin.x + _rect.size.width , .t = _rect.origin.y+_rect.size.height};
    texCoord[2] = (TextureCoord){.s = _rect.origin.x + _rect.size.width , .t = _rect.origin.y};
    
    texCoord[3] = (TextureCoord){.s = _rect.origin.x, .t = _rect.origin.y +_rect.size.height};
    texCoord[4] = (TextureCoord){.s = _rect.origin.x, .t = _rect.origin.y};
    texCoord[5] = (TextureCoord){.s = _rect.origin.x + _rect.size.width, .t = _rect.origin.y};
}


static inline Color4B Color4BFromHex(int hex)
{
    return  (Color4B){.red = (0xff000000 & hex)>>24,.green = (0x00ff0000 & hex)>>16 ,.blue = (0x0000ff00 & hex)>>8,
        .alpha = 0x000000ff & hex
    };
    
}
typedef struct
{
    Vertex3D vertex;
    Color4B color;
    
} VertexColorData;

typedef struct
{
    TextureCoord texCoord;
    Vertex3D vertex;
    Color4B color;
} TextureVertexColorData;

typedef struct
{
    Matrix3D mvpMatrix;
    Vertex3D vertex;
    Color4B color;
    
} InstancedVertexColorData;

typedef struct
{
    Matrix3D mvpMatrix;
    TextureCoord texCoord;
    Vertex3D vertex;
    Color4B color;
} InstancedTextureVertexColorData;

typedef struct
{
    Vertex3D vertex;
    Color4B color;
    float size;
} PointVertexColorSizeData;
