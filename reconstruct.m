ps = 0.15; 		% pixel size (x,y,z) in object space (micron)
lambda = 0.532; % central wavelength (micron)
NA = 1; 		% numerical aperture of imaging and detection lens.

%DEFINE A HOLOGRAM GENERATED ELSEWHERE
hologram = zeros(480,480);
method = "fresnel";
zmax = 9995;
zmin = 101000;
zstep = 5;

pause_time = 0.0001;

z = [zmin:zstep:zmax]; % set of defocus distances (micron)
for i = 1:length(z)
    object = 1 .* exp(1j * hologram);
    [A, phase] = propagate(object, z(i), lambda, NA, ps, method);
    reconstructed_F_field = A .* exp(1j * phase);
    reconstructed_amp = abs(reconstructed_F_field);

	% plot intensity of image 
    subplot(1,2,1);
	imagesc(reconstructed_amp); 
	colormap gray;
    axis off;
    axis tight;
	title('amplitude of Image at distance',z(i));

    subplot(1,2,2);
	msk = logical(zeros(size(phase)));
	msk([1:5,end-5:end],:) = 1;
	msk(:,[1:5,end-5:end]) = 1;
	phase = phase - mean(p(msk));
    imagesc(phase); clim(0+[-0.15,0.6]);
	colormap gray;
	axis off;
	axis tight;
	title('unwrapped phase component of image');

    pause(pause_time);
end
