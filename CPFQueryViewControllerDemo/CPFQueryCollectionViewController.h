//
//  QueryCollectionViewController.h
//  CPFQueryViewController
//
//  Created by Hampus Nilsson on 10/6/12.
//  Copyright (c) 2012 FreedomCard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

@interface CPFQueryCollectionViewController : UICollectionViewController <UICollectionViewDataSource, PF_EGORefreshTableHeaderDelegate>

/**
 * Is the query currently loading (being fetched)?
 */
@property (nonatomic) BOOL isLoading;

/**
 * Should the collection view show an activity indicator while a query is in progress?
 */
@property (nonatomic) BOOL loadingViewEnabled;

/**
 * Should the collection display the pull-to-refresh view?
 * This is not supported for horizontally scrolled collection views
 */
@property (nonatomic) BOOL pullToRefreshEnabled;

/**
 * The query to use to fetch the objects.
 * You can configure caching behavior etc. as you see fit
 */
@property (nonatomic, readonly) PFQuery *queryForCollection;

/**
 * Returns the fetched array of objects, or an empty array if nothing has been fetched.
 */
@property NSArray *objects;

/**
 * Called when a new query has been issued.
 * Overload this in a subclass if necessary. You must call [super] to make the view behave properly.
 */
- (void)objectsWillLoad;

/**
 * Called when a query finishes.
 * Overload this in a subclass if necessary. You must call [super] to make the view behave properly.
 */
- (void)objectsDidLoad:(NSError *)error;

/**
 * Get the PFObjects associated with this index path
 * Overload this and `numberOfSectionsInCollectionView` / `numberOfItemsInSection` to subdivide the table view into section.
 * call the super implementation to fetch the actual results)
 */
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Get the cell associated with an index path.
 * This version also receives the object associated with that index path. It's recommended to override this
 * instead of the usual version.
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object;

@end
