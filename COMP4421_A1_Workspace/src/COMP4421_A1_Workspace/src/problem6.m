%% COMP4421 Assignment 1 - Programming Problem 6 (20 pts)
% Input image: watermarked_cameraman.png (8-bit grayscale)
%
% Rules:
%   * In Question a) you must implement the Laplacian filtering yourself.
%     Do NOT use imfilter, conv2, filter2, fspecial, del2, or any other
%     built-in filtering function.
%   * Only write code at the places marked by "% your code here" inside the
%     "Coding zone" blocks. Modifying any other line of this skeleton gives
%     0 marks for the corresponding sub-question.
%   * In your written answers, state which bit plane (1-8) contains the watermark.
%   * Put this script, the three images it generates (sharpened_K4.png,
%     sharpened_K8.png, hidden_watermark.png) and your written answers (PDF)
%     together into one zip file named <SID>.zip.

img = imread("watermarked_cameraman.png");
f   = double(img);                      % work in double to avoid uint8 overflow
[M, N] = size(img);

% initialized variables for you to answer questions
K4 = zeros(3);                          % a Laplacian kernel
K8 = zeros(3);                          % kernel that includes the diagonal terms
lap4 = zeros(M, N);                     % Laplacian response using K4
lap8 = zeros(M, N);                     % Laplacian response using K8
sharp4 = zeros(M, N, "uint8");          % sharpened image using K4
sharp8 = zeros(M, N, "uint8");          % sharpened image using K8
planes = zeros(M, N, 8, "uint8");       % planes(:,:,k) = k-th bit plane (0 or 255)
watermark = zeros(M, N, "uint8");       % the hidden watermark (0 or 255)

%------------ Coding zone-------------
% Question a) Laplacian edge extraction and sharpening (12 pts)
% (i)   4 pts: Define K4, a Laplacian kernel (see Lecture 4, p.70), filter f
%              with it and assign the response (edge map) to 'lap4'.
% (ii)  4 pts: Define K8, the kernel that includes the diagonal terms, filter
%              f with it and assign the response (edge map) to 'lap8'.
%       For both kernels: use a NEGATIVE centre coefficient, filter f by
%       yourself (no built-in filtering functions), pad the border with
%       zeros (zero padding), and keep the response the same size as f.
% (iii) 2 pts: Sharpen with g = f + c * lap4, clip to [0, 255], convert to
%              uint8, and assign the result to 'sharp4'.
%              Hint: c = -1 if the kernel's centre coefficient is negative,
%                    c = +1 if it is positive.
% (iv)  2 pts: Same as (iii) with lap8; assign the result to 'sharp8'.

% (i) Define K4: 4-neighborhood Laplacian operator with negative center coefficient
K4 = [ 0,  1,  0;
       1, -4,  1;
       0,  1,  0];

% (ii) Define K8: 8-neighborhood Laplacian operator (including diagonals) with negative center coefficient
K8 = [ 1,  1,  1;
       1, -8,  1;
       1,  1,  1];

% Border zero-padding (p = 1) to maintain spatial dimensions M x N
f_pad = zeros(M + 2, N + 2);
f_pad(2:M+1, 2:N+1) = f;

% Native 2D spatial convolution implementation (avoiding imfilter, conv2, filter2)
for i = 1:M
    for j = 1:N
        window = f_pad(i:i+2, j:j+2);
        lap4(i, j) = sum(sum(K4 .* window));
        lap8(i, j) = sum(sum(K8 .* window));
    end
end

% (iii) Sharpening synthesis with K4: g = f + c * lap4; c = -1 due to negative center
c = -1;
g4 = f + c * lap4;
g4_clipped = min(max(g4, 0), 255);
sharp4 = uint8(g4_clipped);

% (iv) Sharpening synthesis with K8: g = f + c * lap8; c = -1 due to negative center
g8 = f + c * lap8;
g8_clipped = min(max(g8, 0), 255);
sharp8 = uint8(g8_clipped);

%-----------------END-----------------

%------------ Coding zone-------------
% Question b) Bit-plane slicing (8 pts)
% A watermark is hidden in ONE bit plane of the image. Hint: you may use bitget().
% (i)  4 pts: Slice the image into its 8 bit planes. Store the k-th plane
%             (k = 1 is the least-significant bit) in planes(:,:,k), scaled to 0/255.
% (ii) 4 pts: Find the plane that contains the watermark and assign it to 'watermark'.
%             State which bit plane (1-8) it is in your written answers.

% (i) Deconstruct the 8-bit image into 8 binary bit planes
% Scale the boolean values {0, 1} to full display dynamic range {0, 255}
for k = 1:8
    planes(:, :, k) = uint8(bitget(img, k) * 255);
end

% (ii) Assign the plane containing the watermark to 'watermark'
% Through spatial inspection across all 8 bit planes, Bit Plane 1 (LSB) contains
% the structured binary HKUST watermark emblem.
target_plane = 1;
watermark = planes(:, :, target_plane);

%-----------------END-----------------

% save your results (do not modify)
imwrite(sharp4, "sharpened_K4.png");
imwrite(sharp8, "sharpened_K8.png");
imwrite(watermark, "hidden_watermark.png");      % standalone 8-bit grayscale image

% visualize your results
figure("Name", "Question a) Laplacian filters");
subplot(231); imshow(img);         title("input image");
subplot(232); imshow(lap4, []);    title("Laplacian (K4)");
subplot(233); imshow(lap8, []);    title("Laplacian (K8)");
subplot(235); imshow(sharp4);      title("sharpened (K4)");
subplot(236); imshow(sharp8);      title("sharpened (K8)");

figure("Name", "Question b) Bit planes");
for k = 1:8
    subplot(2, 4, k); imshow(planes(:, :, k)); title("bit plane " + k);
end

figure("Name", "Question b) Hidden watermark");
imshow(watermark); title("hidden watermark");
