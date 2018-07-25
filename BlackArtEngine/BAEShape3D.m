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


@implementation BAEVertex3D

+(instancetype)	vertexWithX: (float)lx y: (float)ly z: (float)lz
{
	return [[self alloc] initWithX: lx y: ly z: lz];
}


-(instancetype)	initWithX: (float)lx y: (float)ly z: (float)lz
{
	if (self = [super init])
	{
		_lx = lx;
		_ly = ly;
		_lz = lz;
		_lt = 1;
		_tx = 0;
		_ty = 0;
		_tz = 0;
		_tt = 1;
		_wx = 0;
		_wy = 0;
		_wz = 0;
		_wt = 1;
		_sx = 0;
		_sy = 0;
		_st = 1;
	}
	
	return self;
}

@end


@implementation BAEObject3D

-(void)	transform: (BAEMatrix)transformMatrix
{
	for (BAEVertex3D *currVertex in self.vertices)
	{
		float temp0 = currVertex.lx * transformMatrix[0][0] + currVertex.ly * transformMatrix[1][0] + currVertex.lz * transformMatrix[2][0] + transformMatrix[3][0];
		float temp1 = currVertex.lx * transformMatrix[0][1] + currVertex.ly * transformMatrix[1][1] + currVertex.lz * transformMatrix[2][1] + transformMatrix[3][1];
		float temp2 = currVertex.lx * transformMatrix[0][2] + currVertex.ly * transformMatrix[1][2] + currVertex.lz * transformMatrix[2][2] + transformMatrix[3][2];
		float temp3 = currVertex.lx * transformMatrix[0][3] + currVertex.ly * transformMatrix[1][3] + currVertex.lz * transformMatrix[2][3] + transformMatrix[3][3];
		
		if (temp2 == 0.0 || isnan(temp2) || isinf(temp2))
		{
			BAEPrintMatrix( transformMatrix );
		}

		currVertex.tx = temp0;
		currVertex.ty = temp1;
		currVertex.tz = temp2;
		currVertex.tt = temp3;
	}
}


-(void)	objectToWorldCoordinates
{
	float	shapeOriginX = self.originX;
	float	shapeOriginY = self.originY;
	float	shapeOriginZ = self.originZ;
	
	for (BAEVertex3D *currVertex in self.vertices)
	{
		currVertex.wx = currVertex.tx + shapeOriginX;
		currVertex.wy = currVertex.ty + shapeOriginY;
		currVertex.wz = currVertex.tz + shapeOriginZ;
	}
}


-(void) projectWithWindowWidth:(CGFloat)windowWidth height:(CGFloat)windowHeight
{
	CGFloat distanceConstant = kDistanceConstant;
	
	for (BAEVertex3D *currVertex in self.vertices)
	{
		currVertex.sx = (currVertex.wx * distanceConstant) / currVertex.wz;
		currVertex.sy = (currVertex.wy * distanceConstant) / currVertex.wz;
		
		currVertex.sx += (windowWidth / 2);
		currVertex.sy += (windowHeight / 2);
	}
}


-(void)	collectVerticesFromPolygons
{
	NSMutableArray<BAEVertex3D *> *vertices = [NSMutableArray new];
	
	for (BAEPolygon3D *currPolygon in self.polygons)
	{
		for (BAEVertex3D *currVertex in currPolygon.vertices)
		{
			[vertices addObject: currVertex];
		}
	}
	
	_vertices = vertices;
}

@end


@implementation BAEPolygon3D

+(instancetype)	polygonWithColor: (NSColor *)color coordinates: (CGFloat)inFirst, ...
{
	BAEPolygon3D *poly = [self new];

	poly->_color = color;
	
	NSMutableArray<BAEVertex3D *> *vertices = [NSMutableArray new];
	NSInteger idx = 0;
	CGFloat args[3] = { 0, 0, 0 };
	
	args[idx++] = inFirst;
	
	va_list ap;
	
	va_start(ap, inFirst);
	
	while (true)
	{
		NSInteger subIdx = (idx++) % 3;
		args[subIdx] = va_arg(ap, CGFloat);
		if (args[subIdx] == DBL_MIN)
			break;
		
		if (subIdx == 2)
		{
			BAEVertex3D *vertex = [BAEVertex3D vertexWithX: args[0] y: args[1] z: args[2]];
			[vertices addObject: vertex];
		}
	}
	
	va_end(ap);
	
	poly->_vertices = vertices;
	
	return poly;
}


-(BOOL)	isBackfacing
{
	BAEVertex3D	*v0,*v1,*v2;
	long		x1, x2, x3, y1, y2, y3, z1, z2, z3;
	long		c;
	
	/* Get pointers to the first three vertices of the polygon */
	v0 = self.vertices[0];
	v1 = self.vertices[1];
	v2 = self.vertices[2];
	
	/* Pull out the individual terms of the vertices and convert
	 * them to longwords.
	 */
	x1 = v0.wx; x2 = v1.wx; x3 = v2.wx;
	y1 = v0.wy; y2 = v1.wy; y3 = v2.wy;
	z1 = v0.wz; z2 = v1.wz; z3 = v2.wz;
	
	/* Calculate the dot product of the polygon */
	c=(	x3 * ((z1 * y2) - (y1 * z2)) +
	   y3 * ((x1 * z2) - (z1 * x2)) +
	   z3 * ((y1 * x2) - (x1 * y2)));
	
	/* If c is positive, the polygon is facing away from the screen */
	return (c > 0);
}

@end
