//
//  sort.c
//  Sort
//
//  Created by 莫玄 on 2021/7/14.
//

#include "sort.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <math.h>

#pragma mark-插入排序
//直接插入排序---时间复杂度为O(n^2),将第i项插入0~i形成的数组中；
void myinsert_sort(int *array,int len)
{
    for(int i=1;i<len;i++)//第一层循环，遍历数组中的每一个元素
    {
        int tmp=array[i];
        int j=i-1;
        for(;j>=0;j--)//第二层循环，遍历i之前数组，找到最小值
        {
            if(tmp<array[j])//如果就tmp小于j-1的值，则比较下一项；若tmp大于j-1的值，则说明tmp为0~j的最大值，且0~j-1的数组已经完成排序；
            {
                array[j+1]=array[j];
            }
            else
                break;;
        }
        array[j+1]=tmp;//插入待排序的值
    }
}


//折半插入排序：针对的是有序表类型的数组
void mybinary_insert_sort(int *array,int len)
{
    for (int i=2;i<len;i++)//第一层循环，需要遍历整个数组，数组的前两个数作为基础数组
    {
        int low=0;
        int high=i-1;
        while (low<=high)//循环的出口条件
        {
            int m=(low+high)/2;
            if(array[i]>array[m])//表示i的值处于m~high的区域呢，需要更新low的值到m+1，然后在low和high中继续查找
                low=m+1;
            else if(array[i]<array[m])
                high=m-1;
            else//array[i]==array[m]找到插入的位置即为m，将其赋值给hihg并结束while循环
            {
                high=m;
                break;
            }
        }
        //此时到达循环的出口，已找到i需要插入的位置为high+1处
        int tmp=*(array+i);
        for(int n=i-1;n>=high+1;n--)//第high+1位也需要被移动，要给第i项腾出第high+1位；
        {
            *(array+n+1)=*(array+n);
        }
       *(array+high+1)=tmp;
    }
}
//冒泡排序：两两比较元素之间的大小，并进行位置交换，将最大、最小的交换到特定位置；
void mybubble_sort(int *array,int len)
{
    for(int i=0;i<len;i++)
    {
        for(int j=0;j<len-1;j++)
        {
            if(array[j]>array[j+1])
            {
                int tmp=array[j+1];
                array[j+1]=array[j];
                array[j]=tmp;
            }
        }
    }
}
//简单选择排序：与冒泡排序所不同的是，冒泡排序每一次比较都会进行位置交换，简单选择排序只需要找出一次循环中的最大最小值，在最后进行一次交换即可
void myselect_sort(int *array,int len)
{
    for(int j=0;j<len;j++)
    {
        int max=array[j];
        int maxindex=j;
        for(int i=j+1;i<len;i++)
        {
            if(array[i]>max)
            {
                max=array[i];
                maxindex=i;
            }
        }
        array[maxindex]=array[j];
        array[j]=max;
    }
}
//桶排序---需要额外的一个辅助空间去进行分桶操作；
void mybucket_sort(int *arr,int len)
{
    int bucket[len][len];//构建一个桶的数组bucket[]，同时桶又是一个数组bucket[][]；
    int *bucketSize=(int *)calloc(len,sizeof(int));//用于记录每一个桶中的元素个数
    for(int i=0;i<len;i++)
        bucket[i][bucketSize[i]++]=arr[i];
    //对桶中的元素进行排序;
    for(int i=0;i<len;i++)
        myselect_sort(bucket[i], bucketSize[i]);
    //将桶中的元素输出
    int index=0;
    for(int i=0;i<len;i++)
    {
        for(int j=0;i<bucketSize[i];j++)
            arr[index++]=bucket[i][j];
    }
}
