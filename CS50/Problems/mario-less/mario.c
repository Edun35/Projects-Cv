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
    for (int i = 0; i < n; i++)
    {
        // spaces
        for (int d = n; d > i + 1; d--)
        {
            printf(" ");
        }
        // bricks
        for (int r = -1; r < i; r++)
        {
            printf("#");
        }
        
        printf("\n");
    }
}