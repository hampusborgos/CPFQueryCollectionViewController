//
//  QueryCollectionViewController.m
//  CPFQueryViewController
//
//  Created by Hampus Nilsson on 10/6/12.
//  Copyright (c) 2012 FreedomCard. All rights reserved.
//

#import "CPFQueryCollectionViewController.h"
#import <Parse/Parse.h>

// Define our own version of NSLog(...) which will only send its input to the
// output if we are in debug mode and a assertion logger which will cause an
// assertion if we are in debug mode and a in non-debug mode it will output the
// assertion via NSLog(...)
#ifdef DEBUG
	#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:@(__PRETTY_FUNCTION__) file:@(__FILE__) lineNumber:__LINE__ description:__VA_ARGS__]
#else // !DEBUG
	#define ALog(...) NSLog(@"*** %s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif // DEBUG

@implementation CPFQueryCollectionViewController
{
    NSDate *_lastLoadedData;
    PF_EGORefreshTableHeaderView *_refreshHeaderView;
    UIActivityIndicatorView *_loadingIndicator;
}

// Private method called from all initializers
- (void)_initDefaults
{
    _loadingViewEnabled = YES;
    _pullToRefreshEnabled = YES;
    _paginationEnabled = NO;
    _objectsPerPage = 15;
    _objects = [NSArray new];
    
    _lastLoadedData = nil;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
        [self _initDefaults];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        [self _initDefaults];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self _initDefaults];
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
        [self _initDefaults];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the refresh view if necessary
    if (self.pullToRefreshEnabled)
    {
        // Create the view and set it's delegate
        // This will not work well if the layout is horizontal...
        _refreshHeaderView = [[PF_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -1000, self.view.frame.size.width, 1000)];
        _refreshHeaderView.delegate = self;
        [self.collectionView addSubview:_refreshHeaderView];
    }
    
    // Perform the first query
    [self performQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Parse.com logic

// Private method, called when a query should be performed
- (void)performQuery
{
    PFQuery *query = self.queryForCollection;
    
    if (_paginationEnabled) {
        [query setLimit:_objectsPerPage];
        //fetching the next page of objects
        if (!_isRefreshing) {
            [query setSkip:self.objects.count];
        }
    }
    
    [self objectsWillLoad];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.isLoading = NO;
        if (error)
            self.objects = [NSArray new];
        else {
            if (_paginationEnabled && !_isRefreshing) {
                //add a new page of objects
                NSMutableArray *mutableObjects = [NSMutableArray arrayWithArray:self.objects];
                [mutableObjects addObjectsFromArray:objects];
                self.objects = [NSArray arrayWithArray:mutableObjects];
            }
            else {
                self.objects = objects;
            }
        }
            
       
        [self objectsDidLoad:error];
    }];
}

- (void)objectsWillLoad
{
    // Enter the loading state
    self.isLoading = YES;
    
    // Display the loading thingy
    if (self.loadingViewEnabled)
    {
        if (!_loadingIndicator)
        {
            _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            _loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            _loadingIndicator.hidesWhenStopped = YES;
            _loadingIndicator.center = CGPointMake(self.collectionView.bounds.size.width / 2, self.collectionView.bounds.size.height / 2);
            [self.view addSubview:_loadingIndicator];
        }
        // Unhide if this is the second time loading
        _loadingIndicator.hidden = NO;
        [_loadingIndicator startAnimating];
    }
}

- (void)objectsDidLoad:(NSError *)error
{
    _lastLoadedData = [NSDate date];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    [_loadingIndicator stopAnimating];
    [self.collectionView reloadData];
}

- (PFQuery *)queryForCollection
{
    ALog(@"Overload this in your subclass to provide a Parse Query");
    return nil;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0)
    {
        // If you have overloaded `numberOfSectionsInCollectionView` but not `objectAtIndexPath` this might happen
        ALog(@"All objects should be contained in one single section.");
        return nil;
    }
    
    return [self.objects objectAtIndex:indexPath.row];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // No sections displayed while loading
    if (self.isLoading)
        return 0;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSAssert(section == 0, @"QueryCollectionView should only contain one section, overload this method in a subclass.");
    return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    ALog(@"You should overload this in your subclass.");
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Just fetch from the implementation that receives an object as a parameter
    return [self collectionView:collectionView cellForItemAtIndexPath:indexPath object:[self objectAtIndexPath:indexPath]];
}

#pragma mark - Scroll View delegate

// Forward these messages to the refresh view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //if the scrollView has reached the bottom fetch the next page of objects
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        [self setIsRefreshing:NO];
        [self performQuery];
    }
}

#pragma mark - EGO Refresh delegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(PF_EGORefreshTableHeaderView *)view
{
    // Trigger the refresh
    [self setIsRefreshing:YES];
    [self performQuery];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PF_EGORefreshTableHeaderView *)view
{
    return self.isLoading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(PF_EGORefreshTableHeaderView *)view
{
    // First time we will return nil, which is OK.
    // (Further returns of nil will result in (null) being displayed in the refresh view
    return _lastLoadedData;
}

@end
