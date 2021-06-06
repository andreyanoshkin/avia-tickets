//
//  PlaceViewController.m
//  avia-tickets
//
//  Created by Artur Igberdin on 05.03.2021.
//

#import "PlaceViewController.h"
#import "DataManager.h"
#import "City.h"
#import "Airport.h"

#define ReuseIdentifier @"CellIdentifier"

@interface PlaceViewController () <UISearchResultsUpdating>

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;

//Filtered
@property (nonatomic, strong) NSArray *filteredArray;

@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type
{
    self = [super init];
    if (self) {
        _placeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.searchResultsUpdater = self;
    self.filteredArray = @[];
    self.navigationItem.searchController = searchController;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Города", @"Аэропорты"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
    
    if (_placeType == PlaceTypeDeparture) {
        self.title = @"Откуда";
    } else {
        self.title = @"Куда";
    }
    
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
        self.filteredArray = [self.currentArray filteredArrayUsingPredicate: predicate];
        [self.tableView reloadData];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - Actions

- (void)changeSource
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            _currentArray = [[DataManager sharedInstance] airports];

            break;
         default:
             break;
     }
     [self.tableView reloadData];
 }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredArray.count > 0 ? self.filteredArray.count : self.currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *array = self.filteredArray.count > 0 ? self.filteredArray : self.currentArray;
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = array[indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = array[indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    
    NSArray *array = self.filteredArray.count > 0 ? self.filteredArray : self.currentArray;
    
    
    [self.delegate selectPlace:array[indexPath.row] withType:_placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
