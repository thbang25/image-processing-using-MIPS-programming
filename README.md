# MIPS_Image_processing

**Question 1**

The MIPS program increase_brightness.asm reads a PPM file and increases the RGB values of a color PPM by 10.

adding 10 increases the value over 255, store the value as 255. This new image should be written to a new file. After execution display the average of all RGB values of the original file, as well as the average of all RGB values of the new file, as a double value on the console.

***The result should look something like this*:**
The average pixel value of the original image: 0.72084067350898684 
The average pixel value of the new image: 0.76005635978349673 

**The file format**:

Lines 1 to 4 form the header of the PPM file. They provide information about the image. Line 1 refers to the type of PPM file. In this case, “P3” means the file is a color image stored in ASCII form. Comments for the image can be stored using the # symbol. The image above has a single comment in line 2. The image size is stored in line 3.

The first 64 refers to the number of rows in the image. The second 64 refers to the number of columns in this image. Multiplying the two values will provide you with the total number of pixels in the image (64 𝑟𝑜𝑤𝑠 ∗ 64 𝑐𝑜𝑙𝑢𝑚𝑛𝑠 = 4096 𝑝𝑖𝑥𝑒𝑙𝑠). 

The remainder of the file consists of RGB values for each pixel, in ASCII form. Each line consists of 1 value, which will either be an R, G, or B value for a pixel.

The PPM destination can be hardcoded into the program, the code has functions that read the data in the file and store the data into a buffer, then iterate through the data line by line and  convert the ASCII values into integers.

**Question 2**

The MIPS program greyscale.asm reads in a color PPM P3 image and converts this to a greyscale PPM P2 image. 

A greyscale pixel value is calculated by finding the average of its RGB values. Decimals are rounded down to the nearest whole number: for a pixel with RGB values of 166, 186, and 181 respectively, the greyscale pixel value will be 177. 

The PPM destination can be hardcoded into the program, the code has functions that read the data in a file and store it in a buffer after you convert the ASCII values into integers.

The file type will be changed to "P2" in the header of the new greyscale file.
