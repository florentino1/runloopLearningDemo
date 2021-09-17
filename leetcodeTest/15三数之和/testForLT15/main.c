//
//  main.c
//  testForLT15
//
//  Created by 莫玄 on 2021/7/21.
//

#include <stdio.h>
#include <stdlib.h>
//对于这道题而言，是该是有两个数组。*returnSize作为返回数组中子数组的个数，如果将返回数组看做是一个二维数组的话，returnSize即为行数；
//每一个返回的子数组的大小也是一个数组，由*returnColumnSizes数组定义，即返回数组中每一行有多少列的意思；
int** threeSum(int* nums, int numsSize, int* returnSize, int** returnColumnSizes)
{
    int **returnArray=(int **)malloc(numsSize * numsSize *sizeof(int *));//为返回数组分配空间，每一个节点为一个指向int的数组指针；
    *returnColumnSizes=(int *)malloc(numsSize * numsSize *sizeof(int));//为保存子数组的大小的数组分配空间，每一个节点表示子数组的元素个数;
    *returnSize=0;

    if(numsSize<3)
        return NULL;
    //简单选择排序
    for(int i=0;i<numsSize;i++)
    {
        int min=nums[i];
        int minIndex=i;
        for(int j=i+1;j<numsSize;j++)
        {
            if(nums[j]<min)
            {
                min=nums[j];
                minIndex=j;
            }
        }
        nums[minIndex]=nums[i];
        nums[i]=min;
    }
    //对完成递增排序的数组进行判断
    int first;
    for(first=0;first<numsSize;first++)
    {
        if(nums[first]>0)
            break;;//按照递增的排序，第一个数若大于0，则必不可能和为0;
        if(first>0 && nums[first]==nums[first-1])
            continue;//排除排序数组中相同的元素，避免形成重复的三元组;
        int third=numsSize-1;//使用双指针的方法，将第三个元素从后往前开始判断;
            //固定一个数，将三元问题转化为两数之和的问题;
        for(int second=first+1;second<numsSize;second++)
        {
            if(second>first+1 && nums[second]==nums[second-1])
                continue;//去除重复的sec;

            while(second<third && nums[second]+nums[third]>(-nums[first]))
            {
                third--;
            }
            if(second==third)//注意此处sec=thir的判断，放在此处以避免sec和third为重复元素；
                break;
            if(nums[second]+nums[third]==(-nums[first]))//直到三者相加的数为0时
            {
                returnArray[*returnSize]=(int *)malloc(3*sizeof(int));//为每一个返回数组的子数组分配空间；
                returnArray[*returnSize][0]=nums[first];
                returnArray[*returnSize][1]=nums[second];
                returnArray[*returnSize][2]=nums[third];
                (*returnColumnSizes)[*returnSize]=3;//为每一个返回数组子数组定义其元素个数;
                (*returnSize)++;
            }
        }

    }
    for(int i=0;i<*returnSize;i++)
    {
        printf("%d,%d,%d\n",returnArray[i][0],returnArray[i][1],returnArray[i][2]);
    }
        return returnArray;
}

int main()
    {
    int array[]={1,2,-2,-1};
    int returnSize=0;
    int **returnColumnSizes=(int **)calloc(100000, sizeof(int *));
    threeSum(array, 4, &returnSize, returnColumnSizes);
    return 0;
    }
