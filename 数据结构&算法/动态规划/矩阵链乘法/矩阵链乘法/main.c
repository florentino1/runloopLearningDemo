//
//  main.c
//  矩阵链乘法
//
//  Created by 莫玄 on 2021/8/7.
//

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>

#pragma mark-最基本的两个矩阵相乘的算法
int **base(int **a,int **b,int arows,int acols,int brows,int bcols)
{
    if(acols!= brows)
        return NULL;//矩阵不相容，无法进行矩阵乘法；
    int **ans=(int **)calloc(arows*bcols,sizeof(int *));//结果矩阵
    for(int i=0;i<arows;i++)//遍历矩阵a的行数
    {
        ans[i]=(int *)calloc(bcols, sizeof(int));
        for(int j=0;j<bcols;j++)//遍历矩阵b的列数
        {
            ans[i][j]=0;
            for(int k=0;k<acols;k++)//对结果矩阵的每一个位置进行求值
            ans[i][j]=ans[i][j]+a[i][k]*b[k][j];//计算的规模为arows * acols *bcols;
        }
    }
    return ans;
}

#pragma mark-自底向上的方法 计算矩阵链乘法的最小计算次数以及括号的位置
int **matrix_chain_dp(int *p,int psize,int **s)
{
    //p为每一个矩阵规模的数组，A[i]=p[i+1]*p[i],所以当p的大小为n是，不同矩阵的个数为n-1；
    //构造一个二维数组m[i][j],表示从第i个矩阵到第j个矩阵相乘时的最小标量乘法次数，很明显对角线为0；
    //构造一个二维数组s[i][j],表示从第i个矩阵到第j个矩阵相乘时，应该在什么位置加括号能达到最优；
    int n=psize-1;//n表示不同规模的矩阵的个数,即矩阵链的长度
    int **m=(int **)calloc(n, sizeof(int *));
    for(int i=0;i<n;i++)//将对角线的元素设置为0；
    {
        m[i]=(int *)malloc(n*sizeof(int));
        m[i][i]=0;
    }
    for(int l=2;l<=n;l++)//对矩阵链的长度进行遍历，求解每一个矩阵链长下的最优解 ,j-i=l,m[i][j]=min(m[i][k]+m[k+1][j]+p[i]*p[k+1]*p[j+1])
    {
        for(int i=0;i<n-l+1;i++)//在当前链长为l的条件下，求解 l=j-i+1,求解m[i][j]的所有值中的最小值；l<=n,所以当j==n时，i==n-l+1,此处隐含着i>j；
        {
            int j=i+l-1;//A(i,j)矩阵链乘积，矩阵的个数为l=j-i+1;
            m[i][j]=INT_MAX;//只对i>j的部分进行赋值，i<j的部分为malloc出来的随机值；
            for(int k=i;k<j;k++)
            {
                int q=m[i][k]+m[k+1][j]+p[i]*p[k+1]*p[j+1];
                if(q<m[i][j])
                {
                    m[i][j]=q;
                    s[i][j]=k;
                }

            }

        }
    }
    return m;
}

//输出最后的括号划分方案；
void printParens(int **s,int begin,int end)
{
    if(begin==end)
        printf("A%d ",begin);
    else
    {
        printf("(");
        printParens(s,begin,s[begin][end]);
        printParens(s, s[begin][end]+1, end);
        printf(")");
    }
}

#pragma mark--使用带有备忘录的动态规划算法，自顶向下
int lookup_chain(int **m,int *p,int begin,int n)//递归方法
{
    if(m[begin][n]<INT_MAX)
        return m[begin][n];
    if(begin==n)
        m[begin][n]=0;
    else
    {
        for(int k=begin;k<n;k++)
        {
            int q=lookup_chain(m, p, begin, k)+lookup_chain(m, p, k+1, n)+p[begin]*p[k+1]*p[n+1];
            if(q<m[begin][n])
                m[begin][n]=q;
        }
    }
        return m[begin][n];
}
int memo_matrix_chain(int *p,int psize)//主方法
{
    int n=psize-1;
    int **m=(int **)calloc(n, sizeof(int *));
    for(int a=0;a<n;a++)
    {
        m[a]=(int *)malloc(n*sizeof(int));
        for(int b=0;b<n;b++)
            m[a][b]=INT_MAX;
    }
    return lookup_chain(m, p,0,n-1);
}
#pragma mark--纯递归调用,非动态规划方法
int recursive_matrix_chain(int *p,int i,int j,int **m)
{
    if(i==j)
        return 0;
    else
    {
        for(int k=i;k<j;k++)
        {
            int q=recursive_matrix_chain(p, i, k,m)+recursive_matrix_chain(p, k+1, j,m)+p[i]*p[k+1]*p[j+1];
            if(q<m[i][j])
                m[i][j]=q;
        }
        return m[i][j];
    }
}

int main()
{
    int p[7]={30,35,15,5,10,20,25};
    //使用带备忘录的dp算法
    int ans=memo_matrix_chain(p, 7);
    printf("%d\n",ans);

    //使用纯递归算法获得解；
    /*
    n=6;
    int **m=(int **)calloc(n, sizeof(int *));
    for(int a=0;a<n;a++)
    {
        m[a]=(int *)malloc(n*sizeof(int));
        for(int b=0;b<n;b++)
            m[a][b]=INT_MAX;
    }
    int ans=recursive_matrix_chain(p, 2, 5,m);
    printf("%d\n",ans);

     */


    //使用动态规划算法获得解
    /*
     int n=7-1;
     int **s=(int **)calloc(n-1, sizeof(int *));
     for(int i=0;i<n-1;i++)
         s[i]=(int *)calloc((n-1),sizeof(int));
    int **ans=matrix_chain_dp(p, 7,s);

    for(int i=0;i<6;i++)
    {
        for(int j=i;j<6;j++)
        printf("(%d,%d):%d\n",i,j,ans[i][j]);
    }
    printParens(s, 0, 5);
     */
    return 0;

}

/*
int main(int argc, const char * argv[]) {
    // insert code here...
    int **a=(int **)calloc(2, sizeof(int*));
    printf("输入a矩阵 2*2:\n");
    for(int i=0;i<2;i++)
    {
        a[i]=(int *)calloc(2, sizeof(int));
        for(int j=0;j<2;j++)
        scanf("%d",&a[i][j]);
    }
    int **b=(int **)calloc(2, sizeof(int*));
    printf("输入b矩阵 2*2:\n");
    for(int i=0;i<2;i++)
    {
        b[i]=(int *)calloc(2, sizeof(int));
        for(int j=0;j<2;j++)
        scanf("%d",&b[i][j]);
    }
    int **c=base(a,b, 2, 2, 2, 2);
    for(int i=0;i<2;i++)
    {
        for(int j=0;j<2;j++)
        printf("%d ",c[i][j]);
    }
    return 0;
}
 */
