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
@import CoreImage;


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
	
	for (BAEObject3D *currObject in self.objects)
	{
		[currObject transform: _transformationMatrix];
		[currObject objectToWorldCoordinates];
		[currObject projectWithWindowWidth:self.bounds.size.width height: self.bounds.size.height];
	}

	CIContext *ciContext = [CIContext contextWithCGContext: NSGraphicsContext.currentContext.CGContext options:nil];

	for (BAEObject3D *currObject in self.objects)
	{
		for (BAEPolygon3D *currPolygon in currObject.polygons)
		{
			if (!currPolygon.isBackfacing)
			{
				BAEVertex3D *prevVertex = currPolygon.vertices.lastObject;
				
				if (currPolygon.texture)
				{
					CGPoint topLeftPoint = NSMakePoint(currPolygon.vertices[0].sx, currPolygon.vertices[0].sy);
					CGPoint topRightPoint = NSMakePoint(currPolygon.vertices[3].sx, currPolygon.vertices[3].sy);
					CGPoint bottomRightPoint = NSMakePoint(currPolygon.vertices[2].sx, currPolygon.vertices[2].sy);
					CGPoint bottomLeftPoint = NSMakePoint(currPolygon.vertices[1].sx, currPolygon.vertices[1].sy);
					
					CIFilter *perspectiveTransformation = [CIFilter filterWithName:@"CIPerspectiveTransform"];
					[perspectiveTransformation setValue:[CIVector vectorWithCGPoint:topLeftPoint] forKey:@"inputTopLeft"];
					[perspectiveTransformation setValue:[CIVector vectorWithCGPoint:topRightPoint] forKey:@"inputTopRight"];
					[perspectiveTransformation setValue:[CIVector vectorWithCGPoint:bottomRightPoint] forKey:@"inputBottomRight"];
					[perspectiveTransformation setValue:[CIVector vectorWithCGPoint:bottomLeftPoint] forKey:@"inputBottomLeft"];
					[perspectiveTransformation setValue:currPolygon.texture forKey:kCIInputImageKey];
					
					CIImage *resultImage = [perspectiveTransformation outputImage];
					[ciContext drawImage:resultImage
								  inRect:resultImage.extent
								fromRect:resultImage.extent];
				}
				else
				{
					[currPolygon.color setStroke];
					[[currPolygon.color colorWithAlphaComponent: 0.5] setFill];
					
					NSBezierPath *poly = [NSBezierPath bezierPath];
					[poly moveToPoint: NSMakePoint(prevVertex.sx, prevVertex.sy)];
					
					for (BAEVertex3D *currVertex in currPolygon.vertices)
					{
						[poly lineToPoint: NSMakePoint(currVertex.sx, currVertex.sy)];
					}
					
					[poly fill];
					[poly stroke];
				}
			}
		}
	}
}

-(BOOL) isFlipped
{
	return YES;
}

@end
