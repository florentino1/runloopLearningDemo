//
//  main.m
//  29 两数相除
//
//  Created by 莫玄 on 2021/10/12.
//

#import <Foundation/Foundation.h>
int diviation(int a,int b)
{
    //递归出口
    if(a>b) return 0;
    //此处的a，b均为负数,且a<b
    int ans=1;
    int tmp=b;
    //循环找到比a的一半略大或是相等的b*n的n；
    while(INT_MIN-tmp<=tmp && tmp+tmp>a)
    {
        ans=ans+ans;
        tmp=tmp+tmp;
    }
    //此处需要进行递归调用，而不能直接返回ans*2或是ans*2-1；
    return ans+diviation(a-tmp,b);
}
int divide(int dividend, int divisor){
    if(dividend==0) return 0;
    else if(divisor==1) return dividend;
    else if(divisor==-1) return dividend==INT_MIN ? INT_MAX : -dividend; // 讨论边界条件
    int flag=0;
    if((dividend>0 && divisor<0) ||(dividend<0 && divisor >0))    //确认最终结果的正负号
        flag=1;
    
    //转化为两个负数进行计算
    //int a=(dividend<0) ? dividend : -dividend;
    int a,b;
    if(dividend<0) a=dividend;
    else a=-dividend;
    //int b=(divisor<0 )? divisor :-divisor;
    if(divisor<0) b=divisor;
    else b=-divisor;
    int ans=diviation(a,b);
    if(flag) return -ans;
    return ans;
}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        int ans=divide(-2147483648,2);
        NSLog(@"%d",ans);
    }
    return 0;
}
