clear; close all

%% Load data from the example dataset
% - falling_example_data.mat: Contains projected range-time (PRT) data for falling activity
% - limping_example_data.mat: Contains projected range-time (PRT) data for limping activity
% - Please refer to the paper mentioned in the README for details on the 
%   data preprocessing process.
load('falling_example_data.mat')

%% Parameter Initialization
% - windowSize: Length of the window used in STFT
% - nfft: Number of points for Discrete Fourier Transform (DFT)
% - fmax: Maximum frequency (in Hz). Determined by the chirp repetition 
%         frequency of the FMCW radar.
% - inputDim: Dimension size for the spectrogram after processing, 
%             adjusted to match the input size required by the classifier
% - numFilter: Number of filters in the filterbank for RA spectrogram generation.
%              The frequency domain length of the RA spectrogram is set to be twice the numFilter.
windowSize = 128;
nfft = 2^11;
fmax = 1600;
inputDim = 128;
numFilter = 64;

%% Generate conventional spectrogram
[SPEC] = generateSpectrogram(PRT, windowSize, nfft, floor(windowSize/2)-1);

%% Generate RA spectrogram
[RASPEC, energyDist] = generateRASpectrogram(SPEC, numFilter, nfft, fmax);

%% Preprocess spectrograms for visualization
% - inLogSPEC: Log-scaled conventional spectrogram
% - inLogRASPEC: Log-scaled RA spectrogram
inLogSPEC = (imresize(10*log10(SPEC), [inputDim inputDim]));
inLogRASPEC = 10*log10(RASPEC);

%% Plot
figure (1); 
imagesc(1:inputDim, linspace(-fmax, fmax, inputDim), inLogSPEC);
clim([75 max(inLogSPEC(:))]); colormap(jet);
xlabel('Time Index'); ylabel('Doppler Frequency (Hz)'); 
set(gca, 'YDir', 'normal');

figure (2); 
imagesc(1:inputDim, linspace(-fmax, fmax, inputDim), inLogRASPEC);
clim([88 max(inLogRASPEC(:))]); colormap(jet);
xlabel('Time Index'); ylabel('Doppler Frequency (Hz)'); 
set(gca, 'YDir', 'normal');
