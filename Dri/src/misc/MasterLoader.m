//
//  MasterLoader.m
//  Dri
//
//  Created by  on 12/11/12.
//  Copyright (c) 2012 Hiromitsu. All rights reserved.
//

#import "MasterLoader.h"
#import "SBJson.h"


NSMutableDictionary *masterTable;

@implementation MasterLoader

+(void)load:(NSString *)filename
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSString *jsonData = [NSString stringWithContentsOfFile:path 
                                                   encoding:NSUTF8StringEncoding error:nil];
    id jsonItem = [jsonData JSONValue];
    NSString *sheetName = [filename substringWithRange:NSMakeRange(0, [filename length] - 5)];

    NSArray *master_list = [(NSDictionary*)jsonItem objectForKey:sheetName];
    
    if (!masterTable) {
        masterTable = [[NSMutableDictionary alloc] init];
    }
    
    [masterTable setObject:master_list forKey:sheetName];
}

+(NSDictionary*)getMaster:(NSString*)masterName primaryId:(uint)id_;
{
    NSArray *master_list = [masterTable valueForKey:masterName];
    
    for (NSDictionary *json in master_list) {
        if (!json) {
            continue;
        }
        NSNumber *number = [json objectForKey:@"primary_id"];
        if ([number isKindOfClass:[NSNull class]]) {
            continue;
        }
        uint primaryId = [number intValue];
        if (primaryId == id_) {
            return json;
        }
    }
    return nil;
}

@end
