% Gerchberg-Saxton Algorithm for Error vs Iterations Plot

N = 480;              % Size of the hologram (NxN pixels)
iterations = 100;      % Number of iterations

load mandrill.mat;
colormap(map)
t_mask = ind2gray(X, map);
object = t_mask(1:N, 1:N);

[X, Y] = meshgrid(linspace(-1,1,N), linspace(-1,1,N));
R = sqrt(X.^2 + Y.^2);

num_circles = 7;           % Number of circles
radius_range = [10, 15];    % Range of circle radii in pixels

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

% Monkey image - uncomment/comment
target_amp = object/max(object(:));

% Initial phase guess (can be random or zeros)
phase = zeros(N);

% Input amplitude (uniform illumination)
input_amp = ones(N);

error_arr = zeros(1, iterations);

% Total intensity of the target (number of 1s)
target_sum = sum(target_amp(:));

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
    
    % Simulate reconstruction
    reconstructed_field = input_amp .* exp(1i * phase);
    reconstructed_F_field = fftshift(fft2(ifftshift(reconstructed_field)));
    reconstructed_amp = abs(reconstructed_F_field);
    
    % normalize
    reconstructed_amp = reconstructed_amp/max(reconstructed_amp(:));
	
	% L2 norm error
    error = sum(abs(reconstructed_amp(:) - target_amp(:)).^2);
    error_arr(iter) = error;
end

% Plot error vs iterations
figure;
plot(1:iterations, error_arr, '-o', 'LineWidth', 1.5);
xlabel('Iterations');
ylabel('L2 Norm Error');
title('L2 Norm Error vs Iterations (1 circle)'); % change title depending on image.
grid on;
