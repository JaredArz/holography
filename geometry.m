classdef geometry
    methods(Static)
		function  amplitude = gen_rand_circles(N, num_circles, radius_min, radius_max)
			% initialize target amplitude to zeros
			amplitude = zeros(N);
			% generate random circles
			for k = 1:num_circles
				% random center positions
				x_center = randi([1, N]);
				y_center = randi([1, N]);

				% random radius within specified range
				radius = randi([radius_min, radius_max]);

				% create a grid of distances from the circle center
				[xc, yc] = meshgrid(1:N, 1:N);
				distances = sqrt((xc - x_center).^2 + (yc - y_center).^2);

				% add the circle to the target amplitude
				amplitude(distances <= radius) = 1;
			end
		end
		function  amplitude = gen_circle(N, xpos, ypos, radius)
			amplitude = zeros(N);
			[xc, yc] = meshgrid(1:N, 1:N);
			distance = sqrt(((xc-N/2) - xpos).^2 + ((yc-N/2) - ypos).^2);
			amplitude(distance <= radius) = 1;
		end
	end
end
