//
//  UIPostInforViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-14.
//
//

#import "UIBaoLiaoPostInforViewController.h"
#import "HttpRequestFile.h"
#import "ASIFormDataRequest.h"

@interface UIBaoLiaoPostInforViewController ()
{
    UITextField * nameField;
    UITextField * phoneField;
    UITextField * titleField;
    UITextView * contentText;
    UIScrollView * backGroundScrollview;
    UILabel * bgLabel ;
    TYHttpRequest * httpRequest;
    UIButton * buttonPic;
    UIImage * selfPhoto;
    
    NSString * photoUrl;
}

@end

@implementation UIBaoLiaoPostInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavCustom * custom = [[NavCustom alloc] init];
    [custom setNavWithText:@"我要报料" mySelf:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    backGroundScrollview= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backGroundScrollview.delegate =self;
    [self.view addSubview:backGroundScrollview];
    
//    backGroundScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    
    //加载视图
    [self loadLayoutView];
    
    // Do any additional setup after loading the view.
}

-(void)loadLayoutView
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 20)];
    titleLabel.text = @"姓名: *";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:titleLabel];
    
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLabel.frame.size.height+titleLabel.frame.origin.y+10, self.view.frame.size.width-150, 40)];
    [view setImage:[UIImage imageNamed:@"bg1.png"]];
    [backGroundScrollview addSubview:view];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLabel.frame.size.height+titleLabel.frame.origin.y+15, self.view.frame.size.width-160, 30)];
    nameField.placeholder = @"请输入您的姓名";
    nameField.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:nameField];
    
    UILabel * titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, nameField.frame.size.height+nameField.frame.origin.y+10, 200, 20)];
    titleLabel2.text = @"电话: *";
    titleLabel2.textColor = [UIColor blackColor];
    titleLabel2.backgroundColor = [UIColor clearColor];
    titleLabel2.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:titleLabel2];
    
    UIImageView * view2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLabel2.frame.size.height+titleLabel2.frame.origin.y+10, self.view.frame.size.width-30, 40)];
    [view2 setImage:[UIImage imageNamed:@"bg1.png"]];
    [backGroundScrollview addSubview:view2];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLabel2.frame.size.height+titleLabel2.frame.origin.y+15, self.view.frame.size.width-40, 30)];
    phoneField.placeholder = @"请输入您的联系方式";
    phoneField.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:phoneField];
    
    UILabel * titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(15, phoneField.frame.size.height+phoneField.frame.origin.y+10, 200, 20)];
    titleLabel3.text = @"爆料标题: *";
    titleLabel3.textColor = [UIColor blackColor];
    titleLabel3.backgroundColor = [UIColor clearColor];
    titleLabel3.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:titleLabel3];
    
    UIImageView * view3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLabel3.frame.size.height+titleLabel3.frame.origin.y+10, self.view.frame.size.width-30, 40)];
    [view3 setImage:[UIImage imageNamed:@"bg1.png"]];
    [backGroundScrollview addSubview:view3];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLabel3.frame.size.height+titleLabel3.frame.origin.y+15, self.view.frame.size.width-40, 30)];
    titleField.placeholder = @"请输入您的爆料标题";
    titleField.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:titleField];
    
    
    UILabel * titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(15, titleField.frame.size.height+titleField.frame.origin.y+10, 200, 20)];
    titleLabel4.text = @"爆料标题: *";
    titleLabel4.textColor = [UIColor blackColor];
    titleLabel4.backgroundColor = [UIColor clearColor];
    titleLabel4.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:titleLabel4];
    
    UIImageView * view4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLabel4.frame.size.height+titleLabel4.frame.origin.y+15, self.view.frame.size.width-30, 160)];
    [view4 setImage:[UIImage imageNamed:@"bg2.png"]];
    [backGroundScrollview addSubview:view4];
    
    contentText = [[UITextView alloc] initWithFrame:CGRectMake(20, titleLabel4.frame.size.height+titleLabel4.frame.origin.y+20, self.view.frame.size.width-40, 150)];
    contentText.backgroundColor = [UIColor clearColor];
    contentText.delegate =self;
    [backGroundScrollview addSubview:contentText];
    
    bgLabel= [[UILabel alloc] initWithFrame:CGRectMake(25, view4.frame.origin.y+10, 80, 20)];
    bgLabel.text = @"爆料内容";
    bgLabel.textColor = [UIColor grayColor];
    bgLabel.backgroundColor = [UIColor clearColor];
    bgLabel.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:bgLabel];
    
    buttonPic = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPic.frame = CGRectMake(self.view.frame.size.width-100, 30 , 70, 70);
    [buttonPic addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonPic setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    buttonPic.tag = 101;
    [backGroundScrollview addSubview:buttonPic];
    
    UIButton * baoliao = [UIButton buttonWithType:UIButtonTypeCustom];
    baoliao.frame = CGRectMake(self.view.frame.size.width-150, contentText.frame.size.height+contentText.frame.origin.y+20, 120,35);
    [baoliao addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [baoliao setBackgroundImage:[UIImage imageNamed:@"baoliao"] forState:UIControlStateNormal];
    baoliao.tag = 102;
    [backGroundScrollview addSubview:baoliao];
    
    if(baoliao.frame.size.height+baoliao.frame.origin.y < self.view.frame.size.height)
    {
        backGroundScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    }
    else
    {
        backGroundScrollview.contentSize = CGSizeMake(self.view.frame.size.width, baoliao.frame.size.height+baoliao.frame.origin.y+1+84);
    }
}


-(void)onClick:(id)sender
{
    UIButton * button = (UIButton*)sender;
    switch (button.tag) {
        case 101:
        {
            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                            initWithTitle:nil
                                            delegate:self
                                            cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
            [myActionSheet showInView:self.view];
        }
        break;
        case 102:
        {
            if([contentText.text length] == 0 || [titleField.text length] == 0 || [phoneField.text length] ==0 || [nameField.text length] ==0)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"* 表示不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                ASIFormDataRequest *requestPhoto = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://123.57.17.124/epaper/index.php?r=bl/create"]];
                
                [requestPhoto setPostValue:nameField.text forKey:@"name"];
                [requestPhoto setPostValue:phoneField.text forKey:@"phone"];
                [requestPhoto setPostValue:titleField.text forKey:@"title"];
                [requestPhoto setPostValue:contentText.text forKey:@"content"];
                
                [requestPhoto setFile:photoUrl forKey:@"img"];
                
                [requestPhoto buildPostBody];
                
                [requestPhoto setDelegate:self];
                
                [requestPhoto setTimeOutSeconds:20];
                
                [requestPhoto startAsynchronous];

            }
            
        }
            break;
        default:
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}
//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
        [[NSUserDefaults standardUserDefaults] setObject:imageFilePath forKey:@"imageFilePath"];
        
        success = [fileManager fileExistsAtPath:imageFilePath];
        if(success) {
            success = [fileManager removeItemAtPath:imageFilePath error:&error];
        }
        
        photoUrl = imageFilePath;
        
        UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
        [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
        selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
        
        [buttonPic setBackgroundImage:selfPhoto forState:UIControlStateNormal];
        
        
//        NSData *imageData = UIImageJPEGRepresentation(selfPhoto,0.8);
//        FileDetail *file = [FileDetail fileWithName:@"selfPhoto.jpg" data:imageData];
//        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:nameField.text,@"name",phoneField.text,@"phone",titleField.text,@"title",contentText.text,@"content",
//                                file,@"img",nil];
//        
//        NSLog(@"%@",params);
//        NSDictionary *result = [HttpRequestFile upload:@"http://123.57.17.124/epaper/index.php?r=bl/create" widthParams:params];
//        NSLog(@"%@",result);
        
    }];
   
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString = [request responseString];
    
    NSLog(@"%@",responseString);
    if([responseString isEqualToString:@"1"])
    {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"报料成功，等待审核...";
        
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        
        
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];

    }
    else
    {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"上传失败，请重试...";
        
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        
        
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];

    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
    indicator.labelText = @"上传失败，请重试...";
    
    indicator.mode = MBProgressHUDModeText;
    [window addSubview:indicator];
    
    
    [indicator showAnimated:YES whileExecutingBlock:^{
        sleep(1.2);
    } completionBlock:^{
        [indicator removeFromSuperview];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];

}


// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect yy = backGroundScrollview.frame;
    yy.origin.y = -150;
    backGroundScrollview.frame = yy;
    
    bgLabel.hidden =YES;
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    CGRect yy = backGroundScrollview.frame;
    yy.origin.y = 0;
    backGroundScrollview.frame = yy;
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
