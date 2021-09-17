//
//  main.c
//  1005K次取反后的最大化数组和
//
//  Created by 莫玄 on 2021/8/7.
//

#include <stdio.h>
#include <stdlib.h>
int cmp(const void*a,const void*b)
{
    int i=*(int *)a;
    int j=*(int *)b;
    int m,n;
    m=(i>0)?i:-i;
    n=(j>0)?j:-j;
    return n-m;
}
int largestSumAfterKNegations(int* nums, int numsSize, int k){
    qsort(nums,numsSize,sizeof(int),cmp);//按绝对值的大小进行排序
    int sum=0;
    for(int i=0;i<numsSize && k>0;i++)
    {
        if(nums[i]<0)
        {
            k--;
            nums[i]*=-1;

        }
    }
    if(k%2==1 && k>0)
    {
        nums[numsSize-1]*=-1;
    }
    for(int i=0;i<numsSize;i++)
        sum+=nums[i];
    return sum;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    int nums[5]={1,2,3,-4,0};
    int ans=largestSumAfterKNegations(nums, 5, 3);
    printf("%d\n",ans);
    return 0;
}
