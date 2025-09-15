# include <cs50.h>
# include <stdio.h>
# include <math.h>

int main(void)
{
    //get change
    float euros;
    do
    {
        euros = get_float("change owed: ");
    }
    while (euros <= 0);
    
    // round change
    int change = round(euros * 100);
    
    // start coin counter
    int coins = 0;

    // loop through coins giving highest value 
    while (change > 0)
    {
        if (change >= 25)
        {
            change = change - 25;
            coins++;
        }
        else if (change >= 10)
        {
            change = change - 10;
            coins++;
        }
        else if (change >= 5)
        {
            change = change - 5;
            coins++;
        }
        else
        {
            change = change - 1;
            coins++;
        }
    }
    
    // display number of coins used
    printf("coins: %i\n", coins);
}    