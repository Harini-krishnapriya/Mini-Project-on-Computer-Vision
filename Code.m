Path = fullfile(matlabroot,'toolbox','nnet','nndemos','nndatasets','DigitDataset');
imgs = imageDatastore(Path,'IncludeSubfolders',true,'LabelSource','foldernames');
numTrainingFiles = 650;
[imgsTrain,imgsTest] = splitEachLabel(imgs,numTrainingFiles,'randomize');
layers = [ ...
    imageInputLayer([28 28 1])
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];
options = trainingOptions('sgdm', ...
    'MaxEpochs',17,...
    'InitialLearnRate',1e-3, ...
    'Verbose',false, ...
    'Plots','training-progress');
model = trainNetwork(imgsTrain,layers,options);
YPred = classify(model,imgsTest);
YTest = imgsTest.Labels;
accuracy = sum(YPred == YTest)/numel(YTest);
plotconfusion(YTest,YPred)