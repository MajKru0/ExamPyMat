clc; clear; close all;

% Define file paths
temp1_path = '/MATLAB Drive/MK/t5_lst2023_Jun_Aug.tif';
ndvi1_path = '/MATLAB Drive/MK/t5_ndvi2024_Jul_Aug.tif';
temp2_path = '/MATLAB Drive/MK/t5_lst2024May.tif';
ndvi2_path = '/MATLAB Drive/MK/t5_ndvi2024May.tif';

% Read TIFF files
temp1 = read_geotiff(temp1_path);
ndvi1 = read_geotiff(ndvi1_path);
temp2 = read_geotiff(temp2_path);
ndvi2 = read_geotiff(ndvi2_path);

% Display images
analyze_and_plot(temp1, 'Temperature 2023 (LST)', 'image', 'parula');
analyze_and_plot(ndvi1, 'NDVI 2023', 'image', 'jet');
analyze_and_plot(temp2, 'Temperature 2024 (LST)', 'image', 'parula');
analyze_and_plot(ndvi2, 'NDVI 2024', 'image', 'jet');

% Display statistics
disp(['Temp1 min: ', num2str(min(temp1(:))), ' max: ', num2str(max(temp1(:)))])
disp(['NDVI1 min: ', num2str(min(ndvi1(:))), ' max: ', num2str(max(ndvi1(:)))])
disp(['Temp2 min: ', num2str(min(temp2(:))), ' max: ', num2str(max(temp2(:)))])
disp(['NDVI2 min: ', num2str(min(ndvi2(:))), ' max: ', num2str(max(ndvi2(:)))])

% Plot histograms
analyze_and_plot(temp1, 'Histogram Temperature 2023', 'histogram', 'b');
analyze_and_plot(ndvi1, 'Histogram NDVI 2023', 'histogram', 'r');
analyze_and_plot(temp2, 'Histogram Temperature 2024', 'histogram', 'b');
analyze_and_plot(ndvi2, 'Histogram NDVI 2024', 'histogram', 'r');

% Scatter plots
valid_mask1 = ~isnan(ndvi1) & ~isnan(temp1);
analyze_and_plot([ndvi1(valid_mask1), temp1(valid_mask1)], 'Scatter Plot NDVI vs LST (2023)', 'scatter', 'm');

valid_mask2 = ~isnan(ndvi2) & ~isnan(temp2);
analyze_and_plot([ndvi2(valid_mask2), temp2(valid_mask2)], 'Scatter Plot NDVI vs LST (2024)', 'scatter', 'm');

function data = read_geotiff(file_path)
    [data, R] = readgeoraster(file_path);
    data = double(data);
    data(data == -9999) = NaN;
end

function analyze_and_plot(data, title_str, plot_type, cmap)
    figure;
    switch plot_type
        case 'image'
            imagesc(data);
            colormap(cmap);
            colorbar;
            axis off;
        case 'histogram'
            histogram(data(~isnan(data)), 50, 'FaceColor', cmap);
            xlabel('Value'); ylabel('Frequency');
        case 'scatter'
            scatter(data(:,1), data(:,2), 10, cmap, 'filled');
            xlabel('NDVI'); ylabel('Temperature (LST)');
    end
    title(title_str);
    saveas(gcf, [title_str, '.png']);
end