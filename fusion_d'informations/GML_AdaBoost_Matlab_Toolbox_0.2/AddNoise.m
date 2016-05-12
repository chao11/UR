function NoisyLabels = AddNoise(Labels, percent)

NoisyLabels = Labels;

for i = 1 : length(Labels)
    if(rand(1) < percent * 0.01)
        NoisyLabels(i) = -NoisyLabels(i);
    end
end
