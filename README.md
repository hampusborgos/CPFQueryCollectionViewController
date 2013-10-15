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

The initDefaults method allows you to disable pullToRefresh, enable pagination and to set the number of objects per page for when pagination is enabled.

What's Missing
====

Using the view controller with template cells (ie. supplying `className` etc.
to the controller and let it handle the construction of the cells) is not yet supported. Constructing these
through Storyboards is so simple I did not feel it to be necessary.
