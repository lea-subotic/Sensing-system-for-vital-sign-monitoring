% ID kanala i API kljuc
channelID = 2167048;
readAPIKey = 'KB1VZF9W6LG7SXXW';

% broj tocaka iz kanala
numPoints = 240;

% citanje podataka iz kanala 
data = thingSpeakRead(channelID, 'ReadKey', readAPIKey, 'NumPoints', numPoints);

% izdvajanje prvog polja podataka iz pročitanog
field1 = data(:, 1);

% Remove NaN values
field1_noNaN = field1(~isnan(field1));


% calculate moving average with window size of 3
window_size = 7;
field1_moving_avg = movmean(field1_noNaN, window_size);

% plot original data
plot(field1_noNaN, 'Color', '#0072BD', 'LineWidth', 0.25);
hold on;

% plot moving average
plot(field1_moving_avg, 'Color', '#A2142F', 'LineWidth', 2);

grid;

% oznacavanje osi
xlabel('Data');
ylabel('Sensor Value');
