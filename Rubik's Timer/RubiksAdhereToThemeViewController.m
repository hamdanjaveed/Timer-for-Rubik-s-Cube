//
//  RubiksAdhereToThemeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 2014-05-02.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import "RubiksAdhereToThemeViewController.h"

@interface RubiksAdhereToThemeViewController ()

@end

@implementation RubiksAdhereToThemeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [RubiksUtil getThemeBackground];
    [RubiksUtil setAppropriateStatusBarStyleWithShouldCheck:YES];
}

@end
