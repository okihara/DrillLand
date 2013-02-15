//
//  MasterLoader.h
//  Dri
//
//  Created by  on 12/11/12.
//  Copyright (c) 2012 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterLoader : NSObject

+(void)load:(NSString *)filename;
+(NSDictionary*)getMaster:(NSString*)masterName primaryId:(uint)id_;

@end
