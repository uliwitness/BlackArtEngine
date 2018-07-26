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
//	[self startAnimation];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//[self.window makeKeyAndOrderFront: self];
	[self.window toggleFullScreen: self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	// Insert code here to tear down your application
}


@end
