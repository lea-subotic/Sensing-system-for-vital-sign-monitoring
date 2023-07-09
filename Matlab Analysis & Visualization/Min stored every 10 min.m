
readChannelID = 2167048;
readAPIKey = 'KB1VZF9W6LG7SXXW'; 
writeAPIKey = 'QLHDS9RBH1O82X89'; 

numPoints = 40; %svakih 15 sec podatak = 4 u minuti * 10 min
data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'NumPoints', numPoints);
field1 = data(:, 1);

minVal = min(field1);
meanVal = round(mean(field1));
maxVal = max(field1);

thingSpeakWrite(readChannelID, 'Fields', 2, 'Values', {minVal}, 'WriteKey', writeAPIKey);
