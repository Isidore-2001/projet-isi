#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    printf("EUID: %d\n", geteuid());
    printf("EGID: %d\n", getegid());
    printf("RUID: %d\n", getuid());
    printf("RGID: %d\n", getgid());

    // read a content of a file and print it mydir/myfile
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    if (argc < 2) {
        printf("Usage: %s <file>", argv[0]);
        exit(1);
    }
    fp = fopen(argv[1], "r");
    if (fp == NULL){
        printf("Error opening file\n");
        exit(EXIT_FAILURE);
    }
    while ((read = getline(&line, &len, fp)) != -1) {
        printf("%s", line);
    }
    fclose(fp);
    if (line)
        free(line);
    exit(EXIT_SUCCESS);
}
