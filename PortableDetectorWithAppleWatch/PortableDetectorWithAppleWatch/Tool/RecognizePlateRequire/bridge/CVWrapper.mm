//
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVWrapper.h"
#import "UIImage+OpenCV.h"
#import "stitching.h"
#import "UIImage+Rotate.h"
#import "UIImageCVMatConverter.h"
#include "../include/plate_locate.h"
#include "../include/plate_judge.h"
#include "../include/chars_segment.h"
#include "../include/chars_identify.h"

#include "../include/plate_detect.h"
#include "../include/chars_recognise.h"

#include "../include/plate_recognize.h"

#include "IdentifyResult.h"

@implementation CVWrapper

+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage
{
    NSArray* imageArray = [NSArray arrayWithObject:inputImage];
    UIImage* result = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;
{
    NSArray* imageArray = [NSArray arrayWithObjects:inputImage1,inputImage2,nil];
    UIImage* result = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithArray:(NSArray*)imageArray
{
    if ([imageArray count]==0){
        NSLog (@"imageArray is empty");
        return 0;
        }
    std::vector<cv::Mat> matImages;

    for (id image in imageArray) {
        if ([image isKindOfClass: [UIImage class]]) {
            /*
             All images taken with the iPhone/iPa cameras are LANDSCAPE LEFT orientation. The  UIImage imageOrientation flag is an instruction to the OS to transform the image during display only. When we feed images into openCV, they need to be the actual orientation that we expect them to be for stitching. So we rotate the actual pixel matrix here if required.
             */
            UIImage* rotatedImage = [image rotateToImageOrientation];
            cv::Mat matImage = [rotatedImage CVMat3];
            NSLog (@"matImage: %@",image);
            matImages.push_back(matImage);
        }
    }
    NSLog (@"stitching...");
    cv::Mat stitchedMat = stitch (matImages);
    UIImage* result =  [UIImage imageWithCVMat:stitchedMat];
    return result;
}
+ (NSString*) processWithIdentify:(UIImage *)inputImage
{
    
    return @"hello";
}
+ (IdentifyResult*) recognizePlate:(NSString*) inputImageName
{
    IdentifyResult* result = [IdentifyResult new];
    string image_path=[inputImageName UTF8String];
    cv::Mat source_image;
    source_image=imread(image_path);
    resize(source_image, source_image,cv::Size(source_image.cols/2,source_image.rows/2));
    vector<string> plateVec;
    easypr::CPlateRecognize pr;
    NSString *ann_ns=[[NSBundle mainBundle]pathForResource:@"ann" ofType:@"xml"];
    NSString *svm_ns=[[NSBundle mainBundle]pathForResource:@"svm" ofType:@"xml"];
    string annpath=[ann_ns UTF8String];
    string svmpath=[svm_ns UTF8String];
    pr.LoadANN(annpath);
    pr.LoadSVM(svmpath);
    
    pr.setLifemode(true);
    pr.setDebug(false);
    
    int flag = pr.plateRecognize(source_image, plateVec);
    if(flag==0 && plateVec.size()!=0)
    {
        result->stringIdentifyResult = [NSString stringWithUTF8String: plateVec[0].c_str()];
        Mat cvMat = pr.res;
        NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
        
        CGColorSpaceRef colorSpace;
        
        if (cvMat.elemSize() == 1) {
            colorSpace = CGColorSpaceCreateDeviceGray();
        } else {
            colorSpace = CGColorSpaceCreateDeviceRGB();
        }
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
        
        CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                            cvMat.rows,                                     // Height
                                            8,                                              // Bits per component
                                            8 * cvMat.elemSize(),                           // Bits per pixel
                                            cvMat.step[0],                                  // Bytes per row
                                            colorSpace,                                     // Colorspace
                                            kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                            provider,                                       // CGDataProviderRef
                                            NULL,                                           // Decode
                                            false,                                          // Should interpolate
                                            kCGRenderingIntentDefault);                     // Intent
        
        UIImage *imageResult = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpace);
        result->imageIdentifyResult = UIImagePNGRepresentation(imageResult);
        result->errorInfo = @"Success";
    }
    else{
        result->errorInfo = @"Error";
    }
    return result;
}
@end
