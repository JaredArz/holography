ps = 0.15; 		% pixel size (x,y,z) in object space (micron)
lambda = 0.532; % central wavelength (micron)
NA = 1; 		% numerical aperture of imaging and detection lens.

load mandrill.mat % goes to variable X
colormap(map)
t_mask = ind2gray(X,map);
object = t_mask(1:480, 1:480);

z = [0:1:10 , 10:-1:0]; % set of defocus distances (micron)
for i = 1:length(z)
    [A,phase] = propagate(object, z(i), lambda, NA, ps, "fresnel");

	% plot intensity of image 
    subplot(1,2,1);
	imagesc(A.^2); 
	colormap gray;
    axis off;
    axis tight;
	title('Image at distance',z(i));

    subplot(1,2,2);
	msk = logical(zeros(size(phase)));
	msk([1:5,end-5:end],:) = 1;
	msk(:,[1:5,end-5:end]) = 1;
	phase = phase - mean(phase(msk));
    imagesc(phase); clim(0+[-0.15,0.6]);
	colormap gray;
	axis off;
	axis tight;
	title('unwrapped phase component of image');

    pause(0.0001);
end
