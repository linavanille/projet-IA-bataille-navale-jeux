program bataille_spatiale;

 uses Initialisation_Plateaux, ToursJeu, Mode_Chaos, MiniJeux,Commun,InterfaceHM,Sysutils, Crt;
var
 plateauJoueur, plateauIA: Grid;
 size,sizeV, cordx, cordy,countdown,tour,reste, scoreJoueur, scoreIA: Integer;
 level : Difficulte;
 finIA,finJoueur,quit,reset: Boolean;
 res, res2: String;
 
 
begin
//Initialisation des tailles et compteurs//
	countdown:=0;
	sizeV:=0;
	size:=0;
	tour:=0;
	scoreIA:=0;
	scoreJoueur:=0;

	//Affichage du titre du jeu//
	res:= 'S T A R  W A R S';
	affichageTitre(res);

	//Création des plateaux//
	initialisationPlateaux(plateauJoueur,plateauIA,size,scoreJoueur,level);
	

	//Debut de partie//
	writeln('Debut de la partie');

	repeat	
		ClrScr();						//Répète les tours jusqu'à ce qu'il y ait un gagnant ou que le joueur quitte la partie//
		tour:=tour+1;
		writeln('Tour',tour);
			if level = Chaos then
				modeChaos(size,tour,level,plateauJoueur, scoreJoueur);
		//Le joueur tire sur le plateau adversaire//
		writeln('TourJoueur');
		tirJoueur(plateauIA,plateauJoueur,size,sizeV,reste,scoreJoueur,scoreIA,finIA);
		quitterPartie(reset,quit);
		if reset then
			initialisationPlateaux(plateauJoueur,plateauIA,size,scoreJoueur,level);

		//L'IA tire sur le plateau du joueur//
		writeln('Tour Adversaire');
		tirIntelligent(plateauJoueur,sizeV,countdown,size,cordx,cordy,scoreJoueur,scoreIA,finJoueur);
		
		quitterPartie(reset,quit);	//Vérifie si le joueur veut retourner au menu ou quitter le jeu
		//Retour au menu du jeu
		if reset then
			initialisationPlateaux(plateauJoueur,plateauIA,size,scoreJoueur,level);
			
			
			if (tour mod 5 = 0) then //Lance les mini-jeux tout les cinq tours
			begin	
				res:= 'Besoin d''aide petit Padawan ?';
				affichageTitre(res);
				jouer(scoreJoueur);
				res:= 'Il est temps de reprendre le combat!';
				affichageTitre(res);
			end;
	
	until ((finIA) or (finJoueur) or (quit));	//Le jeu s'arrête lorsqu'un des deux joueurs a détruit tout les vaisseaux ou que le joueur décide de quitter
	if finIA then
		scoreJoueur:= scoreJoueur + 100  // pts de victoire
	else if finJoueur then
			scoreIA:= scoreIA + 100;
	afficherGameOver(res2, scoreIA, scoreJoueur);
	writeln('fin');
end.
