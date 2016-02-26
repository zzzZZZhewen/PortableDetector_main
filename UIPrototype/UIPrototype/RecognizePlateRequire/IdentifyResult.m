//
//  IdentifyResult.m
//  TestOpenCVSwift
//
//  Created by 梁栋 on 16/2/22.
//  Copyright © 2016年 梁栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "IdentifyResult.h"


@implementation IdentifyResult:NSObject
{

}

-(NSData*) getImage
{
    //[self imageIdentifyResult] = x;
    return imageIdentifyResult;
}
-(NSString*) getString
{
    //[self stringIdentifyResult] = x;
    //stringIdentifyResult = x;
    return stringIdentifyResult;

}
-(NSString*) getError
{
    return errorInfo;
}

@end