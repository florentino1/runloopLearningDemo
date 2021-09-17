//
//  main.c
//  561数组拆分---贪心算法
//
//  Created by 莫玄 on 2021/8/9.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int cmp(const void*a,const void *b)
{
    return *(int *)a- *(int *)b;
}
int max_min(int *arr,int size)
{
    int sum=0;
    if(size==4)
        return arr[0]+arr[2];
    if(size==2)
        return arr[0];
    int *newArr=arr+2;
    int tmp=max_min(newArr,size-4);
    sum+=arr[0]+arr[size-2]+tmp;
    return sum;
}
int arrayPairSum(int* nums, int numsSize){
//试试看能不能用贪心算法的思想去处理一下；两两分成一组，每一组的最小值 进行求和使结果最大
//比较明显的信息是排序后的最小值nums[0]和次最大值nums[numsSize-2]必然出现在min的集合中才能使最终的min和最大；
//因为长度为2n，必为偶数，所以除去（0，1）与（2n-2，2n-1）这两组之外，其他的数可以看成一个新的排序好的2（n-2）的数组，再次计算
    if(numsSize%2==1)
        return 0;
    if(numsSize==2)
        return (nums[0]>nums[1])?nums[1]:nums[0];
    qsort(nums,numsSize,sizeof(int),cmp);
    int ans=max_min(nums,numsSize);
    return ans;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    int num[30]={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
    int ans=arrayPairSum(num, 30);
    printf("%d\n",ans);
    return 0;
}
