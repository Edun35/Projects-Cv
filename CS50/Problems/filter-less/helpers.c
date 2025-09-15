#include "helpers.h"
#include <math.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    // height
    for (int i = 0; i < height; i++)
    {
        //width
        for (int j = 0; j < width; j++)
        {
            int avg = round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);
            image[i][j].rgbtRed = avg;//red
            image[i][j].rgbtGreen = avg;//green
            image[i][j].rgbtBlue = avg;//blue
        }
    }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    // height
    for (int i = 0; i < height; i++)
    {
        //width
        for (int j = 0; j < width; j++)
        {
            //sepia colours
            int sepR = round(.393 * image[i][j].rgbtRed + .769 * image[i][j].rgbtGreen + .189 * image[i][j].rgbtBlue);
            if (sepR > 255)
            {
                sepR = 255;
            }
            int sepG = round(.349 * image[i][j].rgbtRed + .686 * image[i][j].rgbtGreen + .168 * image[i][j].rgbtBlue);
            if (sepG > 255)
            {
                sepG = 255;
            }
            int sepB = round(.272 * image[i][j].rgbtRed + .534 * image[i][j].rgbtGreen + .131 * image[i][j].rgbtBlue);
            if (sepB > 255)
            {
                sepB = 255;
            }

            // update colours
            image[i][j].rgbtRed = sepR;
            image[i][j].rgbtGreen = sepG;
            image[i][j].rgbtBlue = sepB;

        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    // height
    for (int i = 0; i < height; i++)
    {
        //width
        for (int j = 0; j < width / 2; j++)
        {
            // temp pixel
            RGBTRIPLE tmp = image[i][j];

            //update pixel
            image[i][j] = image[i][width - 1 - j];

            // update opposing pixel
            image[i][width - 1 - j] = tmp;
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    // temp
    RGBTRIPLE tmp[height][width];
    
    // rows
    for (int i = 0; i < height; i++)
    {
        //columns
        for (int j = 0; j < width; j++)
        {
            // vars
            double rsum = 0;
            double gsum = 0;
            double bsum = 0;
            int products = 0; 
            
            // surround
            for (int a = i - 1; a <= i + 1; a++)
            {
                for (int b = j - 1; b <= j + 1; b++)
                {
                    if (a >= 0 && a < height && b >= 0 && b < width)
                    {
                        rsum += image[a][b].rgbtRed;
                        gsum += image[a][b].rgbtGreen;
                        bsum += image[a][b].rgbtBlue;
                        products++;
                    }
                    else 
                    {
                        continue;
                    }
                }
            }

            // update temp
            tmp[i][j].rgbtRed = round(rsum / products);
            tmp[i][j].rgbtGreen = round(gsum / products);
            tmp[i][j].rgbtBlue = round(bsum / products);
        }
    }    
    // copy from temp
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j].rgbtRed = tmp[i][j].rgbtRed;
            image[i][j].rgbtGreen = tmp[i][j].rgbtGreen;
            image[i][j].rgbtBlue = tmp[i][j].rgbtBlue;
        }
        
    }
    return;
}
