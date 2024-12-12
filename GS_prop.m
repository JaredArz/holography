lambda = 0.532;
z = 10100; % microns
NA = 1;
ps = 0.15;

% GS Parameters
N = 480;              % Size of the hologram (NxN pixels)
iterations = 30;      % Number of iterations
method = "fresnel";

load mandrill.mat;
colormap(map)
t_mask = ind2gray(X, map);
target_amp = t_mask(1:N, 1:N);

hologram = zeros(N);
input_amp = ones(N);
for iter = 1:iterations
    field = input_amp .* exp(1i * hologram);

    % Forward propagation
    [A, phase] = propagate(field, z, lambda, NA, ps, method);

	F_field = A .* exp(1j * phase);
    F_field = target_amp .* exp(1i * angle(F_field));

	% Backward propogation
    [A, phase] = propagate(F_field, -z, lambda, NA, ps, method);
	field = A .* exp(1j * phase);

    % Update hologram while keeping input amplitude
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
[A, phase] = propagate(reconstructed_field, z, lambda, NA, ps, method);
reconstructed_F_field = A .* exp(1j * phase);
reconstructed_amp = abs(reconstructed_F_field);

% Display reconstructed amplitude
subplot(2,2,4);
imagesc(reconstructed_amp/max(reconstructed_amp(:)));
title('Reconstructed Amplitude');
axis image off;
colormap gray;
colorbar;
