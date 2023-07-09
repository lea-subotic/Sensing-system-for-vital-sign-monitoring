% Channel details
readChannelID = 2092782; 
writeChannelID = 2167048;
readAPIKey = 'TJUG2Q82EXCU2ERK'; 
writeAPIKey = 'QLHDS9RBH1O82X89'; 

% Key for decryption
xorKey = uint8(hex2dec('AB'));

data = thingSpeakRead(readChannelID, 'Fields', 1, 'ReadKey', readAPIKey, 'OutputFormat', 'table');


field1 = string(data.Field1(end)); 
decryptedData = 0;

if mod(strlength(field1), 2) == 0 && all(isstrprop(field1, 'xdigit'))
    disp(['Received encrypted data: ', field1]); 
    decryptedBytes = zeros(1, strlength(field1) / 2);
    
    for i = 1:2:strlength(field1)
        hexByte = field1.extractBetween(i, i+1); 
        byte = uint8(hex2dec(hexByte)); 
        decryptedByte = bitxor(byte, xorKey); 
        decryptedBytes(i/2 + 0.5) = decryptedByte;
    end

    for i = 1:length(decryptedBytes)
        decryptedData = bitshift(decryptedData, 8) + decryptedBytes(length(decryptedBytes) - i + 1); 
    end
    
    disp(['Decrypted data: ', num2str(decryptedData)]); 

    thingSpeakWrite(writeChannelID, 'Fields', 1, 'Values', {decryptedData}, 'WriteKey', writeAPIKey);
     
    data = thingSpeakRead(writeChannelID, 'Fields', 1, 'ReadKey', 'KB1VZF9W6LG7SXXW', 'OutputFormat', 'table');
    disp(data)

end
