//
//  ViewController.m
//  CPFQueryViewControllerDemo
//
//  Created by Hampus Nilsson on 10/8/12.
//  Copyright (c) 2012 FreedomCard. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForCollection
{
    return [PFQuery queryWithClassName:@"Foo"];
}

@end
