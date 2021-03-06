clc
clear
warning off

in_dir = '../sRGB';
target_dir = '../P3';
out_dir = '../From_sRGB_to_P3_Global';
in_ext = '.jpg';
target_ext = '.tif';
in_images = dir(fullfile(in_dir,['*' in_ext]));
in_images = fullfile(in_dir,{in_images(:).name});
target_images = dir(fullfile(target_dir,['*' target_ext]));
target_images = fullfile(target_dir,{target_images(:).name});

for i = 1 : length(in_images)
    fprintf('Processing (%d/%d) ... \n',i,length(in_images));   
    [~,name,ext] = fileparts(in_images{i});
    in_img = im2double(imread(in_images{i}));
    target_img = im2double(imread(target_images{i}));
    %% Perform Global Mapping
    % Subsmpaling
    sub_sample_size = 150;
    sub_in_img = subsampling(in_img, sub_sample_size);
    sub_target_img = subsampling(target_img, sub_sample_size);
    % Compute mapping on subsamples
    M = computeMapping(sub_in_img, sub_target_img);
    reconstructed = applyMapping(in_img, M);
    % Clipping
    reconstructed(reconstructed > 1) = 1;
    reconstructed(reconstructed < 0) = 0;
    if strcmpi(target_ext,'.tif') == 1 || strcmpi(target_ext,'.png') == 1
        imwrite(im2uint16(reconstructed),fullfile(out_dir,[name target_ext]));
    else
        imwrite(reconstructed,fullfile(out_dir,[name target_ext]));
    end
end