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
	CGFloat	_angle;
	CGFloat _x;
	CGFloat _z;
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


-(void)	keyDown: (NSEvent *)event
{
	[self interpretKeyEvents: @[event]];
}


-(void) moveUp:(nullable id)sender
{
	_z += 10.0;
	[self updateTransformation];
}


-(void) moveDown:(nullable id)sender
{
	_z -= 10.0;
	[self updateTransformation];
}


-(void) moveLeft:(nullable id)sender
{
//	_x -= 10.0;
	_angle += 0.1;
	if (_angle < 0.0)
		_angle += 6.28;

	[self updateTransformation];
}


-(void) moveRight:(nullable id)sender
{
//	_x += 10.0;
	_angle -= 0.1;
	if (_angle > 6.28)
		_angle -= 6.28;
	[self updateTransformation];
}


-(void) updateTransformation
{
	if (_angle > 6.28)
		_angle -= 6.28;
	
	BAEInitMatrix(_transformationMatrix);
	
	BAERotateMatrix(_transformationMatrix, 0, _angle, 0);
	BAETranslateMatrix(_transformationMatrix, -_x, 0, -_z);

	[self setNeedsDisplay: YES];

}


-(BOOL)	acceptsFirstResponder
{
	return YES;
}


-(BOOL)	becomeFirstResponder
{
	return YES;
}


-(BOOL)	resignFirstResponder
{
	return YES;
}


-(void)mouseDown:(NSEvent *)event
{
	[self.window makeFirstResponder: self];
}


-(void) drawRect: (NSRect)dirtyRect
{
	[NSColor.whiteColor	set];
	NSRectFill(self.bounds);
	
	CGFloat scaleFactor = self.window.backingScaleFactor;
	
	for (BAEObject3D *currObject in self.objects)
	{
		[currObject transform: _transformationMatrix];
		[currObject objectToWorldCoordinates];
		[currObject projectWithWindowWidth:self.bounds.size.width * scaleFactor height: self.bounds.size.height * scaleFactor scaleFactor: scaleFactor];
	}

	[NSGraphicsContext saveGraphicsState];
	NSAffineTransform *scaleTransform = [NSAffineTransform transform];
	[scaleTransform scaleBy: 1.0 / scaleFactor];
	[scaleTransform concat];
	
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
					CGPoint bottomLeftPoint = NSMakePoint(currPolygon.vertices[0].sx, currPolygon.vertices[0].sy);
					CGPoint bottomRightPoint = NSMakePoint(currPolygon.vertices[3].sx, currPolygon.vertices[3].sy);
					CGPoint topRightPoint = NSMakePoint(currPolygon.vertices[2].sx, currPolygon.vertices[2].sy);
					CGPoint topLeftPoint = NSMakePoint(currPolygon.vertices[1].sx, currPolygon.vertices[1].sy);
					
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
	[NSGraphicsContext restoreGraphicsState];
}

-(BOOL) isFlipped
{
	return YES;
}

@end
