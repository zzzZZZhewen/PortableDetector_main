//
//  IdentifyResult.h
//  TestOpenCVSwift
//
//  Created by 梁栋 on 16/2/22.
//  Copyright © 2016年 梁栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef IdentifyResult_h
#define IdentifyResult_h

/// stringIdentifyResult:
/// imageIdentifyResult
/// errorInfo
@interface IdentifyResult : NSObject
{
    @public NSString* stringIdentifyResult;
    @public NSData* imageIdentifyResult;
    @public NSString* errorInfo;
}
-(NSString*) getString;
-(NSData*) getImage;
-(NSString*) getError;
@end

#endif /* IdentifyResult_h */
