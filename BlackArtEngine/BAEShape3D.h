//
//  BAEShape3D.h
//  BlackArtEngine
//
//  Created by Uli Kusterer on 21.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#ifndef BAESHAPE3D_H
#define BAESHAPE3D_H

#include "BAEMatrix.h"

typedef struct
{
	float lx, ly, lz, lt;	// Shape coordinates.
	float tx, ty, tz, tt;	// Transformed coordinates.
	float wx, wy, wz, wt;	// World coordinates.
	float sx, sy, st;		// Window coordinates.
} BAEVertex3D;


typedef struct
{
	float begin, end;
} BAEVertexConnect;

typedef struct
{
	unsigned char color;
	int numOfVertices;
	int numOfLines;
	float originX, originY, originZ;
	BAEVertex3D *vertex;
	BAEVertexConnect *shapeLines;
} BAEShape3D;

void	BAETransformShape( BAEShape3D* theShape, BAEMatrix transformMatrix );
void	BAEShapeToWorldCoordinates( BAEShape3D* theShape );
void	BAEProjectShape( BAEShape3D* theShape, float windowWidth, float windowHeight );

#endif /* BAESHAPE3D_H */
