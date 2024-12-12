% Gerchberg-Saxton Algorithm for Computer-Generated Holography

N = 480;              % Size of the hologram (NxN pixels)
iterations = 50;      % Number of iterations

load mandrill.mat;
colormap(map)
t_mask = ind2gray(X, map);
object = t_mask(1:N, 1:N);

target_amp = geometry.gen_rand_circles(N,3,10,15);
%target_amp = geometry.gen_circle(N,0,0,30);
%target_amp = object; % use monkey


hologram = zeros(N);
input_amp = ones(N);
% Gerchberg-Saxton Iterations
for iter = 1:iterations
    % Forward propagation (Fourier Transform)
    field = input_amp .* exp(1i * hologram);

    % Enforce target amplitude in Fourier domain
    F_field = fftshift(fft2(ifftshift(field)));
    F_field = target_amp .* exp(1i * angle(F_field));

    % Backward propagation (Inverse Fourier Transform)
    field = fftshift(ifft2(ifftshift(F_field)));

    % Update phase while keeping input amplitude
    hologram = angle(field);
end

% Visualization
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
imagesc(hologram);
title('Hologram Phase Pattern');
axis image off;
colormap gray;
colorbar;

% Simulate reconstruction by applying the hologram
reconstructed_field = input_amp .* exp(1i * hologram);
reconstructed_F_field = fftshift(fft2(ifftshift(reconstructed_field)));
reconstructed_amp = abs(reconstructed_F_field);

% Display reconstructed amplitude
subplot(2,2,4);
imagesc(reconstructed_amp);
title('Reconstructed Amplitude');
axis image off;
colormap gray;
colorbar;
