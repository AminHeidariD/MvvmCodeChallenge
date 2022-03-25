# Code Challenge 

In this project my focus was on architecture to achieve a maintainable, testable and scalable code.

## Invested time:

1. 8 hours
    
## Following have been considered in the implementation:

1. MVVM & Combine architecture is chosen.
2. No third party used in this project
3. Open/Close principle is considered for loading data from sources(In this project RestApi implemented).
4. Strategy pattern is implemented for getting data from RestApi (In future we can add new strategy for loading data without any change in current codes).
5. Im memory cache is implemented for fetch users and for future enhancement it is good to implement it generic so in future we can save data easily to database instead of in memory
6. The code is testable by mocking view models, Api service and cache
7. Single responsibility considered in whole of project except some parts I mentioned below
8. Dependency inversion principle considered in this project and tried to use protocols as dependencies instead of concerete object
9. CollectionView is used to show the list, because collectionView is much flexible for future UI changes also table view used for detail view I thought it is much appropriate(currently we have two sections in table and can add or hide any section easily or add new section in future)

## Known defects:

1. Define a Interactor layer to save the data in cache
2. Implement Coordinator pattern for navigation and pass it as a dependency to viewModels
3. It is good to have pagination for load posts
4. The code is testable so write unit tests for view models

Also I put some TODO in the code for enhancement or implementation in future

### Developer
Amin Heidari
amin.hd66@gmail.com

Good luck!
