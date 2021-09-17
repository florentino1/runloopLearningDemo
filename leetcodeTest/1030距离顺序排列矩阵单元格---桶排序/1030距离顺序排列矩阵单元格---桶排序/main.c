//
//  main.c
//  1030距离顺序排列矩阵单元格---桶排序
//
//  Created by 莫玄 on 2021/8/7.
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int** allCellsDistOrder(int rows, int cols, int rCenter, int cCenter, int* returnSize, int** returnColumnSizes){
//res 的大小为*returnSize  是int**型；
//returnColumnSize是**型，*returnColumnSize是数组，即为2；
    int **res=(int **)calloc(rows*cols,sizeof(int *));
  //int **tmp=(int **)calloc(rows*cols,sizeof(int *));
    *returnColumnSizes=(int *)calloc(rows*cols,sizeof(int));
    *returnSize=0;
    int maxDis=fmax(rows,rows-1-rCenter)+fmax(cols,cols-1-cCenter);//曼哈顿距离的最大值---是一个定值；
    int *buck[maxDis+1][2*(rows+cols)];
    int *buckSize=(int *)calloc((maxDis+1),sizeof(int ));//相当于距离散列表，储存的值表示该桶中的元素个数；
    for(int i=0;i<rows;i++)
    {
        int m=i-rCenter;
        m=(m>0)?m:(-m);
        for(int j=0;j<cols;j++)
        {
            int n=j-cCenter;
            n=(n>0)?n:(-n);
            int index=m+n;
            int *tmp=(int *)calloc(2,sizeof(int));
            tmp[0]=i;
            tmp[1]=j;
            buck[index][buckSize[index]++]=tmp;
        }
    }
    for(int i=0;i<maxDis+1;i++)
    {
        for(int j=0;j<buckSize[i];j++)
            res[(*returnSize)++]=buck[i][j];
    }
    for (int i = 0; i < rows * cols; i++) {
        (*returnColumnSizes)[i] = 2;
    }
    return res;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    return 0;
}
