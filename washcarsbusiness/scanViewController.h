//
//  scanViewController.h
//  washcarsbusiness
//
//  Created by Robinpad on 14-8-15.
//  Copyright (c) 2014年 Robinpad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface scanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@end
