
filename = 'Extract_Lubin_t3_TableToExcel.csv';


if exist(filename, 'file') == 2
    % Read CSV file
    data = readmatrix(filename);
    

    deltaH = data(:, 18);


    deltaH = deltaH(~isnan(deltaH));


    mean_error = mean(deltaH);
    std_dev = std(deltaH);
    rmse = sqrt(mean(deltaH.^2));


    fprintf('Mean Error: %.3f m\n', mean_error);
    fprintf('Standard Deviation: %.3f m\n', std_dev);
    fprintf('RMSE: %.3f m\n', rmse);


    figure;
    
    % Histogram
    subplot(1,2,1);
    histogram(deltaH, 50, 'FaceColor', 'b', 'EdgeColor', 'k');
    title('Elevation Difference Histogram');
    xlabel('ΔH (m)');
    ylabel('Frequency');
    grid on;

    % Scatter Plot
    subplot(1,2,2);
    scatter(1:length(deltaH), deltaH, '.', 'MarkerEdgeColor', 'r');
    title('Elevation Differences');
    xlabel('Point Index');
    ylabel('ΔH (m)');
    grid on;

else
    error('File "%s" not found. Please check the filename and path.', filename);
end
