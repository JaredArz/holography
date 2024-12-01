function [A,phase] = propagate(object, z, lambda, NA, ps, method)
	% takes transmitted light at the 0 plane, z distance to propagate,
	% numerical aperture of observation system, pixel size of object, and 
	% a method of propogation (fresnel or angular spectrum)
	%
	% returns ampltiude and phase components of observed image.
    function [X] = fft2_DC(x)
    X=fftshift(fft2(ifftshift(x)));
    end

    function [x] = ifft2_DC(X)
    x=fftshift(ifft2(ifftshift(X)));
    end

    spectrum = fft2_DC(object);
    N = single(size(object,1));    % lateral pixel dimension of object
    dfx = single(1/(N*ps));        % Fourier spacing of axis
    fx = single(dfx*(-N/2:N/2-1)); % 1D padded axis in fx
    [fxx,fyy] = meshgrid(fx,fx);   % 2D padded grid in fx/fy

	if method == "fresnel"
		H = exp(1j*2*z*pi/lambda) .* exp(-1j*pi*z.*(fxx.^2 + fyy.^2));
	else
		H = exp(1j*2*pi*z.*sqrt(1/lambda^2-fxx.^2-fyy.^2));
	end
	img = ifft2_DC( H .* spectrum .* (fxx.^2+fyy.^2<(NA/lambda)^2) );

    A = abs(img);

    phase = unwrap_phase(angle(img));
end
