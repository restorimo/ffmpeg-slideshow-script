# ffmpeg-slideshow-script

This script allows you to convert a folder of JPG images into an animated GIF using FFmpeg. It provides an interactive prompt to select the input folder, set various parameters, and generate the GIF with customization options.

## Features

- List folders with numbers for easy selection.
- Choose the input folder containing the JPG images.
- Set the frame rate for the GIF (default is 2 frames per second).
- Specify the output name for the GIF (default is "output").
- Define the scale input for resizing the images (default is 1000 pixels).
- Adjust the pixelize input for the level of pixelization (default is 15).
- Control the noise input for adding noise effects (default is 10).
- Supports overlaying an image on each frame.
- Automatically calculates the duration based on the line count and frame rate.
- Outputs the GIF in GIF format with the specified parameters.

## Usage

1. Run the script and follow the prompts.
2. Select the folder number containing the JPG images.
3. Enter the desired parameters or press Enter to use the default values.
4. The script will generate the GIF using FFmpeg with the specified settings.
5. Once the conversion is completed, the GIF file will be saved in the current directory.

## Requirements

- FFmpeg: Make sure FFmpeg is installed and accessible in the system's PATH.

## Note

- The script assumes that all the JPG images in the selected folder are part of the animation sequence.

Feel free to modify and adapt the script according to your needs. Happy GIF converting!
