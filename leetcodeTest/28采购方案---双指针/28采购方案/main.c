//
//  main.c
//  28采购方案
//
//  Created by 莫玄 on 2021/8/13.
//

#include <stdio.h>
#include <stdlib.h>
int cmp(const void*a,const void*b)
{
    return *(int *)a- *(int *)b;
}
//超出时间限制
/*
int binarySearch(int *arr,int size,int index,int n)
{
    int low=index;
    int high=size-1;
    while(low<=high)
    {
        int mid=(low+high)/2;
        if(arr[mid]>n)
            high=mid-1;
        else if(arr[mid]<n)
            low=mid+1;
        else//如果相等时，需要找到序号最大的那一个相等数；
        {
            while(mid<=size-2 && arr[mid+1]==n)
                mid=mid+1;
            return mid-index+1;
        }
    }
    return high-index+1;
}
int purchasePlans(int* nums, int numsSize, int target){
    qsort(nums,numsSize,sizeof(int),cmp);
    long ans=0;
    for(int i=0;i<numsSize-1;i++)
    {
        int tmp=target-nums[i];
        if(tmp<0)
            continue;
        int index=binarySearch(nums,numsSize,i+1,tmp);
        ans+=index;
    }
    return (int)(ans%1000000007);
}
*/
//正确解法：双指针
int purchasePlans(int* nums, int numsSize, int target)
{
    qsort(nums,numsSize,sizeof(int),cmp);
    int left=0;
    int right=numsSize-1;
    long ans=0;
    while(left<right)
    {
        if(nums[left]+nums[right]>target)
            right--;
        else
        {
            ans+=right-left;
            left++;
        }
    }
    return (int)(ans%1000000007);
}
int main(int argc, const char * argv[]) {
    // insert code here...
    int n[4]={2,5,3,5};
    int ans=purchasePlans(n, 4, 6);
    printf("%d\n",ans);
    return 0;
}
