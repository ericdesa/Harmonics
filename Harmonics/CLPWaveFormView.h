//
//  CLPWaveFormView.h
//  Harmonics
//
//  Created by Eric on 08/05/2015.
//  Copyright (c) 2015 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CLPWaveFormView : UIView

@property (nonatomic, copy) CGFloat (^getFrequencyBlock)(CGFloat x);
@property (nonatomic, copy) void (^waveHasChanged)();

@property (nonatomic, strong) IBInspectable UIColor *graduationColor;
@property (nonatomic, strong) IBInspectable UIColor *waveColor;
@property (nonatomic, assign) IBInspectable BOOL gestureEnabled;

@property (nonatomic, assign) CGFloat frequency;
@property (nonatomic, assign) CGFloat volume;

@property (nonatomic, assign) CGFloat note;

@end
