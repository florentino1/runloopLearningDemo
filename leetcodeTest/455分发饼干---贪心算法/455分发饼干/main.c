//
//  main.c
//  455分发饼干
//
//  Created by 莫玄 on 2021/8/6.
//

#include <stdio.h>
#include <stdlib.h>
int cmp(const void*a,const void*b)
{
    int i=*(int *)a;
    int j=*(int *)b;
    return (i>j)?1:-1;
}
int findContentChildren(int* g, int gSize, int* s, int sSize){
    if(sSize==0)
        return 0;
    qsort(g,gSize,sizeof(int),cmp);
    qsort(s,sSize,sizeof(int),cmp);
    //快慢指针进行选择
    int count=0;
    int i;//g
    int j;//s
    for(i=0,j=0;i<=gSize && j<sSize;j++)
    {
        if(s[j]>=g[i])
        {
            count++;
            i++;
        }
    }
    return count;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    int g[4]={10,9,8,7};
    int s[4]={5,6,7,8};
    int ans=findContentChildren(g, 4, s, 4);
    printf("%d\n",ans);
    return 0;
}
