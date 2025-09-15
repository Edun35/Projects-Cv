# include <cs50.h>
# include <stdio.h>

int main(void)
{
    // initializing variables
    int d = 0;
    int d1 = 0;
    int sum1 = 0;
    int sum2 = 0;
    int chsm = 0;
    int switch1 = 0;
    int digit_counter = 0;
    int d13 = 0;
    int d14 = 0;
    int d15 = 0;
    int d16 = 0;

    //get card number
    long card = get_long("Card Number: ");

    // checksum
    // get digits
    while (card > 0)
    {
        if (card >= 10)
        {
            d = card % 10;
            card /= 10;
            digit_counter++;
        }
        else
        {
            d = card;
            card /= 10;
            digit_counter++;
            
        }

        // every 2nd digit
        switch (switch1)
        {
            case 0:
                sum1 = sum1 + d;
                switch1++;
                break;

            case 1:
                d1 = d * 2;
                if (d1 >= 10)
                {
                    int d2 = d1 % 10;
                    d1 /= 10;
                    sum2 = sum2 + d1 + d2;
                }
                else
                {
                    sum2 = sum2 + d1;
                }
                switch1--;
                break;
        }

        // digit counter for cardtype
        if (digit_counter == 13)
        {
            d13 = d;
        }
        if (digit_counter == 14)
        {
            d14 = d;
        }
        if (digit_counter == 15)
        {
            d15 = d;
        }
        if (digit_counter == 16)
        {
            d16 = d;
        }
    }

    // checksum last digit
    chsm = sum1 + sum2;
    chsm = chsm % 10;

    // cardtype
    if (chsm == 0 && digit_counter >= 13)
    {
        // check lenght
        if (digit_counter == 16)
        {
            // display master
            if (d16 == 5 && d15 <= 5)
            {
                printf("MASTERCARD\n");
            }
            // visa
            else if (d16 == 4)
            {
                printf("VISA\n");
            }
            //invalid
            else
            {
                printf("INVALID\n");
            }
        }
        // check lenght
        else if (digit_counter == 15)
        {
            if (d15 == 3)
            {
                //display names amex / invalid
                if (d14 == 4 || d14 == 7)
                {
                    printf("AMEX\n");
                    
                }
                else
                {
                    printf("INVALID\n");
                    
                }
            }
        }
        //check lenght
        else if (digit_counter == 13)
        {
            //display visa / invalid
            if (d13 == 4)
            {
                printf("VISA\n");
            }
            else
            {
                printf("INVALID\n");
            }
        }
    }
    // display invalid
    else
    {
        printf("INVALID\n");
    }
}