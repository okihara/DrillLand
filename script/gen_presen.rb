# -*- coding: utf-8 -*-
MYNAME = 'Masataka Okihara'
MYCOMPANYNAME = 'HIROMITSU'

date = "12/09/16"
classname = ARGV[0] || 'Hoge'
puts classname

presen_path  = './Dri/src/block_presentation/'
header_fname = presen_path + classname + 'Presentation.h'
impl_fname   = presen_path + classname + 'Presentation.m'

puts header_fname
puts impl_fname

puts '------------------------------------'

template_header = <<"TEMPLATE"
//
//  #{classname}Presentation.h
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockView.h"

@interface #{classname}Presentation : NSObject<BlockPresentation>

@end

TEMPLATE

# puts template_header

template_impl = <<"TEMPLATE"
//
//  #{classname}Presentation.m
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import "#{classname}Presentation.h"
#import "DungeonView.h"

@implementation #{classname}Presentation

-(CCAction*)handle_event:(DungeonView *)dungeon_view event:(DLEvent*)event view:(BlockView *)block_view
{
    switch (event.type) {

        case DL_ON_DESTROY:
        {
            // implement here
            return nil;
        }
            break;

        default:
            return nil;
            break;
    }
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
