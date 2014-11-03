//
//  TYRightMenuFontViewController.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYRightMenuFontViewController.h"
#import "TYFontCell.h"

@interface TYRightMenuFontViewController ()
{
    NSString * oldDataSV;
    NSArray * dataArr;
    NSMutableDictionary * dic;
    NSInteger indexButton;
}

@end

@implementation TYRightMenuFontViewController

-(void)getModifyData:(void (^)(NSString *))data
{
    _myBack = data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavCustom * cus = [[NavCustom alloc] init];
    [cus setNavWithText:@"字体" mySelf:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _table.delegate =self;
    _table.dataSource= self;
    _table.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_table];
    
    dic = [[NSMutableDictionary alloc] init];
    dataArr = [NSArray arrayWithObjects:@"超大字体",@"大字体",@"中字体",@"小字体", nil];
    
    [self setLeftItem];
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"font"])
    {
        if([dataArr indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"font"]] == NSNotFound)
        {
            
        }
        else
        {
            NSInteger index =[dataArr indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"font"]];
            [dic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",index+1]];
            indexButton = index;

        }
        
    }
    else
    {
        NSInteger index =[dataArr indexOfObject:@"中字体"];
        [dic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",index+1]];
        indexButton = index;
    }
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID =@"cell";
    TYFontCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[TYFontCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    cell.font.text = [dataArr objectAtIndex:indexPath.row];
    
    if([[dic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]] isEqualToString:@"ok"])
    {
        [cell.selectbBtton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];

    }
    else
    {
        [cell.selectbBtton setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];

    }
    
    cell.selectbBtton.tag = indexPath.row+1;
    [cell.selectbBtton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)onClick:(id)sender
{
    UIButton * button = (UIButton*)sender;
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:button.tag-1 inSection:0];
    TYFontCell * cell = (TYFontCell*)[_table cellForRowAtIndexPath:index];
    
    if([[dic objectForKey:[NSString stringWithFormat:@"%d",button.tag]] isEqualToString:@"ok"])
    {
        
    }
    else
    {
        [cell.selectbBtton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [dic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",button.tag]];
        
        NSIndexPath * index2 = [NSIndexPath indexPathForRow:indexButton inSection:0];
        TYFontCell * cell2 = (TYFontCell*)[_table cellForRowAtIndexPath:index2];
        [cell2.selectbBtton setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
        [dic setObject:@"no" forKey:[NSString stringWithFormat:@"%d",indexButton+1]];
    }
    indexButton = button.tag-1;

}

-(void) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back.png"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYFontCell * cell = (TYFontCell*)[_table cellForRowAtIndexPath:indexPath];
    
    if([[dic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]] isEqualToString:@"ok"])
    {
        
    }
    else
    {
        [cell.selectbBtton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [dic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        
        NSIndexPath * index2 = [NSIndexPath indexPathForRow:indexButton inSection:0];
        TYFontCell * cell2 = (TYFontCell*)[_table cellForRowAtIndexPath:index2];
        [cell2.selectbBtton setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
        [dic setObject:@"no" forKey:[NSString stringWithFormat:@"%d",indexButton+1]];
    }
    indexButton = indexPath.row;

}

-(void)popself
{
    NSLog(@"%@",[dataArr objectAtIndex:indexButton]);
    _myBack([dataArr objectAtIndex:indexButton]);
    
    [[NSUserDefaults standardUserDefaults] setObject:[dataArr objectAtIndex:indexButton] forKey:@"font"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
