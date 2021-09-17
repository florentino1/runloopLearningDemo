//
//  main.c
//  钢条切割问题
//
//  Created by 莫玄 on 2021/8/7.
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#pragma mark-普通的递归调用求解
int cut(int *p,int n)
{
    //p是钢条长度对应价格的数组，n是钢条的长度
    if(n==0)
        return 0;
    int price=-1;
    for (int i=1; i<=n; i++) {//1<= i <=n
        int tmp=cut(p, n-i)+p[i];//递归调用求解n-1长的钢条的价格;
        price=(price>tmp)?price:tmp;
    }
    return price;
}

#pragma mark--自顶向下的动态规划求解---构建辅助数组保存中间值
int memocut_dp(int *p,int n,int *r)
{
    if(n==0)
        return 0;
    if(r[n]>0)
        return r[n];//表示n长度的钢条最优收益已知，直接返回即可
    int price=-1;
    for(int i=1;i<=n;i++)
    {
        int tmp=p[i]+memocut_dp(p, n-i, r);
        price=(price>tmp)?price:tmp;
    }
    r[n]=price;//更新辅助数组的值，表示n长度的钢条最佳收益已知；
    return price;//返回结果值到求解price值的计算中完成递归计算；
}
int memocut_main(int *p,int n)
{
    int *r=(int *)malloc((n+1)*sizeof(int));//数组的大小为n+1;
    memset(r,-1,(n+1)*sizeof(int));//新建一个辅助的数组r用于保存递归调用过程中产生的中间值以避免重复计算相同的量；
    int res=memocut_dp(p, n, r);
    return res;
}

#pragma mark--自低向上的动态规划求解---不使用递归调用，求解一个子问题前必须保证其之前的子问题已被求解
int cut_dp(int *p,int n)
{
    int *r=(int *)calloc(n, sizeof(int));
    r[0]=0;
    for(int i=1;i<=n;i++)//想要求解每一个r【i】；
    {
        int price=-1;
        for(int j=1;j<=i;j++)//想要求解每一个r[i]，先要了解r[j]和r[i-j]的值
        {
            int tmp=p[j]+r[i-j];//由于p是类似于散列表的形式，所有可能部分p[j]==0，此时考量r[i-j]，因为i-j总小于i，所以r[i-j]必然是已知的值；
            price=(price>tmp)?price:tmp;
        }
        r[i]=price;
    }
    return r[n];
}
int main(int argc, const char * argv[]) {
    // insert code here...
    int p[11]={0,1,5,8,9,10,17,17,20,24,30};
    int ans=memocut_main(p, 4);
    printf("%d\n",ans);
    return 0;
}

