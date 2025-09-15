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
            int avg = (int) round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);
            image[i][j].rgbtRed = avg;//red
            image[i][j].rgbtGreen = avg;//green
            image[i][j].rgbtBlue = avg;//blue
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

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    // temp
    RGBTRIPLE tmp[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            tmp[i][j] = image[i][j];
        }
    }

    //sobel arrays
    int arrayGX[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int arrayGY[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

    // rows
    for (int i = 0; i < height; i++)
    {
        //columns
        for (int j = 0; j < width; j++)
        {
            // vars
            float GXr = 0;
            float GXg = 0;
            float GXb = 0;
            float GYr = 0;
            float GYg = 0;
            float GYb = 0;

            // Surrounding pixels
            for (int a = -1; a < 2; a++)
            {
                for (int b = -1; b < 2; b++)
                {
                    if (a + i < 0 || a + i >= height)
                    {
                        continue;
                    }
                    if (b + j < 0 || b + j >= width)
                    {
                        continue;
                    }
                    else
                    {
                        GXr += arrayGX[a + 1][b + 1] * tmp[a + i][b + j].rgbtRed;
                        GXg += arrayGX[a + 1][b + 1] * tmp[a + i][b + j].rgbtGreen;
                        GXb += arrayGX[a + 1][b + 1] * tmp[a + i][b + j].rgbtBlue;

                        GYr += arrayGY[a + 1][b + 1] * tmp[a + i][b + j].rgbtRed;
                        GYg += arrayGY[a + 1][b + 1] * tmp[a + i][b + j].rgbtGreen;
                        GYb += arrayGY[a + 1][b + 1] * tmp[a + i][b + j].rgbtBlue;
                    }
                }
            }
            // sobel r g b
            int red = round(sqrt(GXr * GXr + GYr * GYr));
            int green = round(sqrt(GXg * GXg + GYg * GYg));
            int blue = round(sqrt(GXb * GXb + GYb * GYb));

            // cap 255
            if (red > 255)
            {
                red = 255;
            }
            if (green > 255)
            {
                green = 255;
            }
            if (blue > 255)
            {
                blue = 255;
            }
        
            // update img
            image[i][j].rgbtRed = red;
            image[i][j].rgbtGreen = green;
            image[i][j].rgbtBlue = blue;
        }
    }
    return;
}