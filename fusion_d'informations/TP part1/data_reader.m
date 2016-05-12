function [ data ] = data_reader( filename )
%data_reader permet de lire des données dans les fichiers en supprimant les
%données de première ligne
   

    % lire des donnees dans le fichier
    [fiche_original,~]=importdata(filename);

    % enregistrement des donnes utiles dans un nouveau fichier
    fileID = fopen('data_temp.txt','w');
    % supprimer la premiere ligne qui ne contient pas de donnees utiles
    fprintf(fileID,'%s\r\n',fiche_original{2:end});
    fclose(fileID);

    % lire et traiter les donnees utile dans le fichier temporaire
    filename = 'data_temp.txt';
    fileID = fopen(filename,'rt');
    data = textscan(fileID,'%f%f%f%f%f%f%f%f%f%f%f', 'Whitespace', ':[]');
    data = cell2mat(data);
    fclose(fileID);

end

