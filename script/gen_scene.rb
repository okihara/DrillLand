# -*- coding: utf-8 -*-
MYNAME = 'Masataka Okihara'
MYCOMPANYNAME = 'HIROMITSU'

date = "12/09/16"
classname = ARGV[0] || 'Hoge'
puts classname

presen_path = '../Dri/src/scene/'
header_fname = "#{presen_path}#{classname}Scene.h"
impl_fname   = "#{presen_path}#{classname}Scene.m"

puts header_fname
puts impl_fname

puts '------------------------------------'

template_header = <<"TEMPLATE"
//
//  #{classname}Scene.h
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface #{classname}Scene : CCLayer

+(CCScene*)scene;

@end

TEMPLATE

# puts template_header

template_impl = <<"TEMPLATE"
//
//  #{classname}Scene.m
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import "#{classname}Scene.h"
#import "DungeonScene.h"

@implementation #{classname}Scene

- (id)init
{
    if( (self=[super init]) ) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"#{classname.upcase}" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];

        // enable touch
        self.isTouchEnabled = YES;

        // IMPLEMENT:
    }
    return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // IMPLEMENT:
    // EXAMPLE:
    // [[CCDirector sharedDirector] replaceScene:[DungeonScene scene]];
}

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [#{classname}Scene node];
    [scene addChild:layer];
    return scene;
}

@end

TEMPLATE

# puts template_impl

f = open(header_fname, 'w')
f.puts(template_header)
f.close

f = open(impl_fname, 'w')
f.puts(template_impl)
f.close
