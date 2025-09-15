#include <cs50.h>
#include <stdio.h>

int main(void)
{
    // get name
    string name = get_string("What is your name?\n");
    // display 
    printf("hello, %s\n", name);
}
