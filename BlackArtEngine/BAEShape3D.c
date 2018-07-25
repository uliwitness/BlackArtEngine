//
//  BAEShape3D.c
//  BlackArtEngine
//
//  Created by Uli Kusterer on 21.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#include "BAEShape3D.h"
#include <stdio.h>
#include <math.h>


const float kDistanceConstant = 200; // Book suggests 200...400


void	BAETransformShape( BAEShape3D* theShape, BAEMatrix transformMatrix )
{
	for (int i = 0; i < theShape->numOfVertices; ++i)
	{
		BAEVertex3D *currVertex = &theShape->vertex[i];
		
		float temp0 = currVertex->lx * transformMatrix[0][0]
		+ currVertex->ly * transformMatrix[1][0]
		+ currVertex->lz * transformMatrix[2][0]
		+ transformMatrix[3][0];
		float temp1 = currVertex->lx * transformMatrix[0][1]
		+ currVertex->ly * transformMatrix[1][1]
		+ currVertex->lz * transformMatrix[2][1]
		+ transformMatrix[3][1];
		float temp2 = currVertex->lx * transformMatrix[0][2]
		+ currVertex->ly * transformMatrix[1][2]
		+ currVertex->lz * transformMatrix[2][2]
		+ transformMatrix[3][2];
		float temp3 = currVertex->lx * transformMatrix[0][3]
		+ currVertex->ly * transformMatrix[1][3]
		+ currVertex->lz * transformMatrix[2][3]
		+ transformMatrix[3][3];
		
		if (temp2 == 0.0 || isnan(temp2) || isinf(temp2))
		{
			BAEPrintMatrix( transformMatrix );
		}

		theShape->vertex[i].tx = temp0;
		theShape->vertex[i].ty = temp1;
		theShape->vertex[i].tz = temp2;
		theShape->vertex[i].tt = temp3;
	}
}


void	BAEShapeToWorldCoordinates( BAEShape3D* theShape )
{
	float	shapeOriginX = theShape->originX;
	float	shapeOriginY = theShape->originY;
	float	shapeOriginZ = theShape->originZ;
	
	for (int i = 0; i < theShape->numOfVertices; ++i)
	{
		BAEVertex3D *vertexRef = &theShape->vertex[i];
		
		vertexRef->wx = vertexRef->tx + shapeOriginX;
		vertexRef->wy = vertexRef->ty + shapeOriginY;
		vertexRef->wz = vertexRef->tz + shapeOriginZ;
	}
}


void	BAEProjectShape( BAEShape3D* theShape, float windowWidth, float windowHeight )
{
	for (int i = 0; i < theShape->numOfVertices; ++i)
	{
		BAEVertex3D *vertexRef = &theShape->vertex[i];
		
		vertexRef->sx = (vertexRef->wx * windowWidth) / vertexRef->wz;
		vertexRef->sy = (vertexRef->wy * windowWidth) / vertexRef->wz;
		
		vertexRef->sx += (windowWidth / 2);
		vertexRef->sy += (windowHeight / 2);
	}
}


