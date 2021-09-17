//
//  main.c
//  414第三大的数
//
//  Created by 莫玄 on 2021/8/6.
//

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

void cmp(int *a,int size)
{
    for(int i=1;i<size;i++)
    {
        int tmp=a[i];
        int j;
        for(j=i-1;j>=0;j--)
        {
            if(tmp<a[j])
                a[j+1]=a[j];
            else
                break;
        }
        a[j+1]=tmp;
    }
}
int cmp1(const void*a,const void*b)
{
    int i=*(int *)a;
    int j=*(int *)b;
    return (i>j)?1:-1;
}
int thirdMax(int* nums, int numsSize)
{
    if(numsSize<=2)
        return (nums[0]>nums[numsSize-1])?nums[0]:nums[numsSize-1];
    //cmp1(nums,numsSize);
    qsort(nums, numsSize, sizeof(int ), cmp1);
    int third=nums[numsSize-1];//从后往前进行挑选
    int second,first;
    int i;
    for(i=numsSize-2;i>=0;i--)
    {
        if(i==0)
            return third;
        else if(nums[i]==nums[i+1])
            continue;
        else
        {
            second=nums[i];
            break;
        }
    }
    for(int j=i-1;j>=0;j--)
       {
           if(j==0 && nums[j]==nums[j+1])
               return third;
           else if(j==0 && nums[j]!=nums[j+1])
               return nums[j];
           else if(nums[j]==nums[j+1])
               continue;
           else
               {
                   first=nums[j];
                   return first;
               }
     }
    return NULL;
}
int thirdMax1(int nums[], int numsSize){
//使用三指针的方式，直接寻找最大 第二大 第三大的值
if(numsSize<=2)
    return (nums[0]>nums[numsSize-1])?nums[0]:nums[numsSize-1];
    long first=LONG_MIN;
    long second=LONG_MIN;
    long third=LONG_MIN;
for(int i=0;i<numsSize;i++)
{
    if(nums[i]>third)
    {
        first=second;
        second=third;
        third=nums[i];
        continue;
    }
    else if(nums[i]==third)
        continue;
    else if(nums[i]>second)
    {
        first=second;
        second=nums[i];
        continue;
    }
    else if(nums[i]==second)
        continue;
    else if(nums[i]>first)
        {
            first=nums[i];
            continue;
        }
}
    return  (first==LONG_MIN)?(int)third:(int)first;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    int arr[3]={INT_MIN,1,1};
    int ans=thirdMax(arr, 3);
    printf("%d\n",ans);
    return 0;
}
