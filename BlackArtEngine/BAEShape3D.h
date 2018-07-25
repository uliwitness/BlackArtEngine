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
#include <Cocoa/Cocoa.h>


@interface BAEVertex3D : NSObject

@property float lx;
@property float ly;
@property float lz;
@property float lt;	// Shape coordinates.
@property float tx;
@property float ty;
@property float tz;
@property float tt;	// Transformed coordinates.
@property float wx;
@property float wy;
@property float wz;
@property float wt;	// World coordinates.
@property float sx;
@property float sy;
@property float st;	// Window coordinates.

+(instancetype)	vertexWithX: (float)lx y: (float)ly z: (float)lz;

-(instancetype) initWithX: (float)lx y: (float)ly z: (float)lz;

@end


@interface BAEPolygon3D : NSObject

@property NSColor *color;
@property NSArray<BAEVertex3D *> *vertices;

+(instancetype)	polygonWithColor: (NSColor *)color coordinates: (CGFloat)inFirst, ...; /* terminated DBL_MIN. */

-(BOOL) isBackfacing;

@end


@interface BAEObject3D : NSObject

@property NSArray<BAEVertex3D *> *vertices;
@property NSArray<BAEPolygon3D *> *polygons;
@property float originX;
@property float originY;
@property float originZ;

-(void)	transform: (BAEMatrix)transformMatrix;
-(void)	objectToWorldCoordinates;
-(void) projectWithWindowWidth:(CGFloat)windowWidth height:(CGFloat)windowHeight;

-(void)	collectVerticesFromPolygons;

@end

#endif /* BAESHAPE3D_H */
