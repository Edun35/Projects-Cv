#include <cs50.h>
#include <stdio.h>

int main(void)
{
    //get num between 1 and 8.
    int n;
    do
    {
        n = get_int("Height: ");
      
    }
    while (n < 1 || n > 8);

    // rows
    for (int height = 1; height <= n; height++)
    {
        // spaces
        for (int row = n; row > height; row--)
        {
            printf(" ");

        }
        // left pyramid
        for (int x = 0; x < height; x++)
        {
            printf("#");

        }
        // middle
        for (int d = 0; d < 1; d++)
        {
            printf("  ");

        }
        //right pyramid
        for (int y = 0; y < height; y++)
        {
            printf("#");

        }
        printf("\n");

    }
}