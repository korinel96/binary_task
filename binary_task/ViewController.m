//
//  ViewController.m
//  binary_task
//
//  Created by Ким Виталий on 03.02.16.
//  Copyright © 2016 korinel. All rights reserved.
//

#import "ViewController.h"
#import "CoreTelephony/CTCall.h"

@interface ViewController ()

@end


@implementation ViewController
{
    NSMutableArray* users;
    NSMutableArray* info;
    NSMutableArray* n_cells;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.popup.layer.cornerRadius = 5;
    self.popup.layer.shadowOpacity = 0.8;
    self.popup.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.popup.alpha = 0;
    NSString *hey = @"hello world"; // не люблю я lowercase, но ТЗ -_-
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *uuid = [identifierForVendor UUIDString];
    NSLog(@"%@", uuid);
//post-request
    NSString *post = [NSString stringWithFormat:@"upload[imei]=%@&upload[message]=%@",uuid,hey];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://test.binaryblitz.ru/uploads"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
//end
}


- (void)showAnimate
{
    self.popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.popup.alpha = 1;
    [UIView animateWithDuration:.25 animations:^{
        self.popup.alpha = 1;
        self.popup.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.popup.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.popup.alpha = 0.0;
    }];
}

- (IBAction)fetch:(id)sender {
    //парсим инфу а пользователях
    NSString *url1 = [NSString stringWithFormat:@"http://test.binaryblitz.ru/users.json"];
    NSURL *usersjson=[NSURL URLWithString:[url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData* data = [NSData dataWithContentsOfURL: usersjson];
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    users = json;
    //Заполняем таблицу инфой
    [mytable reloadData];
}

- (IBAction)detail:(id)sender{
    NSIndexPath *path = [mytable indexPathForSelectedRow];
    NSLog(@"%@", users[path.row][@"id"]);
    //ну а тут парсим доп инфу
    NSString *url1 = [NSString stringWithFormat:@"http://test.binaryblitz.ru/users/%@.json", users[path.row][@"id"]];
    NSURL *usersjson=[NSURL URLWithString:[url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData* data = [NSData dataWithContentsOfURL: usersjson];
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    info = [json objectForKey:@"info"];
    addinfo.text = [NSString stringWithFormat:@"Additional Information: %@", info];
    [self showAnimate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (users != nil)
        return [users count];
    else
        return 0;
}
- (IBAction)close:(id)sender {
    [self removeAnimate];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* n_cells = [[NSMutableArray alloc] init];
    int length = (sizeof(users) - 3); //wtf with this length?
    for(int i = 0; i < length; i++)
    {   //проставляем нормально Имя+Фамилия
        [n_cells addObject: [NSString stringWithFormat:@"%@ %@", users[i][@"name"],users[i][@"surname"]]];
    }
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [n_cells objectAtIndex:indexPath.row]; // заполняем табличку
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
