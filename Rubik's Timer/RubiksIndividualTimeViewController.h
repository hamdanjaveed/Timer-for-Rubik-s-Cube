//
//  RubiksIndividualTimeViewController.h
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 1/9/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RubiksIndividualTimeViewController : UIViewController
@property (nonatomic) NSTimeInterval time;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *scramble;
@end
