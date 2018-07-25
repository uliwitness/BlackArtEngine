//
//  BAEMatrix.c
//  BlackArtEngine
//
//  Created by Uli Kusterer on 21.07.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#include "BAEMatrix.h"
#include <stdio.h>
#include <string.h>
#include <math.h>



void	BAEInitMatrix( BAEMatrix self )
{
	float identityMarix[4][4] =
	{
		{ 1.0, 0.0, 0.0, 0.0 },
		{ 0.0, 1.0, 0.0, 0.0 },
		{ 0.0, 0.0, 1.0, 0.0 },
		{ 0.0, 0.0, 0.0, 1.0 }
	};
	memcpy(self, identityMarix, sizeof(float) * 4 * 4);
}

void	BAECopyMatrix( const BAEMatrix self, BAEMatrix outCopy )
{
	memcpy(outCopy, self, sizeof(float) * 4 * 4);
}


void	BAEMultiplyMatrix( const BAEMatrix self, const BAEMatrix withMatrix, BAEMatrix outResult )
{
	for( int i = 0; i < 4; ++i)
	{
		for( int j = 0; j < 4; ++j)
		{
			outResult[i][j] = 0;
			
			for( int k = 0; k < 4; ++k)
			{
				outResult[i][j] += self[i][k] * withMatrix[k][j];
			}
		}
	}
}


void	BAETranslateMatrix( BAEMatrix self, float xTrans, float yTrans, float zTrans )
{
	BAEMatrix transMatrix =
	{
		{ 1.0, 0.0, 0.0, 0.0 },
		{ 0.0, 1.0, 0.0, 0.0 },
		{ 0.0, 0.0, 1.0, 0.0 },
		{ xTrans, yTrans, zTrans, 1.0 }
	};
	BAEMatrix tempMatrix;
	
	BAEMultiplyMatrix(self, transMatrix, tempMatrix);
	BAECopyMatrix(tempMatrix, self);
}


void	BAEScaleMatrix( BAEMatrix self, float scalingFactor )
{
	BAEMatrix scaleMatrix =
	{
		{ scalingFactor, 0.0, 0.0, 0.0 },
		{ 0.0, scalingFactor, 0.0, 0.0 },
		{ 0.0, 0.0, scalingFactor, 0.0 },
		{ 0.0, 0.0, 0.0, 1.0 }
	};
	BAEMatrix tempMatrix;
	
	BAEMultiplyMatrix(self, scaleMatrix, tempMatrix);
	BAECopyMatrix(tempMatrix, self);
}


void	BAERotateMatrix( BAEMatrix self, float xRot, float yRot, float zRot )
{
	BAEMatrix tempMatrix1;
	BAEMatrix tempMatrix2;
	BAEMatrix rotMatrix =
	{
		{ cosf(yRot), 0.0, -sinf(yRot), 0.0 },
		{ 0.0, 1.0, 0.0, 0.0 },
		{ sinf(yRot), 0.0, cosf(yRot), 0.0 },
		{ 0.0, 0.0, 0.0, 1.0 }
	};

	BAEMultiplyMatrix(self, rotMatrix, tempMatrix1);
	
	BAEMatrix rotMatrix2 =
	{
		{ 1.0, 0.0, 0.0, 0.0 },
		{ 0.0, cosf(xRot), sinf(xRot), 0.0 },
		{ 0.0, -sinf(xRot), cosf(xRot), 0.0 },
		{ 0.0, 0.0, 0.0, 1.0 }
	};

	BAEMultiplyMatrix(tempMatrix1, rotMatrix2, tempMatrix2);
	
	BAEMatrix rotMatrix3 =
	{
		{ cosf(zRot), sinf(zRot), 0.0, 0.0 },
		{ -sinf(zRot), cosf(zRot), 0.0, 0.0 },
		{ 0.0, 0.0, 1.0, 0.0 },
		{ 0.0, 0.0, 0.0, 1.0 }
	};

	BAEMultiplyMatrix(tempMatrix2, rotMatrix3, tempMatrix1);
	
	BAECopyMatrix(tempMatrix1, self);
}


void	BAEPrintMatrix( const BAEMatrix self )
{
	for (int x = 0; x < 4; ++x)
	{
		for (int y = 0; y < 4; ++y)
		{
			printf("[%d][%d] %f, ", x, y, self[x][y]);
		}
		
		printf("\n");
	}
	printf("\n");
}
