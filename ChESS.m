
%%% This file contains an implementation of the ChESS algorithm described
%%% by Stuart Bennett and Joan Lasenby in their 2014 paper "ChESS – Quick and
%%% robust detection of chess-board features"


% Reset
clear;clc;close all;

% Load image
img = imread('img.jpg');

% Convert to greyscale
img = rgb2gray(img);


% Hardcoded set of 16 sample positions suggested in paper
translations = [
    -5  0
    -5  2
    -4  4
    -2  5
     0  5
     2  5
     4  4
     5  2
     5  0
     5 -2
     4 -4
     2 -5
     0 -5
    -2 -5
    -4 -4
    -5 -2
    ];

tic

% Gaussian blur as preprocessing as suggested in paper
img = imgaussfilt(img,sqrt(1.04),'FilterSize',5);


% Create set of translated images to use to find the responses
for i = 1:16
    t(:,:,i) = imtranslate(img,translations(i,:));
end


% Calculate sum response
for i = 1:4
    sr_many(:,:,i) = abs((t(:,:,i)+(t(:,:,i+8)) - (t(:,:,i+4)+(t(:,:,i+12)))));
end
sr = sum(sr_many,3);


% Calculate diff response
for i = 1:8
    d_many(:,:,i) = abs(t(:,:,i) - t(:,:,i+8));
end
d = sum(d_many,3);


% Calculate mean response
nm = mean(t,3);
lm = imfilter(double(img),ones([5 5])./25);
mr = abs(nm - lm);


% Calculate final score
r = sr - d - (mr * 16);

toc

% Display output image
subplot(1,2,1)
imshow(img)
subplot(1,2,2)
imshow(r,[0 Inf])


