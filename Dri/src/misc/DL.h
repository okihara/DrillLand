//
//  DL.h
//  Dri
//
//  Created by  on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Dri_DL_h
#define Dri_DL_h

#define BLOCK_WIDTH 50
#define DL_FONT_NAME @"AppleGothic"

struct DLPoint {
    int x;
    int y;
};
typedef struct DLPoint DLPoint;

DLPoint cdp(int x, int y);


#endif
