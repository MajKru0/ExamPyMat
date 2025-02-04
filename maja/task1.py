import rasterio
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

def analyze_and_plot(data, title, plot_type, cmap='coolwarm', color='blue', save_path=None):
    plt.figure(figsize=(6, 5))
    
    if plot_type == 'image':
        plt.imshow(data, cmap=cmap, interpolation='bilinear')
        plt.colorbar()
        plt.axis('off')
    elif plot_type == 'histogram':
        clean_data = data[np.isfinite(data)].flatten()
        if clean_data.size == 0:
            print(f"Warning: No valid data for {title}")
            return
        plt.hist(clean_data, bins=50, color=color, alpha=0.6, edgecolor='black')
        plt.xlabel("Value")
        plt.ylabel("Frequency")
    elif plot_type == 'scatter':
        x, y = data
        sns.scatterplot(x=x, y=y, alpha=0.5, edgecolor=None, color=color)
        plt.xlabel("NDVI")
        plt.ylabel("Temperature (LST)")
    
    plt.title(title)
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
    plt.show()

def read(file_path):
    with rasterio.open(file_path) as dataset:
        data = dataset.read(1).astype(np.float32)
        data[data == dataset.nodata] = np.nan
        return data

temp1_path = r'C:\MK\Data\t5_lst2023_Jun_Aug.tif'
ndvi1_path = r'C:\MK\Data\t5_ndvi2024_Jul_Aug.tif'
temp2_path = r'C:\MK\Data\t5_lst2024May.tif'
ndvi2_path = r'C:\MK\Data\t5_ndvi2024May.tif'

temp1 = read(temp1_path)
ndvi1 = read(ndvi1_path)
temp2 = read(temp2_path)
ndvi2 = read(ndvi2_path)

analyze_and_plot(temp1, "Temperature 2023 (LST)", 'image', cmap='coolwarm', save_path='temp1_new.png')
analyze_and_plot(ndvi1, "NDVI 2023", 'image', cmap='cubehelix', save_path='ndvi1_new.png')

analyze_and_plot(temp2, "Temperature 2024 (LST)", 'image', cmap='coolwarm', save_path='temp2_new.png')
analyze_and_plot(ndvi2, "NDVI 2024", 'image', cmap='cubehelix', save_path='ndvi2_new.png')

analyze_and_plot(temp1, "Histogram Temperature 2023", 'histogram', color='darkblue', save_path='hist_temp1_new.png')
analyze_and_plot(ndvi1, "Histogram NDVI 2023", 'histogram', color='darkred', save_path='hist_ndvi1_new.png')
analyze_and_plot(temp2, "Histogram Temperature 2024", 'histogram', color='darkblue', save_path='hist_temp2_new.png')
analyze_and_plot(ndvi2, "Histogram NDVI 2024", 'histogram', color='darkred', save_path='hist_ndvi2_new.png')

valid_mask1 = (~np.isnan(ndvi1)) & (~np.isnan(temp1))
analyze_and_plot((ndvi1[valid_mask1], temp1[valid_mask1]), "Scatter Plot NDVI vs LST (2023)", 'scatter', color='purple', save_path='scatter_2023_new.png')

valid_mask2 = (~np.isnan(ndvi2)) & (~np.isnan(temp2))
analyze_and_plot((ndvi2[valid_mask2], temp2[valid_mask2]), "Scatter Plot NDVI vs LST (2024)", 'scatter', color='purple', save_path='scatter_2024_new.png')
