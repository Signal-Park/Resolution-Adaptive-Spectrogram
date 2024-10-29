function [spectrogram] = generateSpectrogram(signal, window_size, nfft, overlap)

    % Check input arguments
    if nargin < 4
        error('Not enough input arguments. Required: signal, window_size, nfft, overlap');
    end

    num_frames = floor((length(signal) - window_size - 1) / overlap);
    spectrogram = zeros(nfft, num_frames);

    for frame_idx = 1:num_frames
        start_idx = (frame_idx - 1) * overlap + 1;
        end_idx = start_idx + window_size - 1;
        frame = signal(start_idx:end_idx) .* hann(window_size);
        spectrogram(:, frame_idx) = fft(frame, nfft);
    end

    spectrogram = (flipud(fftshift(spectrogram,1)));
    spectrogram = spectrogram.*conj(spectrogram);
    
end
