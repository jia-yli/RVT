import h5py
import numpy as np

def process_h5_file(h5_file_path, output_file_path):
  with h5py.File(h5_file_path, 'r') as h5f:
    # Extracting the relevant datasets
    divider = h5f['events/divider'][()]
    height = h5f['events/height'][()]
    width = h5f['events/width'][()]
    p = h5f['events/p'][:]
    t = h5f['events/t'][:]
    x = h5f['events/x'][:]
    y = h5f['events/y'][:]

    # Create a structured array
    dt = np.dtype([('x', 'u2'), ('y', 'u2'), ('p', 'i2'), ('t', 'i8')])
    structured_array = np.zeros(p.size, dtype=dt)
    structured_array['x'] = x
    structured_array['y'] = y
    structured_array['p'] = p
    structured_array['t'] = t

    # Save the array and additional values in a format suitable for env2
    np.savez(output_file_path, events=structured_array, divider=divider, height=height, width=width)

# Usage
process_h5_file('/dataset/prophesee-gen1/raw/train/18-03-29_13-23-55_61500000_121500000_td.dat.h5', './output/prophesee-gen1-train-18-03-29_13-23-55_61500000_121500000_td.npz')

