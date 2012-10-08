`CPFQueryCollectionViewController` is a plug-in view controller than can be used like
`PFQueryTableViewController` but for collection views (`PFQueryCollectionViewController`
if you prefer).

Installation
====

It's enough to include `CPFQueryCollectionViewController.h / .m` in your project and
import them to start using it. Simply change your collection views to inherit from
`CPFQueryCollectionViewController` instead of the plain `UICollectionViewController`

Usage
====

Using the controller is very similar to Parse.coms table view controller.

    https://parse.com/docs/ios/api/Classes/PFQueryTableViewController.html
    
You *must* overload `queryForCollection` to return a `PFQuery` that returns the objects you want
to display.

You *must* overload `collectionView:cellForItemAtIndexPath:object:` to provide a your collection
view cells.

You *may* overload `objectsWillLoad`, `objectsDidLoad` to hook into the pre and post loading of
the view. If you do, you must call [super objects\*Load] to get the proper behavior from the
loading indicator et. al.

You can also override the usual `numberOfSectionsInCollectionView:`, `collectionView:numberOfItemsInSection:`
to tweak the order in which the items appear in the collection. Remember to also override `objectAtIndexPath:`
in this case.

What's Missing
====

Pagination is not yet supported since I did not need it for my uses. And it's quite
compilacted to import. Also it makes much less sense for grid views than for table views
in general.

Neither is using the view controller with template cells (ie. supplying `className` etc.
to the controller and let it handle the construction of the cells). Constructing these
through Storyboards is so simple I did not feel it to be necessary.