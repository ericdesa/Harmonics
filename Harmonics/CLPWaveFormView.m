//
//  CLPWaveFormView.m
//  Harmonics
//
//  Created by Eric on 08/05/2015.
//  Copyright (c) 2015 Eric. All rights reserved.
//

#import "CLPWaveFormView.h"


@interface CLPWaveFormView()

@property (nonatomic, assign) BOOL enableSound;
@property (nonatomic, assign) CGFloat offset;


@end

@implementation CLPWaveFormView

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.enableSound = YES;
        self.frequency = 500;
        self.volume = 30;
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _addGestures];
}

- (void) _addGestures
{
    if(self.gestureEnabled)
    {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureHandler:)];
        [self addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureHandler:)];
        [self addGestureRecognizer:tapGesture];
    }
}

- (void) _panGestureHandler:(UIPanGestureRecognizer*)gesture
{
    CGPoint velocity = [gesture velocityInView:self];
    if(fabs(velocity.x) > fabs(velocity.y))
    {
        self.frequency = MAX(0.001f, self.frequency+velocity.x/100);
    }
    else
    {
        self.volume = MAX(0.01f, self.volume-velocity.y/500);
    }
    
    if(self.waveHasChanged)
    {
        self.waveHasChanged();
    }
    
    [self setNeedsDisplay];
}

- (void) _tapGestureHandler:(UITapGestureRecognizer*)gesture
{
    self.enableSound = !self.enableSound;
    
    if(self.waveHasChanged)
    {
        self.waveHasChanged();
    }
    [self setNeedsDisplay];
}

- (void) setEnableSound:(BOOL)enableSound
{
    _enableSound = enableSound;
    self.alpha = enableSound?1:0.5f;
}

- (void)setNote:(CGFloat)note
{
    _note = note;
    [self setNeedsDisplay];
}

- (CGFloat)volume
{
    if(self.enableSound) return _volume;
    else return 0;
}

- (CGFloat)frequency
{
    if(self.enableSound) return _frequency;
    else return 0;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // background
    [self.backgroundColor setFill];
    CGContextFillRect(context, rect);
    
    
    // grid
    [self.graduationColor setFill];
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat width_2 = width/2;
    CGFloat height_2 = height/2;
    
    CGContextFillRect(context, CGRectMake(0, height_2, width, 1));
    CGContextFillRect(context, CGRectMake(width_2, 0, 1, height));
    

    // graduations
    CGFloat graduation = 10;
    CGFloat graduation_2 = graduation/2;
    
    NSInteger nbWidthGraduation = width/graduation;
    for(int x=width_2-(nbWidthGraduation/2*graduation); x<width; x+=graduation)
    {
        CGContextFillRect(context, CGRectMake(x, height_2-graduation_2, 1, graduation));
    }
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:12],
                                 NSForegroundColorAttributeName : self.waveColor};
    
    NSInteger nbHeightGraduation = height/graduation;
    int i=0;
    for(int y=height_2-(nbHeightGraduation/2*graduation); y<height; y+=graduation)
    {
        [self.graduationColor setFill];
        CGContextFillRect(context, CGRectMake(width_2-graduation_2, y, graduation, 1));
        
        if(i%4==0)
        {
            [[@((height_2-y)*50) description] drawAtPoint:CGPointMake(width_2+10, y-6) withAttributes:attributes];
        }
        i++;
    }
    
    if(self.enableSound)
    {
        // wave
        [self.waveColor setStroke];
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat offsetY = height_2;
        CGFloat x = -width_2;
        
        CGPathMoveToPoint(path, nil, x, offsetY);
        while (x<=width) {
            CGFloat y = 0;
            if(self.enableSound && self.getFrequencyBlock)
            {
                y = self.getFrequencyBlock(x);
            }
            
            CGPathAddLineToPoint(path, nil, x, y+offsetY);
            x++;
        }
        
        CGContextAddPath(context, path);
        CGContextDrawPath(context, kCGPathStroke);
        
        
        // note position
        [[UIColor redColor] setFill];
        CGFloat frequency = self.getFrequencyBlock(self.note);
        
        CGContextFillRect(context, CGRectMake(self.note, 0, 2, height));
        CGContextFillRect(context, CGRectMake(self.note-graduation_2, frequency+offsetY, graduation, 2));
        
        
        // label
        NSString *text = @"";
        if(self.gestureEnabled)
        {
            text = [NSString stringWithFormat:@"%d Hz | %.2f volume", (int)self.frequency, self.volume];
        }
        else
        {
            CGFloat frequency = self.getFrequencyBlock(self.note)*50*-1;
            text = [NSString stringWithFormat:@"%d Hz", (int)frequency];
        }
        
        [text drawAtPoint:CGPointMake(10, height-20) withAttributes:attributes];
    }
    else
    {
        [@"disabled" drawAtPoint:CGPointMake(10, height-20) withAttributes:attributes];
    }
}


@end
