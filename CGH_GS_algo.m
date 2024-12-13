% Gerchberg-Saxton Algorithm for Computer-Generated Holography

% Parameters
N = 480;              % Size of the hologram (NxN pixels)
iterations = 3;      % Number of iterations

[X, Y] = meshgrid(linspace(-1,1,N), linspace(-1,1,N));
R = sqrt(X.^2 + Y.^2);

%target_amp = double(R < 0.5);  % Circle with radius 0.5

load mandrill.mat;
colormap(map)
t_mask = ind2gray(X, map);
object = t_mask(1:N, 1:N);

% multiple random circles
num_circles = 3;           % Number of circles
radius_range = [25, 30];    % Range of circle radii in pixels

% Initialize target amplitude to zeros
target_amp = zeros(N);

% Generate random circles
for k = 1:num_circles
    % Random center positions
    x_center = randi([1, N]);
    y_center = randi([1, N]);

    % Random radius 
    radius = randi(radius_range);

    [Xc, Yc] = meshgrid(1:N, 1:N);
    distances = sqrt((Xc - x_center).^2 + (Yc - y_center).^2);

    % Add the circle to the target amplitude
    target_amp(distances <= radius) = 1;
end

% Uncomment for mandrill
%target_amp = object;

% Initial phase guess (can be random or zeros)
phase = zeros(N);

% Input amplitude (uniform illumination)
input_amp = ones(N);

% GS
for iter = 1:iterations
    % Forward propagation (Fourier Transform)
    field = input_amp .* exp(1i * phase);
    F_field = fftshift(fft2(ifftshift(field)));
    
    % Enforce target amplitude in Fourier domain
    F_phase = angle(F_field);
    F_field = target_amp .* exp(1i * F_phase);
    
    % Backward propagation (Inverse Fourier Transform)
    field = fftshift(ifft2(ifftshift(F_field)));
    
    % Update phase while keeping input amplitude
    phase = angle(field);
end

% The resulting 'phase' matrix is the hologram phase pattern


figure;
% Display target amplitude
subplot(2,2,1);
imagesc(target_amp);
title('Target Amplitude');
axis image off;
colormap gray;
colorbar;

% Display initial input amplitude
subplot(2,2,2);
imagesc(input_amp);
title('Input Amplitude');
axis image off;
colormap gray;
colorbar;

% Display hologram phase pattern
subplot(2,2,3);
imagesc(phase);
title('Hologram Phase Pattern');
axis image off;
colormap gray;
colorbar;

% Simulate reconstruction by applying the hologram
reconstructed_field = input_amp .* exp(1i * phase);
reconstructed_F_field = fftshift(fft2(ifftshift(reconstructed_field)));
reconstructed_amp = abs(reconstructed_F_field);

% Display reconstructed amplitude
subplot(2,2,4);
imagesc(reconstructed_amp);
title('Reconstructed Amplitude');
axis image off;
colormap gray;
colorbar;
