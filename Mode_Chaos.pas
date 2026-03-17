unit Mode_Chaos;

INTERFACE

uses Commun,Crt;

procedure modeChaos(taille,nbTours:Integer;niveau:Difficulte;var grille:Grid; scoreJoueur: Integer);


IMPLEMENTATION

procedure chuteDeMeteorites(taille,nbTours:Integer;var grille:Grid);//Tir sur des zones (chute de météorites) du plateau Joueur qui grandissent tout les deux tours
var nbTirs,cordX,cordY,degats,i,j: Integer;
begin
randomize;
nbTirs:=0;
writeln('Attention ! Des méteorites !');
	while nbTirs<5 do	//toujours quatre météorites tombent
	begin
		
		//Choisis des coordonées aléatoires de chute pour chaque météorite et vérifie que l'on a pas déjà tiré à cet emplacement
		repeat
			cordX := Random(taille)+2;
			cordY:= Random(taille)+2
		until grille[cordX,cordY].tir=False;
		
		degats:= nbTours div 2;	//La grandeur des météorites est proportionnelle au nombre de tours
		for i:=cordX-degats+1 to (cordX+degats-1) do
		begin
			for j:=cordY-degats+1 to (cordY+degats-1) do
			begin
				modifiePlateau(i,j,grille);	//Tire sur les coordonnées avec une zone d'impact de côté degats + 1 
			end;
		end;
	nbTirs:=nbTirs+1;	//Passe au tir suivant jusqu'au 4e tir
	end;
end;

procedure modeChaos(taille,nbTours:Integer;niveau:Difficulte;var grille:Grid; scoreJoueur: Integer);//Applique les spécificités du mode
begin
	if ((nbTours=2)or(nbTours=4)) then
		chuteDeMeteorites(taille,nbTours,grille)	//Le mode Chaos visant à avoir une partie très courte, on applique chute de météorite au tours 2 et 4;
	else if nbTours>4 then							//Une fois les météorites toutes tombées, la galaxie redevient paisible
	writeln('la galaxie redevient paisible');
end;

end.
