//
//  VerticalTableViewViewController.m
//  VerticalTableView
//
//  Created by Ryan Wang on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VerticalTableViewViewController.h"
#import "RWVerticalTableView.h"

@implementation VerticalTableViewViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    RWVerticalTableView *tableView = [[RWVerticalTableView alloc] initWithFrame:CGRectMake(10, 19, 300, 50)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(RWVerticalTableView *)tableView {
    return 1;
}

- (NSInteger)verticalTableView:(RWVerticalTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20000;
}

- (CGFloat)tableView:(RWVerticalTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 3 == 0) {
        return 100;
    } else if (indexPath.row % 3== 1) {
        return 150;
    } else {
        return 200;        
    }
    
}

- (UITableViewCell *)verticalTableView:(RWVerticalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    RWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NIF_TRACE(@"dequeue : %@", cell);
    if (cell == nil) {
        cell = [[[RWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        NIF_TRACE(@"alloc new : %@", cell);
    }
    
    if (indexPath.row % 3 == 0) {
        cell.backgroundColor = [UIColor redColor];
    } else if (indexPath.row % 3== 1) {
        cell.backgroundColor = [UIColor greenColor];
    } else {
        cell.backgroundColor = [UIColor blueColor];
    }
    

        
//    cell.backgroundColor = [UIColor redColor];
    NSLog(@"%d %d",indexPath.section,indexPath.row);
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    // Configure the cell...
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
