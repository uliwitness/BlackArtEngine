//
//  BAEMatrix.h
//  BlackArtEngine
//
//  Created by Uli Kusterer on 21.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#ifndef BAEMATRIX_H
#define BAEMATRIX_H


typedef float BAEMatrix[4][4];


void	BAEInitMatrix( BAEMatrix self );

void	BAECopyMatrix( const BAEMatrix self, BAEMatrix outCopy );

void	BAEMultiplyMatrix( const BAEMatrix self, const BAEMatrix withMatrix, BAEMatrix outResult );
void	BAETranslateMatrix( BAEMatrix self, float xTrans, float yTrans, float zTrans );
void	BAEScaleMatrix( BAEMatrix self, float scalingFactor );
void	BAERotateMatrix( BAEMatrix self, float xRot, float yRot, float zRot );

void	BAEPrintMatrix( const BAEMatrix self );


#endif /*BAEMATRIX_H*/
