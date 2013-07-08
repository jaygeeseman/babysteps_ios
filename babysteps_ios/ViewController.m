//
//  ViewController.m
//  babysteps_ios
//
//  Created by Jay Geeseman on 7/8/13.
//  Copyright (c) 2013 Jay Geeseman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
- (IBAction)createAccount:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createAccount:(id)sender {
    // Get username entered in the text field
    NSString *usernameString = self.usernameField.text;
    
    // Live status
    self.resultLabel.text = [[NSString alloc] initWithFormat:@"Trying to create new account for %@...", usernameString];

    // Build the JSON POST data
    NSString *postData = @"{\"username\":\"ffff\",\"device_id\":\"device_id\",\"device_type\":\"device_type\"}";
    
    // Asynchronously submit the POST request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:@"http://localhost:9000/users"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
        self.resultLabel.text = @"A connection could not be created.";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.usernameField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}


// The connection methods below are used to asynchronously handle the web server response.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it has enough information to create the NSURLResponse.
    // It can be called multiple times, for example in the case of a redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // receivedData is declared as a method instance elsewhere
    [self.receivedData setLength:0];
    
    // inform the user
    self.resultLabel.text = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@",
                             [error localizedDescription],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    self.resultLabel.text = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
}
@end
