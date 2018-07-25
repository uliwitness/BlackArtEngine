//
//  BAECanvasView.h
//  BlackArtEngine
//
//  Created by Uli Kusterer on 21.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BAEMatrix.h"


NS_ASSUME_NONNULL_BEGIN

@interface BAECanvasView : NSView

-(void)			setTransformationMatrix: (BAEMatrix)inMatrix;

@end

NS_ASSUME_NONNULL_END
