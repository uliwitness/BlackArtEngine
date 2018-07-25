//
//  BAECanvasView.m
//  BlackArtEngine
//
//  Created by Uli Kusterer on 21.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import "BAECanvasView.h"
#import "BAEShape3D.h"
#import "BAEMatrix.h"


static BAEVertex3D	sCubeVertexArray[] =
{
	{
		-80,	80,		-80,	1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1,			/* Vertex 0 */
	},
	{
		80,		80,		-80,	1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1,			/* Vertex 1 */
	},
	{
		80,		-80,	-80,	1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1,			/* Vertex 2 */
	},
	{
		-80,	-80,	-80,	1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1,			/* Vertex 3 */
	},
	{
		-80,	80,		80,		1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1,			/* Vertex 4 */
	},
	{
		80,		80,		80,		1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1,			/* Vertex 5 */
	},
	{
		80,		-80,	80,		1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1,			/* Vertex 6 */
	},
	{
		-80,	-80,	80,		1,
		0,		0,		0,		1,
		0,		0,		0,		1,
		0,		0,		1			/* Vertex 7 */
	}
};


static BAEVertexConnect sCubeVertexConnections[] =
{
	{ 0, 1 },
	{ 1, 2 },
	{ 2, 3 },
	{ 3, 0 },
	{ 4, 5 },
	{ 5, 6 },
	{ 6, 7 },
	{ 7, 4 },
	{ 0, 4 },
	{ 1, 5 },
	{ 2, 6 },
	{ 3, 7 }
};


static BAEShape3D sCubeShape =
{
	255,
	8,
	12,
	0, 0, 320,
	sCubeVertexArray,
	sCubeVertexConnections
};


@interface BAECanvasView ()
{
	BAEMatrix	_transformationMatrix;
}

@end


@implementation BAECanvasView

-(instancetype)	initWithCoder: (NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder])
	{
		self.wantsLayer = YES;
		self.layer.backgroundColor = NSColor.blackColor.CGColor;
		BAEInitMatrix( _transformationMatrix );
	}
	return self;
}


-(instancetype)	initWithFrame: (NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect])
	{
		self.wantsLayer = YES;
		self.layer.backgroundColor = NSColor.blackColor.CGColor;
		BAEInitMatrix( _transformationMatrix );
	}
	return self;
}


-(void) setTransformationMatrix: (BAEMatrix)transformationMatrix
{
	BAECopyMatrix(transformationMatrix, _transformationMatrix);
	
	[self setNeedsDisplay: YES];
}


-(void) drawRect: (NSRect)dirtyRect
{
	[NSColor.whiteColor	set];
	NSRectFill(self.bounds);
	
	BAETransformShape( &sCubeShape, _transformationMatrix );
	BAEShapeToWorldCoordinates( &sCubeShape );
	BAEProjectShape( &sCubeShape, self.bounds.size.width, self.bounds.size.height );

	[NSColor.blackColor	set];
	for (int i = 0; i < sCubeShape.numOfLines; ++i)
	{
		int	beginVertex = sCubeShape.shapeLines[i].begin,
				endVertex = sCubeShape.shapeLines[i].end;
		
		[NSBezierPath strokeLineFromPoint: NSMakePoint(sCubeShape.vertex[beginVertex].sx, sCubeShape.vertex[beginVertex].sy)
								  toPoint: NSMakePoint(sCubeShape.vertex[endVertex].sx, sCubeShape.vertex[endVertex].sy)];
	}
}

-(BOOL) isFlipped
{
	return YES;
}

@end
