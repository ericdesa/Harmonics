//
//  ViewController.m
//  Harmonics
//
//  Created by Eric on 08/05/2015.
//  Copyright (c) 2015 Eric. All rights reserved.
//

#import "ViewController.h"

#import "CLPWaveFormView.h"
#import "TGSineWaveToneGenerator.h"

#import "CLPNote.h"


@interface ViewController ()

@property (assign, nonatomic) CGFloat pitch;
@property (assign, nonatomic) NSInteger note;

@property (strong, nonatomic) TGSineWaveToneGenerator *toneGenerator;

@property (weak, nonatomic) IBOutlet CLPWaveFormView *finalWaveView;
@property (weak, nonatomic) IBOutlet CLPWaveFormView *waveView1;
@property (weak, nonatomic) IBOutlet CLPWaveFormView *waveView2;
@property (weak, nonatomic) IBOutlet CLPWaveFormView *waveView3;

@property (strong, nonatomic) NSArray *noteArray;
@property (assign, nonatomic) NSInteger noteIndex;
@property (assign, nonatomic) NSInteger beat;

@end

@implementation ViewController

//
//float noteFrequency[111] = {
//    8.1758, 8.6620, 9.1770, 9.7227, 10.3009, 10.9134, 11.5623, 12.2499,
//    12.9783, 13.7500, 14.5676, 15.4339, 16.3516, 17.3239, 18.3540, 19.4454,
//    20.6017, 21.8268, 23.1247, 24.4997, 25.9565, 27.5000, 29.1352, 30.8677,
//    32.7032, 34.6478, 36.7081, 38.8909, 41.2034, 43.6535, 46.2493, 48.9994,
//    51.9131, 55.0000, 58.2705, 61.7354, 65.4064, 69.2957, 73.4162, 77.7817,
//    82.4069, 87.3071, 92.4986, 97.9989, 103.8262, 110.0000, 116.5409, 123.4708,
//    130.8128, 138.5913, 146.8324, 155.5635, 164.8138, 174.6141, 184.9972,
//    195.9977, 207.6523, 220.0000, 233.0819, 246.9417, 261.6256, 277.1826,
//    293.6648, 311.1270, 329.6276, 349.2282, 369.9944, 391.9954, 415.3047,
//    440.0000, 466.1638, 493.8833, 523.2511, 554.3653, 587.3295, 622.2540,
//    659.2551, 698.4565, 739.9888, 783.9909, 830.6094, 880.0000, 932.3275,
//    987.7666, 1046.5023, 1108.7305, 1174.6591, 1244.5079, 1318.5102, 1396.9129,
//    1479.9777, 1567.9817, 1661.2188, 1760.0000, 1864.6550, 1975.5332, 2093.0045,
//    2217.4610, 2349.3181, 2489.0159, 2637.0205, 2793.8259, 2959.9554, 3135.9635,
//    3322.4376, 3520.0000, 3729.3101, 3951.0664, 4186.0090, 4434.9221, 4698.6363
//};
//
//NSString *noteName[111] = {
//    @"", @"", @"", @"", @"", @"", @"", @"",
//    @"", @"", @"", @"", @"", @"", @"", @"",
//    @"", @"", @"", @"A0", @"", @"B0", @"C1", @"",
//    @"D1", @"#D1", @"E1", @"F1", @"#F1", @"G1", @"#G1", @"A1",
//    @"#B1", @"B1", @"C2", @"#D2", @"D2", @"#E2", @"E2", @"F2",
//    @"#G2", @"G2", @"#A2", @"A2", @"#B2", @"B2", @"C3", @"#D3",
//    @"D3", @"#E3", @"E3", @"F3", @"#G3", @"G3", @"#A3", @"A3",
//    @"#B3", @"B3", @"C4", @"#D4", @"D4", @"#E4", @"E4", @"F4",
//    @"#G4", @"G4", @"#A4", @"A4", @"#B4", @"B4", @"C5", @"#D5",
//    @"D5", @"#E5", @"E5", @"F5", @"#G5", @"G5", @"#A5", @"A5",
//    @"#B5", @"B5", @"C6", @"#C6", @"D6", @"#E6", @"E6", @"F6",
//    @"#G6", @"G6", @"#A6", @"A6", @"#B6", @"B6", @"C7", @"#D7",
//    @"D7", @"#E7", @"E7", @"F7", @"#G7", @"G7", @"#G7", @"A7",
//    @"#B7", @"B7", @"C8", @"", @"",
//};


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.pitch = 0.05;
    self.note = 0;
    
    self.toneGenerator = [[TGSineWaveToneGenerator alloc] initWithChannels:1];
    
    self.waveView1.frequency = 200;
    self.waveView2.frequency = 300;
    self.waveView3.frequency = 400;
    
    self.waveView1.getFrequencyBlock = ^CGFloat(CGFloat x) {
        return [self _frequencyAtX:x forWaveView:self.waveView1];
    };
    self.waveView1.waveHasChanged = ^() {
        [self.finalWaveView setNeedsDisplay];
    };
    
    
    self.waveView2.getFrequencyBlock = ^CGFloat(CGFloat x) {
        return [self _frequencyAtX:x forWaveView:self.waveView2];
    };
    self.waveView2.waveHasChanged = ^() {
        [self.finalWaveView setNeedsDisplay];
    };
    
    
    self.waveView3.getFrequencyBlock = ^CGFloat(CGFloat x) {
        return [self _frequencyAtX:x forWaveView:self.waveView3];
    };
    self.waveView3.waveHasChanged = ^() {
        [self.finalWaveView setNeedsDisplay];
    };
    
    
    self.finalWaveView.getFrequencyBlock = ^CGFloat(CGFloat x) {
        return [self _harmonicAtX:x];
    };
    
    //[self _nextFrequency];
    
    NSString *rtttl = @"Tetris:d=4,o=5,b=200:e6,8b,8c6,8d6,16e6,16d6,8c6,8b,a,8a,8c6,e6,8d6,8c6,b,8b,8c6,d6,e6,c6,a,2a,8p,d6,8f6,a6,8g6,8f6,e6,8e6,8c6,e6,8d6,8c6,b,8b,8c6,d6,e6,c6,a,a";
    
    //NSString *rtttl = @"Beethoven:d=4,o=5,b=250:e6,d#6,e6,d#6,e6,b,d6,c6,2a.,c,e,a,2b.,e,a,b,2c.6,e,e6,d#6,e6,d#6,e6,b,d6,c6,2a.,c,e,a,2b.,e,c6,b,1a";
    
    NSArray *componentArray = [[rtttl stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@":"];
    NSString *soundName = componentArray[0];
    NSString *settings = componentArray[1];
    NSString *notes = componentArray[2];
    
    CGFloat defaultDuration = 0;
    CGFloat defaultOctave = 0;
    CGFloat beat = 0;
    
    for(NSString *parameter in [settings componentsSeparatedByString:@","])
    {
        NSArray *parameterComponentArray = [parameter componentsSeparatedByString:@"="];
        NSString *key = parameterComponentArray[0];
        NSString *value = parameterComponentArray[1];
        if([key isEqualToString:@"d"]) defaultDuration = [value floatValue];
        else if([key isEqualToString:@"o"]) defaultOctave = [value floatValue];
        else if([key isEqualToString:@"b"]) beat = [value floatValue];
    }
    
    NSLog(@"*** %@ ***", soundName);
    
    NSMutableArray *noteArray = [NSMutableArray new];

    for(NSString *note in [notes componentsSeparatedByString:@","])
    {
        NSString *noteName = note;
        CGFloat noteDuration = defaultDuration;
        CGFloat noteOctave = defaultOctave;
        
        NSArray *numberArray = [noteName componentsSeparatedByCharactersInSet:
                                [NSCharacterSet letterCharacterSet]];
        
        NSLog(@"== %@ ==", note);
        for(NSString *value in numberArray)
        {
            if(![value isEqualToString:@""])
            {
                NSString *cleanedValue = [value stringByReplacingOccurrencesOfString:@"#" withString:@""];
                if([noteName hasPrefix:cleanedValue])
                {
                    noteDuration = [cleanedValue floatValue];
                }
                else {
                    noteOctave = [cleanedValue floatValue];
                }
                noteName = [noteName stringByReplacingOccurrencesOfString:cleanedValue withString:@""];
            }
        }
        
        if([note containsString:@"."])
        {
            noteOctave = defaultOctave;
            //noteDuration *= 2;
        }
        
        NSLog(@"  >> note %@", noteName);
        NSLog(@"  >> octave %d", (int)noteOctave);
        NSLog(@"  >> duration %d", (int)noteDuration);
        
        
        CLPNote *note = [CLPNote new];
        note.duration = noteDuration;
        note.frequency = [self _frequencyForNoteName:noteName withOctave:noteOctave];
        [noteArray addObject:note];
    }
    
    self.noteArray = noteArray;
    self.noteIndex = 0;
    self.beat = beat;
    
    [self _playNotes];
}


- (void) _playNotes
{
    if(self.noteArray.count > self.noteIndex)
    {
        CLPNote *note = self.noteArray[self.noteIndex];
        
        CGFloat beatDuration = (60.0f / self.beat);
        CGFloat noteDuration = beatDuration/(CGFloat)note.duration*4;
        
        self.toneGenerator->_channels[0].frequency = note.frequency;
        [self.toneGenerator playForDuration:noteDuration];
        
        NSLog(@"%f Hz, duration : %f, beat : %f", note.frequency, noteDuration, beatDuration);
        self.noteIndex++;
        [self performSelector:@selector(_playNotes) withObject:nil afterDelay:noteDuration];
    }
    
    else
    {
        [self.toneGenerator stop];
    }
}


- (CGFloat) _frequencyForNoteName:(NSString*)noteName withOctave:(NSInteger)octave
{
    CGFloat c  = 16.352;
    CGFloat cd = 17.324;
    CGFloat d  = 18.354;
    CGFloat de = 19.445;
    CGFloat e  = 20.602;
    CGFloat f  = 21.827;
    CGFloat fg = 23.125;
    CGFloat g  = 24.500;
    CGFloat ag = 25.957;
    CGFloat a  = 27.500;
    CGFloat ba = 29.135;
    CGFloat b  = 30.868;
    
    CGFloat frequency = 0;
    
    if([noteName isEqualToString:@"a"]) frequency = a;
    else if([noteName isEqualToString:@"c"])  frequency = c;
    else if([noteName isEqualToString:@"c#"]) frequency = cd;
    else if([noteName isEqualToString:@"d"])  frequency = d;
    else if([noteName isEqualToString:@"d#"]) frequency = de;
    else if([noteName isEqualToString:@"e"])  frequency = e;
    else if([noteName isEqualToString:@"f"])  frequency = f;
    else if([noteName isEqualToString:@"f#"]) frequency = fg;
    else if([noteName isEqualToString:@"g"])  frequency = g;
    else if([noteName isEqualToString:@"a#"]) frequency = ag;
    else if([noteName isEqualToString:@"a"])  frequency = a;
    else if([noteName isEqualToString:@"b#"]) frequency = ba;
    else if([noteName isEqualToString:@"b"])  frequency = b;
    else {
        
    }
    
    
    if(frequency != 0)
    {
        frequency *= pow(2, octave-1);
    }
    

    return frequency;
}

- (CGFloat) _frequencyAtX:(CGFloat)x forWaveView:(CLPWaveFormView*)waveView
{
    if(waveView.frequency != 0)
    {
        return sinf(x*waveView.frequency / 5000) * waveView.volume;
    }
    else
    {
        return 0;
    }
}

- (CGFloat) _harmonicAtX:(CGFloat)x
{
    CGFloat frequency1 = [self _frequencyAtX:x forWaveView:self.waveView1];
    CGFloat frequency2 = [self _frequencyAtX:x forWaveView:self.waveView2];
    CGFloat frequency3 = [self _frequencyAtX:x forWaveView:self.waveView3];
    CGFloat harmonic = (frequency1 + frequency2 + frequency3);
    return harmonic;
}

- (void) _nextFrequency
{
    CGFloat frequency = [self _harmonicAtX:self.note];
    [self _play:frequency];
 
    self.finalWaveView.note = self.note;
    self.waveView1.note = self.note;
    self.waveView2.note = self.note;
    self.waveView3.note = self.note;
        
    self.note++;
    if(self.note > CGRectGetWidth(self.view.frame))
    {
        self.note=0;
    }
}

- (void) _play:(CGFloat)frequency
{
    self.toneGenerator->_channels[0].frequency = frequency*50*-1;
    [self.toneGenerator playForDuration:self.pitch];
    
    [self performSelector:@selector(_nextFrequency) withObject:nil afterDelay:self.pitch];
}

@end
