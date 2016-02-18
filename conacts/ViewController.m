//
//  ViewController.m
//  conacts
//
//  Created by JetFire on 16-2-16.
//  Copyright (c) 2016年 Jamy. All rights reserved.
//

#import "ViewController.h"

char* printEnv(void)
{
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"%s", env);
    return env;
}


BOOL isJailBreak(void)
{
    if (printEnv()) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(onButtonClearConactCLick) forControlEvents:UIControlEventTouchDown];
    [btn setTitle:@"清空通信录" forState:UIControlStateNormal];
        btn.tag = 10;
    btn.frame = CGRectMake(10, 50, 80, 40);
   //     btn.backgroundColor = [UIColor grayColor];
    [[self view] addSubview:btn];
    }
    
    {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn addTarget:self action:@selector(onButtonImportConactCLick) forControlEvents:UIControlEventTouchDown];
        [btn setTitle:@"添加通信录" forState:UIControlStateNormal];
        btn.tag = 11;
        btn.frame = CGRectMake(100, 50, 80, 40);
   //     btn.backgroundColor = [UIColor grayColor];
        [[self view] addSubview:btn];
    }
    
    {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn addTarget:self action:@selector(onButtonClearHistoryClick) forControlEvents:UIControlEventTouchDown];
        [btn setTitle:@"清空历史" forState:UIControlStateNormal];
        btn.tag = 12;
        btn.frame = CGRectMake(190, 50, 80, 40);
    //    btn.backgroundColor = [UIColor grayColor];
        [[self view] addSubview:btn];
    }
    
    
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(1.0, 90.0, 80, 40.0)];
        label.textAlignment = UITextAlignmentCenter;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        [label setText:@"个数"];
        
        label.textColor = [UIColor blueColor];
        [self.view addSubview:label];
        
        UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(70, 100, 50, 20)];
        field.borderStyle = UITextBorderStyleBezel;
        field.tag = 3;
        
        
        [field setText:@"300"];
        [self.view addSubview:field];
        
    }
    
    
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(120.0, 90.0, 80, 40.0)];
        label.textAlignment = UITextAlignmentCenter;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        [label setText:@"历史记录"];
        label.tag = 3;
        label.textColor = [UIColor blueColor];
        [self.view addSubview:label];
        
        UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(200, 100, 100, 20)];
        field.borderStyle = UITextBorderStyleBezel;
        field.tag = 4;
        
        NSString* content = [self readHistoryCount];
        [field setText:content];
        [self.view addSubview:field];
        
    }
    
    {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30.0, 150.0, 250.0, 40.0)];
        label.textAlignment = UITextAlignmentCenter;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        [label setText:@"test"];
        label.tag = 1;
      //  label.font = [UIFont fontWithName:@"Arial" size:30];
      //  label.backgroundColor = [UIColor grayColor];
        label.textColor = [UIColor blueColor];
        [self.view addSubview:label];
    }
    
    {
       BOOL isJail =  isJailBreak();
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30.0, 200.0, 280.0, 120.0)];
        label.textAlignment = UITextAlignmentCenter;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        
        if (!isJail){
        	label.textColor = [UIColor redColor];
        }
        
        NSString *msg = isJail ? @"您的机器已经越狱了" : @"您的机器未越狱";
        [label setText:msg];
        label.tag = 2;
        //  label.font = [UIFont fontWithName:@"Arial" size:30];
        //  label.backgroundColor = [UIColor grayColor];
        [self.view addSubview:label];
    }
    
    
      [self requestAddressBook];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) onButtonImportConactCLick{
    NSLog(@"onbtn1");
   
    
    [self importConactFromFile];
}


-(void) onButtonClearConactCLick{
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:10];
    [btn setEnabled:NO];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self removeAllConacts];
   
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"clear contact success");
            UILabel* label = (UILabel*) [self.view viewWithTag:1];
            [label setText:@"清空通信录成功！"];
            [btn setEnabled:YES];
        });
    });
}


-(void) onButtonClearHistoryClick{
    NSLog(@"onbtn3");
    UILabel* label = (UILabel*) [self.view viewWithTag:1];
    [label setText:@"history"];
    
    UITextField* history = (UITextField*) [self.view viewWithTag:4];
    [history setText:@"0"];
    [self saveHistoryCount:@"0"];
    [label setText:@"历史记录清除成功"];
}

-(void) removeAllConacts{
    //取得通讯录访问授权
    ABAuthorizationStatus authorization= ABAddressBookGetAuthorizationStatus();
    //如果未获得授权
    if (authorization!=kABAuthorizationStatusAuthorized) {
        NSLog(@"尚未获得通讯录访问授权！");
        return ;
    }
    
    
    //取得通讯录中所有人员记录
    CFArrayRef allPeople= ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    // self.allPerson=(__bridge NSMutableArray *)allPeople;
    NSArray* allPersonArray = [NSMutableArray array];
    allPersonArray = (__bridge NSMutableArray*)allPeople;
    //释放资源
    CFRelease(allPeople);
    
    
    //delete all
    int count = allPersonArray.count;
    for(int i = 0; i < count; ++i){
        ABRecordRef record = (__bridge ABRecordRef)allPersonArray[i];
        ABAddressBookRemoveRecord(self.addressBook, record , NULL);
    }
    
    ABAddressBookSave(self.addressBook, NULL);

}

-(void) requestAddressBook{

    self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    UILabel* label = (UILabel*) [self.view viewWithTag:1];
    
    
    //请求访问用户通讯录,注意无论成功与否block都会调用
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"未获得通讯录访问权限！");
            [label setText:@"未获得通讯录访问权限！"];
            label.backgroundColor = [UIColor redColor];
        }else{
             NSLog(@"获得通讯录访问权限！");
            [label setText:@"已经获得通讯录访问权限！"];
        }
    });
}

-(void) addPerson:(NSString*) phoneNumber
{
    //创建一条记录
    ABRecordRef recordRef= ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(phoneNumber), NULL);//添加名
    
    ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);//添加设置多值属性
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)(phoneNumber), kABWorkLabel, NULL);//添加工作电话
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    
    
    //添加记录
    ABAddressBookAddRecord(self.addressBook, recordRef, NULL);
    
    //释放资源
    CFRelease(recordRef);
    CFRelease(multiValueRef);
}

-(NSString*) getTargetDir{
    BOOL isJb = isJailBreak();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    
    NSString* targetDir = @"/var/mobile/Media/TouchSprite/lua";
    if (!isJb){
        targetDir = documentsDirectory;
    }

    return targetDir;
}

-(void) importConactFromFile{
    NSString* targetDir = [self getTargetDir];
    UILabel* info = (UILabel*) [self.view viewWithTag:2];
    [info setText:[NSString stringWithFormat:@"当前导入路径:%@",targetDir]];
    
     UILabel* label = (UILabel*) [self.view viewWithTag:1];
    
    NSString* history = [self readHistoryCount];
    int cnt = [history intValue];
    
    UITextField* lenTextField = (UITextField*) [self.view viewWithTag:3];
    NSString* len = [lenTextField text];
    int iLen = [len intValue];
    int maxLength = cnt + iLen;
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:11];
    [btn setEnabled:NO];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    const char* telphone = [[NSString stringWithFormat:@"%@/telphone.txt",targetDir] UTF8String];
        FILE* f = fopen(telphone, "r");
        if (!f){
           // [label setText:@"telphone.txt文件不存在"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [label setText:@"telphone.txt文件不存在"];
                [btn setEnabled:YES];
            });
            return;
        }
        
        char buf[1024] = {0};
        int i = 0;
        while(fgets(buf, 1024, f) != NULL && i < maxLength)
        {
            i++;
            if (i <= cnt) continue;
            int strLength = strlen(buf);
            if (buf[strLength - 1] == '\n') buf[strLength - 1] = 0;
            if (buf[strLength - 2] == '\r') buf[strLength - 2] = 0;
            
            NSString* phone = [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
            if ([phone isEqualToString:@""]) continue;
            
            [self addPerson:phone];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [label setText:[NSString stringWithFormat:@"正在添加:%@", phone]];
            });
            //   [label setText:[NSString stringWithFormat:@"正在添加:%@", phone]];
        }
        fclose(f);
        
        if (i >= cnt){
            ABAddressBookSave(self.addressBook, NULL);
            NSString* strCnt =[NSString stringWithFormat:@"%d", i];
            [self saveHistoryCount:strCnt];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UITextField* historyTextField = (UITextField*) [self.view viewWithTag:4];
                [historyTextField setText:strCnt];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* msg = [NSString stringWithFormat:@"导入成功:%d", i - cnt];
             [label setText:msg];
            [btn setEnabled:YES];
        });
    });
    
    //UITextField* historyTextField = (UITextField*) [self.view viewWithTag:4];
   // [historyTextField setText:strCnt];
    
   // NSString* msg = [NSString stringWithFormat:@"导入成功:%d", i - cnt];
   // [label setText:msg];
}

-(NSString*) readHistoryCount{
    NSString* targetDir = [self getTargetDir];
    NSString* historyFile = [targetDir stringByAppendingString:@"/saveCount.txt"];
    NSString* content = [NSString stringWithContentsOfFile:historyFile encoding:NSUTF8StringEncoding error:nil];
    if (!content){
        content = @"0";
    }
    return content;
}

-(BOOL) saveHistoryCount:(NSString*) content
{
    NSString* targetDir = [self getTargetDir];
    NSString* historyFile = [targetDir stringByAppendingString:@"/saveCount.txt"];
    BOOL res = [content writeToFile:historyFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return res;
}


@end
