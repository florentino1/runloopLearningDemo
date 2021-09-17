//
//  main.c
//  406根据身高重建数组
//
//  Created by 莫玄 on 2021/8/17.
//

#include <stdio.h>
#include <stdlib.h>

/*
 假设有打乱顺序的一群人站成一个队列，数组 people 表示队列中一些人的属性（不一定按顺序）。每个 people[i] = [hi, ki] 表示第 i 个人的身高为 hi ，前面 正好 有 ki 个身高大于或等于 hi 的人。

 请你重新构造并返回输入数组 people 所表示的队列。返回的队列应该格式化为数组 queue ，其中 queue[j] = [hj, kj] 是队列中第 j 个人的属性（queue[0] 是排在队列前面的人）。



 来源：力扣（LeetCode）
 链接：https://leetcode-cn.com/problems/queue-reconstruction-by-height
 著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。
 */
int cmp(const void* a,const void*b)
{
    int *m=*(int **)a;
    int *n=*(int **)b;
    return (m[0]==n[0])?(n[1]-m[1]):(m[0]-n[0]);//按照身高升序排列，按照k降序排列
}
int** reconstructQueue(int** people, int peopleSize, int* peopleColSize, int* returnSize, int** returnColumnSizes){
    qsort(people,peopleSize,sizeof(int *),cmp);
    int **res=(int **)calloc(peopleSize,sizeof(int *));
    *returnColumnSizes=(int *)calloc(peopleSize,sizeof(int));
    *returnSize=peopleSize;
    for(int i=0;i<peopleSize;i++)//外层循环，将排序好的数组进行遍历放进res返回数组中；
    {
        int space=people[i][1]+1;//表示people中的元素在返回数组res中的位序；
        for(int j=0;j<peopleSize;j++)
        {
            if((*returnColumnSizes)[j]==0)//表示返回数组res当前位置未插入元素
            space--;
            if(space==0)//表示people中的元素i应该放在此j处;
            {
                (*returnColumnSizes)[j]=2;
                res[j]=(int *)calloc(2,sizeof(int));
                res[j][0]=people[i][0];
                res[j][1]=people[i][1];
                break;
            }
        }
    }
    return res;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    return 0;
}
