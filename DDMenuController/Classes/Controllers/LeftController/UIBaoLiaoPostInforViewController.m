//
//  UIPostInforViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-14.
//
//

#import "UIBaoLiaoPostInforViewController.h"

@interface UIBaoLiaoPostInforViewController ()
{
    UITextField * titleField;
    UITextView * contentText;
    UIScrollView * backGroundScrollview;
    UILabel * bgLabel ;
    TYHttpRequest * httpRequest;
}

@end

@implementation UIBaoLiaoPostInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavCustom * custom = [[NavCustom alloc] init];
    [custom setNavWithText:@"我要爆料" mySelf:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    backGroundScrollview= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backGroundScrollview.delegate =self;
    [self.view addSubview:backGroundScrollview];
    
    backGroundScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    
    //加载视图
    [self loadLayoutView];
    
    // Do any additional setup after loading the view.
}

-(void)loadLayoutView
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 20)];
    titleLabel.text = @"爆料标题";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:titleLabel];
    
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLabel.frame.size.height+titleLabel.frame.origin.y+15, self.view.frame.size.width-30, 50)];
    [view setImage:[UIImage imageNamed:@"bg1.png"]];
    [backGroundScrollview addSubview:view];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLabel.frame.size.height+titleLabel.frame.origin.y+20, self.view.frame.size.width-40, 40)];
    titleField.placeholder = @"请输入您的爆料标题";
    titleField.backgroundColor = [UIColor clearColor];
    [backGroundScrollview addSubview:titleField];
    
    UIImageView * view2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleField.frame.size.height+titleField.frame.origin.y+15, self.view.frame.size.width-30, 160)];
    [view2 setImage:[UIImage imageNamed:@"bg2.png"]];
    [backGroundScrollview addSubview:view2];
    
    contentText = [[UITextView alloc] initWithFrame:CGRectMake(20, titleField.frame.size.height+titleField.frame.origin.y+20, self.view.frame.size.width-40, 150)];
    contentText.backgroundColor = [UIColor clearColor];
    contentText.delegate =self;
    [backGroundScrollview addSubview:contentText];
    
    bgLabel= [[UILabel alloc] initWithFrame:CGRectMake(25, titleField.frame.size.height+titleField.frame.origin.y+25, 80, 20)];
    bgLabel.text = @"爆料内容";
    bgLabel.textColor = [UIColor grayColor];
    bgLabel.backgroundColor = [UIColor clearColor];
    bgLabel.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:bgLabel];
    
    UIButton * pic = [UIButton buttonWithType:UIButtonTypeCustom];
    pic.frame = CGRectMake(20, contentText.frame.size.height+contentText.frame.origin.y+30 , 50, 50);
    [pic addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [pic setBackgroundImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    pic.tag = 101;
    [backGroundScrollview addSubview:pic];
    
    UIButton * baoliao = [UIButton buttonWithType:UIButtonTypeCustom];
    baoliao.frame = CGRectMake(self.view.frame.size.width-150, contentText.frame.size.height+contentText.frame.origin.y+30, 120,35);
    [baoliao addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [baoliao setBackgroundImage:[UIImage imageNamed:@"baoliao"] forState:UIControlStateNormal];
    baoliao.tag = 102;
    [backGroundScrollview addSubview:baoliao];
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
            if([contentText.text length] == 0 || [titleField.text length] == 0)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"标题或者内容不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                httpRequest = [[TYHttpRequest alloc] init];
                NSDictionary * dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"太原市",contentText.text,titleField.text, nil] forKeys:[NSArray arrayWithObjects:@"author",@"Content",@"Title", nil]];
                [httpRequest httpRequest:@"bl/create" parameter:dic Success:^(id result) {
                    
                    NSLog(@"%@",result);
                    
                    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                    indicator.labelText = @"爆料成功，等待审核...";
                    
                    indicator.mode = MBProgressHUDModeText;
                    [window addSubview:indicator];
                    
                    
                    [indicator showAnimated:YES whileExecutingBlock:^{
                        sleep(1.2);
                    } completionBlock:^{
                        [indicator removeFromSuperview];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];

                    
                } Failure:^(NSError *error) {
                    NSLog(@"%@",error);
                    
                } view:self.view isPost:YES];
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
        
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    bgLabel.hidden =YES;
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
