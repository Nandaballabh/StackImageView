StackImageView
==============

iOS library for stack image scroll view cool animation.
 
 Integration Steps: 
==============
 
 
 1.clone the library and add into project 
 
 2. Add imageview as bellow :
   

    CGRect rect = {{20,40},{260,340}};


    NBStackScrollImageView *stackView = [[NBStackScrollImageView alloc]initWithFrame:rect ZMarginValue:5 XMarginValue:10 AngleValue:0.0 Alpha:1000];


    stackView.stackPostion = StackPositionRight;
    
    stackView.borderColor = [UIColor whiteColor];
    
    stackView.delegate = self;
    
    for (int index = 0; index < 6; index++) {
        [stackView addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index]]];
    }
    
    [self.view addSubview:stackView];
    
    [stackView setImageShadowsWtihDirectionX:2 Y:2 Alpha:0.7];
    
    [stackView reLoadUIview];


