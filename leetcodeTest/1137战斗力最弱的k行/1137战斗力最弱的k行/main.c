//
//  main.c
//  1137战斗力最弱的k行
//
//  Created by 莫玄 on 2021/8/5.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int cmp(const int*a,const int *b)
 {
     return *a- *b;
 }
 int count(int *arr,int length)
 {
     int ans=0;
     for(int i=0;i<length;i++)
     {
         if(arr[i]==1)
            ans++;
         else
            break;
     }
     return ans;
 }
int* kWeakestRows(int** mat, int matSize, int* matColSize, int k, int* returnSize){
//matsize相当于行数，matcolsize是每一个子数组的长度，即每一行的长度；
    *returnSize=k;
    int length=*matColSize;
    int *res=(int *)calloc(matSize,sizeof(int));
    for(int i=0;i<matSize;i++)
    {
        for(int j=0;j<length;j++)
            res[i]=count(mat[i],length) * matSize +i;
    }
    qsort(res,matSize,sizeof(int),cmp);
    for(int m=0;m<k;m++)
        res[m]=res[m]%matSize;

    return res;

}
int main(int argc, const char * argv[]) {
    // insert code here...
    int mat[5][5]={{0,0,0,0,0},{1,1,1,1,0},{1,0,0,0,0},{1,1,0,0,0},{1,1,1,1,1}};
    int *p=&mat[0][0];
    int **q=&p;
    int len=5;
    int returnSize=0;
    kWeakestRows(q, 5, &len, 3, &returnSize);

    return 0;
}
