channelID = 2167048;
readAPIKey = 'KB1VZF9W6LG7SXXW';
numPoints = 240;
data = thingSpeakRead(channelID, 'ReadKey', readAPIKey, 'NumPoints', numPoints);
f1 = data(:, 1);

field1 = f1(~isnan(f1));

minVal = min(field1);
meanVal = round(mean(field1));
maxVal = max(field1);

values = [minVal, meanVal, maxVal];
names = {'Min', 'Mean', 'Max'};
for i = 1:length(values)
    text(i, values(i), num2str(values(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')
end

hexColor = '#7E2F8E';
rgbColor = sscanf(hexColor(2:end),'%2x',[1,3])/255;

bar = bar(values, 'FaceColor', rgbColor);
set(gca, 'XTickLabel',names, 'XTick',1:numel(names))

ylim([770 840]);

title('Histogram of Min, Mean, and Max');
ylabel('Value');

