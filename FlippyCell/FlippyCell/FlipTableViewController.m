//
//  FlipTableViewController.m
//  FlippyCell
//
//  Created by Ethan Hess on 6/26/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import "FlipTableViewController.h"
#import "FlippyCell.h"
#import "ItemController.h"
#import "Item.h"

static NSString * const kFlipCellIdentifier = @"kFlipCellIdentifier";

@interface FlipTableViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;


@property (nonatomic, strong) NSDictionary *itemDescritions;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSMutableSet *expandedIndexPaths;

@property (nonatomic, strong) UITextField *itemTitle;
@property (nonatomic, strong) UITextField *itemDescription;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic) BOOL isExtended;

@end

@implementation FlipTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isExtended = NO;
    
    [self loadCellAndTableView];
    [self setUpTextFields];
}

- (void)setUpTextFields {
    
    self.itemTitle = [[UITextField alloc]initWithFrame:CGRectMake(50, 85, self.topView.frame.size.width - 100, 50)];
    self.itemTitle.backgroundColor = [UIColor whiteColor];
    self.itemTitle.placeholder = @"Title";
    self.itemTitle.delegate = self;
    self.itemTitle.hidden = YES;
    [self.topView addSubview:self.itemTitle];
    
    self.itemDescription = [[UITextField alloc]initWithFrame:CGRectMake(50, 150, self.topView.frame.size.width - 100, 50)];
    self.itemDescription.backgroundColor = [UIColor whiteColor];
    self.itemDescription.placeholder = @"Description";
    self.itemDescription.delegate = self;
    self.itemDescription.hidden = YES;
    [self.topView addSubview:self.itemDescription];
    
    //and button
    
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 220, self.topView.frame.size.width - 200, 50)];
    [self.saveButton setTitle:@"Save!" forState:UIControlStateNormal];
    self.saveButton.titleLabel.textColor = [UIColor whiteColor];
    self.saveButton.backgroundColor = [UIColor darkGrayColor];
    self.saveButton.layer.cornerRadius = 10;
    [self.saveButton addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.hidden = YES;
    [self.topView addSubview:self.saveButton];
    
}

- (void)loadCellAndTableView {
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([FlippyCell class])
                                    bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:kFlipCellIdentifier];
    self.expandedIndexPaths = [NSMutableSet set];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlippyCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:kFlipCellIdentifier];
    
//    NSString *itemTitle = self.itemArray[indexPath.row];
    
//    cell.titleLabel.text = itemTitle;
//    cell.descriptionLabel.text = self.itemDescritions[itemTitle];
    
    Item *item = [ItemController sharedInstance].items[indexPath.row];
    
    cell.titleLabel.text = item.title;
    cell.descriptionLabel.text = item.desc;
    
    cell.withDetails = [self.expandedIndexPaths containsObject:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.itemArray.count;
    
    return [ItemController sharedInstance].items.count;
}

// DEL.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.expandedIndexPaths containsObject:indexPath]) {
        
        FlippyCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        [cell animateClosed];
        [self.expandedIndexPaths removeObject:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    else {
        
        [self.expandedIndexPaths addObject:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        FlippyCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        [cell animateOpen];
        
    }
}


- (IBAction)addAction:(id)sender {
    
    if (self.isExtended == NO) {
    
        self.viewHeightConstraint.constant = 300;
//    self.buttonHeightConstraint.constant = 44;
        self.buttonBottomConstraint.constant = 236;
    
        self.itemTitle.hidden = NO;
        self.itemDescription.hidden = NO;
        self.saveButton.hidden = NO;
        
        self.isExtended = YES;
        
    } else {
        
        self.viewHeightConstraint.constant = 84;
        self.buttonBottomConstraint.constant = 20;
        
        self.itemTitle.hidden = YES;
        self.itemDescription.hidden = YES;
        self.saveButton.hidden = YES;
        
        self.isExtended = NO;
    }
}

- (void)addItem {
    
    if (![self.itemTitle.text  isEqual: @""] && ![self.itemDescription.text  isEqual: @""]) {
        
        [[ItemController sharedInstance]addItemWithTitle:self.itemTitle.text andText:self.itemDescription.text];
        
        [self.tableView reloadData];
        
    } else {
        
        //alert eventually
        
        NSLog(@"Please fill both text fields!");
    }
    
}

//add text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

//For testing

- (NSArray *)itemArray {
    
    if (!_itemArray) {
        
        _itemArray = [self.itemDescritions allKeys];
    }
    
    return _itemArray;
    
    
}

- (NSDictionary *)itemDescritions {
    
    if (!_itemDescritions) {
        
        _itemDescritions = @{@"Item one" : @"Desc. one", @"Item two" : @"Desc. two", @"Item three" : @"Desc. three", @"Item four" : @"Desc. four", @"Item five" : @"Desc. five"};
    }
    
    return _itemDescritions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
