#include <stdio.h>

#include "lodepng.h"

int main(int argc, char* argv[])
{
	char* input_filename = argv[1];
	int size_maze = atoi(argv[2]);

	unsigned error;
	unsigned char* image;
	unsigned char* image_copy = (unsigned char*)malloc(size_maze * size_maze * 4 * sizeof(unsigned char));
	unsigned image_width, image_height;

	// Decode image
	error = lodepng_decode32_file(&image, &image_width, &image_height, input_filename);
	if (error) printf("error %u: %s\n", error, lodepng_error_text(error));

	printf("Input file: %s, maze width: %d, maze height: %d\n", input_filename, image_width, image_height);

	for (int i = 0; i < image_width * image_height * 4; i += 4) {
		int row = i / (image_width * 4);
		int col = i % (image_width * 4);

		if (row > 0 && row < size_maze + 1 && col > 0 && col < ((size_maze + 1) * 4)) {
			if (image[i] == 255) {
				image_copy[col - 4 + (row - 1) * size_maze * 4] = 0;
				image_copy[col - 4 + (row - 1) * size_maze * 4 + 1] = 0;
				image_copy[col - 4 + (row - 1) * size_maze * 4 + 2] = 0;
			}
			else {
				image_copy[col - 4 + (row - 1) * size_maze * 4] = 255;
				image_copy[col - 4 + (row - 1) * size_maze * 4 + 1] = 255;
				image_copy[col - 4 + (row - 1) * size_maze * 4 + 2] = 255;
			}
			image_copy[col - 4 + (row - 1) * size_maze * 4 + 3] = image[i + 3];
		}
	}

	lodepng_encode32_file("maze_inv.png", image_copy, size_maze, size_maze);

	return 0;
}
