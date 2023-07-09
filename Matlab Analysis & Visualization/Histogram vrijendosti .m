readChannelID = 2167048; 
FieldID = 1; 
readAPIKey = 'KB1VZF9W6LG7SXXW'; 
   
tempF = thingSpeakRead(readChannelID,'Fields',FieldID,...
'NumMinutes',10*60, 'ReadKey',readAPIKey); 
   
histogram(tempF); 
xlabel('Sensor value'); 
ylabel('Number of Each value'); 