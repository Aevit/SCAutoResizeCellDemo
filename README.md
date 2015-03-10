# SCAutoResizeCellDemo

> use autolayout on the tableview 
> 在tableview在使用autolayout，自适应cell的高度（iOS7+）

##一、概述
####1、声明`NSDictinary *offscreenCell`

> a. 用来存储每种类型cell的一个对象实例
> b. 此`dictionary`的`key`为每种类型cell的`reuse identifier`，`value`为该类型cell的一个对象实例

<br />

####2、cell的注册

> a. 使用`tableview`的`registerClass`方法来进行cell的注册
> b. 若有多种类型的cell，则要用`registerClass`注册多个cell

<br />

####3、初始化cell，并返回cell高度  

> a. 在`heightForRowAtIndexPath`方法里，进行cell的初始化
> b. 使用`systemLayoutSizeFittingSize`方法获取cell的高度

<br />

####4、cell赋值

> 在`cellForRowAtIndexPath`方法里，进行cell的赋值

<br />

####5、使用`autolayout`对需要的控件进行布局  

> 有两种方式：  
> a. 使用xib  
> b. 重写自定义cell类里的`updateConstraints`方法，手动用代码进行布局

注：本文使用[Masonry](https://github.com/Masonry/Masonry)进行布局  

<br />
    
####6、通知系统进行布局

> 在自定义的cell类里的`layoutSubviews`方法，调用相关方法通知系统进行布局

<br />


##二、关键点  
1、autolayout要设置正确，如果不正确，`systemLayoutSizeFittingSize`方法计算出来的高度是0

##三、示例代码

> 假设有两种类型的cell，先自定义两个cell类
> 分别命名为`AutoResizeCell` `SecondResizeCell`
> `reuse identify`分别为`autoResizeCellId` `secondResizeCellId`

<br />

1、在`controller`里的`viewDidLoad`

```
/////////////// step: 1 ///////////////
self.offscreenCell = [NSMutableDictionary dictionary];
/////////////// step: 1 ///////////////

/////////////// step: 2 ///////////////
[self.myTableView registerClass:[AutoResizeCell class] forCellReuseIdentifier:autoResizeCellId];
[self.myTableView registerClass:[SecondResizeCell class] forCellReuseIdentifier:secondResizeCellId];
// Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
// it will only be called as cells are about to scroll onscreen. This is a major performance optimization.self.myTableView.estimatedRowHeight = UITableViewAutomaticDimension; // iOS7+
/////////////// step: 2 ///////////////
```

<br />

2、在`controller`里的`heightForRowAtIndexPath`  

```
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /////////////// step: 3 ///////////////
    NSDictionary *aDict = [self getRowDataDictInSection:indexPath.section row:indexPath.row];
    BOOL hasAvatar = [[aDict objectForKey:HAS_AVATAR] boolValue];
    NSString *reuseIdentifier = (hasAvatar ? secondResizeCellId : autoResizeCellId);
    UITableViewCell *cell = [self.offscreenCell objectForKey:reuseIdentifier];
    if (!cell) {
        if (hasAvatar) {
            cell = [[SecondResizeCell alloc] init];
        } else {
            cell = [[AutoResizeCell alloc] init];
        }
        [self.offscreenCell setObject:cell forKey:reuseIdentifier];
    }
    if (hasAvatar) {
        [(SecondResizeCell*)cell initModel:aDict];
    } else {
        [(AutoResizeCell*)cell initModel:aDict];
    }
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    /////////////// step: 3 ///////////////
    
    return height;
}
```

<br />

3、在`controller`里的`cellForRowAtIndexPath`

```
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /////////////// step: 4 ///////////////
    NSDictionary *aDict = [self getRowDataDictInSection:indexPath.section row:indexPath.row];
    BOOL hasAvatar = [[aDict objectForKey:HAS_AVATAR] boolValue];
    NSString *reuseIdentifier = (hasAvatar ? secondResizeCellId : autoResizeCellId);
    AutoResizeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (hasAvatar) {
        [(SecondResizeCell*)cell initModel:aDict];
    } else {
        [(AutoResizeCell*)cell initModel:aDict];
    }
    /////////////// step: 4 ///////////////
    return cell;
}
```

<br />

4、在自定义cell类的`initModel`

```
- (void)initModel:(id)model {
    
    self.titleLabel.text = [model objectForKey:@"title"];
    self.bodyLabel.text = [model objectForKey:@"content"];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    /////////////// step: 4 ///////////////
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    /////////////// step: 4 ///////////////
}
```

<br />

5、在自定义cell类的`updateConstraints`

```
- (void)updateConstraints {
    
    /////////////// step: 5 ///////////////
    if (!self.didSetupConstraints) {
        
        // titleLabel
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kLabelVerticalInsets);
            make.left.mas_equalTo(kLabelHorizontalInsets);
            make.right.mas_equalTo(-kLabelHorizontalInsets); // need
        }];
        // bodyLabel
        [_bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(kLabelVerticalInsets);
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.bottom.mas_equalTo(-kLabelVerticalInsets); // need
            make.right.mas_equalTo(_titleLabel.mas_right);
        }];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
    /////////////// step: 5 ///////////////
}
```

<br />

6、在自定义cell类的`layoutSubviews`

```
- (void)layoutSubviews {
    [super layoutSubviews];
    
    /////////////// step: 6 ///////////////
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(_titleLabel.frame);
    _bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(_bodyLabel.frame);
    /////////////// step: 6 ///////////////
}
```

<br />

##四、autolayout相关资料

1）开始iOS 7中自动布局教程（上下部分）  
    1、http://www.cocoachina.com/industry/20131203/7462.html
    2、http://www.cnblogs.com/zer0Black/p/3977288.html


2）Masonry说明：
官方：https://github.com/Masonry/Masonry
第三方：http://adad184.com/2014/09/28/use-masonry-to-quick-solve-autolayout/


3）tableview动态计算cell高度
1、 http://www.ifun.cc/blog/2014/02/21/dong-tai-ji-suan-uitableviewcellgao-du-xiang-jie/
2、http://www.devdiv.com/autolayout_uitableviewcell_-blog-21666-52543.html
3、http://www.tuicool.com/articles/FZN3q2
4、http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights


<br />



    
















