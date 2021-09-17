//
//  main.c
//  1455检查单词是否为句子中单词的前缀---字符串匹配
//
//  Created by 莫玄 on 2021/8/18.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int isPrefixOfWord(char * sentence, char * searchWord){
    int lenSearch=strlen(searchWord);
    int spaceCount=0;
    int wordStartIndex=0;
    int lenSentence=strlen(sentence);
    char *tmp=(char *)calloc(101,sizeof(char));
    for(int i=0;i<=lenSentence;i++)
    {
        if(sentence[i]==' '|| sentence[i]=='\0')
        {
            spaceCount++;
            int lenTmp=i-wordStartIndex;
            if(lenTmp>=lenSearch)
            {
                memcpy(tmp,sentence+wordStartIndex,lenSearch);
                int res=strcmp(tmp,searchWord);
                if(res==0)
                    return spaceCount;
            }
            wordStartIndex=i+1;
        }
    }
    return -1;
}
int main(int argc, const char * argv[]) {
    char s[101]="i love eating burger";
    char se[11]="burg";
    int i=isPrefixOfWord(s, se);
    printf("%d\n",i);
    return 0;
}
