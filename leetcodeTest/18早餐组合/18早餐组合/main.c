//
//  main.c
//  18早餐组合
//
//  Created by 莫玄 on 2021/8/13.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define debug
int cmp(const void*a,const void*b)
{
    return *(int *)a- *(int *)b;
}
int binarySearch(int *arr,int size,int n)
{
    int low=0;
    int high=size-1;
    while(low<=high)
    {
        int mid=(low+high)/2;
#ifdef debug
    printf("arr[mid]=%d \n",arr[mid]);
#endif
        if(arr[mid]>n)
            high=mid-1;
        else if(arr[mid]<n)
            low=mid+1;
        else//如果相等时，需要找到序号最大的那一个相等数；
        {
            while(mid<=size-2 && arr[mid+1]==n)
                mid=mid+1;
            return mid+1;
        }
    }
    return high+1;
}
int breakfastNumber(int* staple, int stapleSize, int* drinks, int drinksSize, int x){
    qsort(drinks,drinksSize,sizeof(int),cmp);
#ifdef debug
    for(int i=0;i<drinksSize;i++)
    printf("%d ",drinks[i]);
#endif
    int ans=0;
    for(int i=0;i<stapleSize;i++)
    {
        int tmp=x-staple[i];
        if(tmp<0)
            continue;
        int index=binarySearch(drinks,drinksSize,tmp);
        ans+=index;
    }
    return ans%1000000007;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    int staple[3]={2,1,1};
    int drinks[4]={8,9,5,1};
    int x=9;
    int ans=breakfastNumber(staple, 3, drinks, 4, x);
    printf("%d\n",ans);
    return 0;
}
