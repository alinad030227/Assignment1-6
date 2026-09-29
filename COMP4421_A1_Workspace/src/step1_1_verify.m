%% COMP4421 Assignment 1 - Step 1.1 Matrix Verification & Type Casting
% Target: input_data/watermarked_cameraman.png
% Purpose: Verify image geometry, bit-depth, dynamic range, and double-precision promotion.

clear; clc;

image_path = fullfile("..", "input_data", "watermarked_cameraman.png");
if ~isfile(image_path)
    % Fallback for direct execution within workspace root
    image_path = fullfile("COMP4421_A1_Workspace", "input_data", "watermarked_cameraman.png");
end

fprintf("===================================================================\n");
fprintf("  COMP4421 Step 1.1: Matrix Integrity & Type Casting Verification  \n");
fprintf("===================================================================\n\n");

%% 1. 讀取影像與基底屬性校驗
assert(isfile(image_path), "Fatal Error: Input image file '%s' not found.", image_path);
img = imread(image_path);

% 驗證資料型別為 8-bit 無符號整數 (uint8)
assert(isa(img, 'uint8'), ...
    "Assertion Failure: Input image must be of type 'uint8', but got '%s'.", class(img));

% 驗證色彩維度為單通道灰階影像 (2D Matrix)
assert(ismatrix(img) && ndims(img) == 2, ...
    "Assertion Failure: Image must be a 2D single-channel grayscale matrix.");

[M, N] = size(img);
% 驗證空間解析度為標準 512 x 512 格點
assert(M == 512 && N == 512, ...
    "Assertion Failure: Expected image dimensions 512x512, but received %dx%d.", M, N);

% 驗證動態範圍嚴格屬於整數環 Z_256 = [0, 255]
min_val_u8 = min(img(:));
max_val_u8 = max(img(:));
assert(min_val_u8 >= 0 && max_val_u8 <= 255, ...
    "Assertion Failure: Pixel intensity values exceed valid uint8 bounds [0, 255].");

fprintf("[PASS] Input Image Validation:\n");
fprintf("       - File Path:          %s\n", image_path);
fprintf("       - Data Type:          %s (8-bit unsigned integer)\n", class(img));
fprintf("       - Spatial Dimensions: %d x %d (Total Pixels: %d)\n", M, N, M * N);
fprintf("       - Dynamic Range:      [%d, %d]\n", min_val_u8, max_val_u8);
fprintf("       - Memory Consumption: %d bytes\n\n", numel(img) * 1);

%% 2. 浮點域提升 (Double-Precision Promotion)
% 強制將離散整數映射至 IEEE 754 雙精度浮點實數空間 R，避免二階差分計算產生下溢截斷 (Negative Underflow)
f = double(img);

% 驗證資料型別轉換正確性
assert(isa(f, 'double'), ...
    "Assertion Failure: Variable 'f' must be of type 'double', but got '%s'.", class(f));

% 驗證數值保持嚴格雙射性 (Bijective mapping: f(x, y) == img(x, y))
assert(isequal(f, double(img)), ...
    "Assertion Failure: Value mismatch detected during double-precision casting.");

min_val_dbl = min(f(:));
max_val_dbl = max(f(:));
mean_val    = mean(f(:));
std_val     = std(f(:));

fprintf("[PASS] Double-Precision Promotion (f = double(img)):\n");
fprintf("       - Variable Name:      f\n");
fprintf("       - Data Type:          %s (64-bit IEEE 754 float)\n", class(f));
fprintf("       - Spatial Dimensions: %d x %d\n", size(f, 1), size(f, 2));
fprintf("       - Dynamic Range:      [%.4f, %.4f]\n", min_val_dbl, max_val_dbl);
fprintf("       - Statistical Mean:   %.4f\n", mean_val);
fprintf("       - Standard Deviation: %.4f\n", std_val);
fprintf("       - Memory Consumption: %d bytes (8x overhead allocated for convolution)\n\n", numel(f) * 8);

fprintf("===================================================================\n");
fprintf("  Status: Step 1.1 Complete. Data matrix is ready for Step 1.2.    \n");
fprintf("===================================================================\n");