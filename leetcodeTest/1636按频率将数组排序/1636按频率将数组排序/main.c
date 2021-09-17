//
//  main.c
//  1636按频率将数组排序
//
//  Created by 莫玄 on 2021/8/6.
//

#include <stdio.h>
#include <stdlib.h>
int cmp(const void*a,const void*b)
{
    return *(int *)a - *(int *)b;
}
int cmp1(const void*a,const void*b)
{
    int *i=*(int **)a;
    int *j=*(int **)b;
    if(i[1]==j[1] && i[0]<j[0])
        return j[0]-i[0];
    return i[1]-j[1];

}
int* frequencySort(int* nums, int numsSize/*,int* returnSize*/){
    if(numsSize==1)
        return nums;
    qsort(nums,numsSize,sizeof(int ),cmp);
    int **arr=(int **)malloc(numsSize *sizeof(int *));
    arr[0]=(int *)malloc(2*sizeof(int));
    arr[0][0]=nums[0];//数字本身
    arr[0][1]=1;//频率
    int index=1;
    int j=0;
    for(int i=1;i<numsSize;i++)
    {
        if(nums[i]==arr[j][0])
        {
            (arr[j][1])++;
            continue;
        }
        else
        {
            j++;
            arr[j]=(int *)malloc(2*sizeof(int));
            arr[j][0]=nums[i];
            arr[j][1]=1;
            index++;
        }
    }
    qsort(arr,index,sizeof(int *),cmp1);
    int *res=(int *)calloc(numsSize,sizeof(int));
    int count=0;
    for(int i=0;i<index;i++)
    {
        while(arr[i][1]>0)
        {
            res[count]=arr[i][0];
            count++;
            (arr[i][1])--;
            printf("%d\n",res[count-1]);
        }
    }
   // *returnSize=index;
    return res;
}
#pragma mark-最佳方法
//解析中的方法：
//1、将负数转化为正数，即数组元素的范围从-100~100 转化为0~200；
//2、将正数数组用散列表进行计算得到每个数出现的次数count；
//3、构建一个新的数：count *1000 ---将次数放在高位以便排序时进行升序比较；
//4、由于count相等时需要比较数本身的大小，且为降序，与第三条冲突，所以将数组元素本身转化为100-nums[i]；
//5、构建出来的新数countcount *1000 + 100 -numsnums[i]；可满足排序要求；
int* frequencySort1(int* nums, int numsSize, int* returnSize){
    *returnSize=1;
    if(numsSize==1)
        return nums;
    int *hash=(int *)calloc(201,sizeof(int));
    for(int i=0;i<numsSize;i++)
        hash[nums[i]+100]++;
    for(int i=0;i<numsSize;i++)
        nums[i]=hash[nums[i]+100] *1000 +100-nums[i];
    qsort(nums,numsSize,sizeof(int ),cmp);
    for(int i=0;i<numsSize;i++)
        nums[i]=100-nums[i]%1000;
    *returnSize=numsSize;
    return nums;

}
int main(int argc, const char * argv[]) {
    // insert code here...
    int num[1]={-2};
    frequencySort(num, 1);
    return 0;
}
