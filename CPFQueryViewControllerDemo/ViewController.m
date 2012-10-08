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

# pragma mark - Collection View data source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Foo" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor colorWithRed:[object[@"color"][@"red"] floatValue]
                                           green:[object[@"color"][@"green"] floatValue]
                                            blue:[object[@"color"][@"blue"] floatValue]
                                          alpha:1];

    [(UILabel *)[cell viewWithTag:1] setText:object[@"name"]];

    return cell;
}

@end
