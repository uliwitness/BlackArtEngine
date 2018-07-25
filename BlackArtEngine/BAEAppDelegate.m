//
//  AppDelegate.m
//  BlackArtEngine
//
//  Created by Uli Kusterer on 21.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import "BAEAppDelegate.h"
#import "BAECanvasView.h"


@interface BAEAppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet BAECanvasView *canvasView;

@end


@implementation BAEAppDelegate

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	CIImage *textureImage1 = [CIImage imageWithContentsOfURL: [NSBundle.mainBundle URLForImageResource: @"WallTexture1"]];
	CIImage *textureImage2 = [CIImage imageWithContentsOfURL: [NSBundle.mainBundle URLForImageResource: @"WallTexture2"]];
	CIImage *textureImage3 = [CIImage imageWithContentsOfURL: [NSBundle.mainBundle URLForImageResource: @"WallTexture3"]];
	CIImage *textureImage4 = [CIImage imageWithContentsOfURL: [NSBundle.mainBundle URLForImageResource: @"WallTexture4"]];
	CIImage *textureImage5 = [CIImage imageWithContentsOfURL: [NSBundle.mainBundle URLForImageResource: @"WallTexture5"]];
	CIImage *textureImage6 = [CIImage imageWithContentsOfURL: [NSBundle.mainBundle URLForImageResource: @"WallTexture6"]];

	BAEObject3D *cubeObject = [BAEObject3D new];
	cubeObject.originX = 0;
	cubeObject.originY = 0;
	cubeObject.originZ = 320;
	cubeObject.polygons = @[
							[BAEPolygon3D polygonWithTextureImage: textureImage1 coordinates:
							 80.0, 80.0, -80.0,
							 80.0, -80.0, -80.0,
							 -80.0, -80.0, -80.0,
							 -80.0, 80.0, -80.0,
							 DBL_MIN], // back
							[BAEPolygon3D polygonWithTextureImage: textureImage2 coordinates:
							 -80.0, -80.0, 80.0,
							 -80.0, -80.0, -80.0,
							 80.0, -80.0, -80.0,
							 80.0, -80.0, 80.0,
							 DBL_MIN], // top
							[BAEPolygon3D polygonWithTextureImage: textureImage3 coordinates:
							 -80.0, 80.0, -80.0,
							 -80.0, 80.0, 80.0,
							 80.0, 80.0, 80.0,
							 80.0, 80.0, -80.0,
							 DBL_MIN], // bottom
							[BAEPolygon3D polygonWithTextureImage: textureImage4 coordinates:
							 -80.0, 80.0, -80.0,
							 -80.0, -80.0, -80.0,
							 -80.0, -80.0, 80.0,
							 -80.0, 80.0, 80.0,
							 DBL_MIN], // left
							[BAEPolygon3D polygonWithTextureImage: textureImage5 coordinates:
							 80.0, 80.0, 80.0,
							 80.0, -80.0, 80.0,
							 80.0, -80.0, -80.0,
							 80.0, 80.0, -80.0,
							 DBL_MIN], // right
							[BAEPolygon3D polygonWithTextureImage: textureImage6 coordinates:
							 -80.0, 80.0, 80.0,
							 -80.0, -80.0, 80.0,
							 80.0, -80.0, 80.0,
							 80.0, 80.0, 80.0,
							 DBL_MIN] // front
							];
	[cubeObject collectVerticesFromPolygons];
	self.canvasView.objects = @[ cubeObject ];
	
	[self.window setFrame: NSScreen.screens.firstObject.frame display: NO];
	[self startAnimation];
}

-(void) startAnimation
{
	__block float xAngle = 0.0, yAngle = 0.0;
	__block float scale = 1.0;
	__block BOOL scaleIncreasing = NO;
	
	[NSTimer scheduledTimerWithTimeInterval: 0.05 repeats: YES block:^(NSTimer * _Nonnull timer)
	{
		xAngle += 0.1;
		if (xAngle > 6.28)
			xAngle -= 6.28;
		
		yAngle += 0.15;
		if (yAngle > 6.28)
			yAngle -= 6.28;
		
		if (scaleIncreasing)
		{
			scale += 0.04;
			
			if (scale > 1.0)
			{
				scale = 1.0;
				scaleIncreasing = NO;
			}
		}
		else
		{
			scale -= 0.04;
			
			if (scale < 0.1)
			{
				scale = 0.1;
				scaleIncreasing = YES;
			}
		}
		
		BAEMatrix transformationMatrix;
		
		BAEInitMatrix(transformationMatrix);
		
		BAERotateMatrix(transformationMatrix, xAngle, yAngle, 0);

		BAEScaleMatrix(transformationMatrix, scale);

		[self.canvasView setTransformationMatrix: transformationMatrix];
	}];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self.window makeKeyAndOrderFront: self];
	NSApplication.sharedApplication.presentationOptions = NSApplicationPresentationAutoHideDock | NSApplicationPresentationAutoHideMenuBar;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	// Insert code here to tear down your application
}


@end
