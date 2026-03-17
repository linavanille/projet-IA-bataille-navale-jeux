Unit ToursJeu;


INTERFACE

uses
Sysutils, Crt, Commun;


procedure tirIntelligent(var grille:Grid; var tailleV, nbTouches,taille, x, y, scoreJoueur, scoreIA: Integer;var finJoueur: Boolean);
procedure tirJoueur(var grilleIA, grilleJoueur: Grid; taille, tailleV: Integer; var vaisseauxRestants, scoreJoueur, scoreIA: Integer;var finIA: Boolean);

IMPLEMENTATION

procedure tirHasard(var taille,tailleV:Integer;var grille:Grid; var x: Integer;var y: Integer); //L'IA tire au hasard sur le plateau Joueur
begin
Randomize;
repeat
		x := Random(taille)+2;
		y:= Random(taille)+2;
until grille[x,y].tir=False;	//L'IA ne doit viser qu'aux endroits ou aucun tir n'est effectué;
ModifiePlateau(x,y,grille);		//On tire sur la case de coordonnées (x,y)
initialisation(grille,x,y,tailleV);	//Définit la taille du vaisseau touché (dans le cas où il y en aurait rien)
end;

procedure strategie(var grille: Grid; var x, y,  nbTouches,Xstrat,Ystrat,tailleV: Integer);	//Permet à l'IA ne rechercher une case touchée autour de celle actuelle
begin
//Initialisation (On reste sur la même case de tour en tour jusqu'à ce qu'une case voisine soit touchée)
Xstrat:=x;
Ystrat:=y;

	//Si la case de gauche a déjà été visée, alors la case visée sera celle du haut
	if (grille[x-1,y].tir) then
	begin
		Xstrat:=x;
		Ystrat:=y-1;
		
		//Si la case du haut a déjà été visée, alors la case visée sera celle de droite
		if (grille[x,y-1].tir)  then
		begin
			Xstrat:=x+1;
			Ystrat:=y;
			
			//Si la case de droite a déjà été visée, alors la case visée sera celle du bas
			if (grille[x+1,y].tir)  then
			begin
				Ystrat:=y+1;
				Xstrat:=x;
			end
			else //Si la  case du haut a été visée mais pas celle de droite, alors la case visée sera celle de droite
			begin
			Xstrat:=x+1;
			Ystrat:=y;
			end
		end
		else //Si la  case de gauche a été visée mais pas celle du haut, alors la case visée sera celle du haut
		begin
		Ystrat:=y-1;
		Xstrat:=x;
		end
	end
	else //Si la  case de gauche n'a pas été visée, alors la case visée est celle de gauche
	begin
	Xstrat:= x-1;
	Ystrat:=y;
	end;
	
	if (not grille[Xstrat,Ystrat].tir) then	//On verifie que la case visée n'a pas déjà été visée
	begin
		ModifiePlateau(Xstrat,Ystrat,grille); //On tire sur la case visée
		
		//Si un vaisseau est touchée sur cette case alors elle deviendra la prochaine case autour de laquelle effectuer cette stratégie
		if grille[Xstrat,Ystrat].touche then	
		begin
			 nbTouches:= nbTouches+1;	//Compte le nombre de parties du vaisseau touché
			x:=Xstrat;				//La case visée devient la case autour de laquelle on effectue la stratégie
			y:=Ystrat;
			gotoxy(1,2);
			writeln('Votre vaisseau a ete touche !');
		end
		else
			writeln('Vous avez eu chaud ! Mais pas d''egratinures');
	end;
end;


procedure destroyer( nbTouches:Integer;var x,y : Integer; grille:Grid;tailleV:Integer);//Stratégie spéciale destroyer, si la case centrale est touchée en premier, on  cherche à réitérer la stratégie autour de la case centrale lors du 3e tir
begin
if nbTouches=2 then	//On se place dans le cas où deux parties du vaisseaux on déjà était touchée
	begin
	if ((grille[x-1,y].tir)and(grille[x+1,y].tir)and(grille[x,y-1].tir)and(grille[x,y+1].tir)) then	//Une fois que l'on a tiré sur toutes les cases voisines (donc aucune touchée)
	begin	
		if ((not grille[x-1,y].touche) and (not grille[x+1,y].touche)) then	//Cas où le destroyer est orienté verticalement
		begin
			if not(grille[x,y-1].touche) then	//Cas où l'on se trouve sur la première case du destroyer
				y:=y+1
			else if not(grille[x,y+1].touche) then //Cas où l'on se trouve sur la dernière case du destroyer
				y:=y-1;
		end;
		
		if ((grille[x,y-1].touche=False) and (grille[x,y+1].touche=False)) then	//Cas où le vaisseau est orienté horizontalement
		begin
			if not(grille[x-1,y].touche) then	//Cas où l'on se trouve sur la première case du destroyer 
				x:=x+1
			else if not(grille[x+1,y].touche) then	//Cas où l'on se trouve sur la dernière case du destroyer
				x:=x-1;
		end;
	end;
end;
end;

procedure destructionVaisseau(var x,y : Integer;var grille:Grid; var tailleV,nbTouches,taille, scoreIA: Integer);	//Annonce lorsqu'un vaisseau est abattu et permet à l'IA de tirer de nouveau aléatoirement
var Xstrat,Ystrat:Integer;
begin
Initialisation(grille,x,y,tailleV);	//Initialise la taille du type de vaisseau touché
	case tailleV of
	
	1: //Vaisseau abattu dès la première touche
	begin	
		gotoxy(1,3);
		writeln('Votre vaisseau a ete abattu!');
		nbTouches := 0;	//Le vaisseau étant abattu, on réinitialise le nombre de touches à 0
		repeat						//L'IA est redirigé vers une position aléatoire pour recommmencer à tirer au hasard
			x := Random(taille)+2;
			y:= Random(taille)+2
		until (grille[x,y].tir=False) and (grille[x,y].vaisseau<>'O');
		scoreIA := scoreIA + 500;	//Actualisation du score IA
	end;
	
	2:	//Vaisseau abattu une fois la stratégie concluante (1 tir au hasard et 1 tir stratégique concluant
	begin
		Strategie(grille,x,y,nbTouches,Xstrat,Ystrat,taille);
		if  nbTouches = 2 then
		begin
			gotoxy(1,3);
			writeln('Votre vaisseau a ete abattu!');
			nbTouches:=0;
			repeat
				x := Random(taille)+2;
				y:= Random(taille)+2
			until (grille[x,y].tir=False) and (grille[x,y].vaisseau<>'O');
			scoreIA := scoreIA + 200;
		end;
	end;
	
	3:
	begin
		destroyer( nbTouches,x,y,grille,tailleV);		//N'est effectif que dans le cas précis évoqué précedemment
		strategie(grille,x,y,nbTouches,Xstrat,Ystrat,tailleV);	//Effectue des tirs stratégiques jusquà ce que le vaisseau soit abattu
		if  nbTouches=3 then		//Le nombre de touches est égale à la taille du vaisseau donc le vaisseau est abattu
		begin
			gotoxy(1,3);
			writeln('Votre vaisseau a ete abattu!');
			nbTouches:=0;
			repeat
				x := Random(taille)+2;
				y:= Random(taille)+2
			until (grille[x,y].tir=False) and (grille[x,y].vaisseau<>'O');
			scoreIA := scoreIA + 100;
		end;
	end
	else
	TirHasard(taille,tailleV,grille,x,y);
end;
end;

procedure detectionFinJoueur(grilleJoueur: Grid; taille: Integer; var finJoueur: Boolean);
var
  i, j: Integer;
begin
  finJoueur := True;

  for i := 1 to taille + 2 do
  begin
    j := 1; // Réinitialiser la valeur de j à chaque itération de la boucle externe

    while (j <= taille + 2) and finJoueur do
    begin
      if grilleJoueur[i, j].vaisseau = 'O' then
        finJoueur := False;
        
      j := j + 1;
    end;
  end;
end;

procedure tirIntelligent(var grille:Grid; var tailleV,nbTouches,taille,x, y, scoreJoueur, scoreIA: Integer;var finJoueur: Boolean); //Tirs de l'IA
begin
	If grille[x,y].touche then		//Si un vaisseau est touché, on applique destructionVaisseau
	begin
		destructionVaisseau(x,y,grille,tailleV,nbTouches,taille, scoreIA);
	end
	else
	begin
	nbTouches:=0;					
	TirHasard(taille,tailleV,grille,x,y);	//On tire au hasard tant qu'un vaisseau n'est pas touché
	if grille[x,y].touche then
	begin
		nbTouches:=1;						//Si un vaisseau est touché aléatoirement, on actualise le nombre de touches à 1
		gotoxy(1,2);
		writeln('Votre vaisseau a ete touche !');
	end
	else
	begin
		gotoxy(1,2);
		writeln('Vous avez eu chaud ! Mais pas d''egratinures');
	end
	end;
	affichagePlateaux(grille,taille,scoreJoueur);
	detectionFinJoueur(grille,taille,finJoueur);	//On vérifie si le jeu s'arrêtera à la fin de ce tour
end;

procedure affichagePlateauIA(var grille: Grid; taille, scoreIA: Integer);	//Affiche l'historique de tir du joueur
var
	i, j: Integer;
begin
	gotoxy(27,4);
	write('SCORE: ', scoreIA);
	for i := 1 to taille + 2 do
	begin
		gotoxy(28, 5 + i);
		for j := 1 to taille + 2 do
			write(grille[j][i].historique, ' ');
	end;
	writeln();
end;


function estVaisseauDetruit(grille: Grid; x, y, taille: Integer): Boolean; 
var
	i, startX, endX, startY, endY: Integer;
begin
	estVaisseauDetruit := True;

	startX := x; endX := x; startY := y; endY := y;

	{pour un vaisseau orienté horizontalement, le début et la fin sont repérés}
	while (startX > 1) and (grille[startX - 1, y].vaisseau = 'O') do
		startX := startX-1;

	while (endX < taille) and (grille[endX + 1, y].vaisseau = 'O') do
		endX:= endX + 1;


	{pour un vaisseau orienté verticalement, le début et la fin sont repérés}
	while (startY > 1) and (grille[x, startY - 1].vaisseau = 'O') do
		startY := startY-1;
		
	while (endY < taille) and (grille[x, endY + 1].vaisseau = 'O') do
		endY:= endY + 1;

	{le vaisseau est parcouru du début à la fin, tant que toutes les cases n'ont pas été touchées, alors il n'est pas détruit}
	for i := startX to endX do
		if not grille[i, y].touche then
		begin
			estVaisseauDetruit := False;
			break;
		end;

	for i := startY to endY do
		if not grille[x, i].touche then
		begin
			estVaisseauDetruit := False;
			break;
		end;
end;

procedure majScoreJoueur(grille: Grid; taille,tailleV, x,y: Integer; var scoreJoueur: Integer);
begin
	initialisation(grille,x,y,tailleV);
	case tailleV of
		1: scoreJoueur := scoreJoueur + 500; {+500 points si un aéroglisseur est détruit}
		2: scoreJoueur := scoreJoueur + 200; {+200 points si un aéroglisseur est détruit}
		3: scoreJoueur := scoreJoueur + 100; {+100 points si un destroyer est détruit}
	end;
end;

procedure detectionFinIA(grille: Grid; taille: Integer; var finIA: Boolean);
var
  i, j: Integer;
begin
  finIA := True;

  for i := 1 to taille + 2 do
  begin
    j := 1; // Réinitialiser la valeur de j à chaque itération de la boucle externe

    while (j <= taille + 2) and finIA do
    begin
      if grille[i, j].vaisseau = 'O' then
        finIA := False;
        
      j := j + 1;
    end;
  end;
end;

procedure tirJoueur(var grilleIA, grilleJoueur: Grid; taille, tailleV: Integer; var vaisseauxRestants, scoreJoueur, scoreIA: Integer;var finIA:Boolean);
var
	cordXTir, cordYTir: Integer;
	cordYL: Char;
begin
	gotoxy(1,4);
	affichagePlateaux(grilleJoueur, taille, scoreJoueur);
	affichagePlateauIA(grilleIA, taille, scoreIA);
	writeln('A votre tour de tirer !');

	repeat
		writeln('Entrez la case de tir');
		readln(cordYL, cordXTir);
		cordYTir := Ord(cordYL) - 64;

		if ((cordXTir +1<= 1) or (cordXTir > taille) or (cordYTir+1 <= 1) or (cordYTir > taille)) then
		begin
			ClrScr();
			gotoxy(1,3);
			writeln('Coordonnées de tir invalides. Veuillez réessayer.');
		end
	until (cordXTir +1> 1) and (cordXTir <= taille) and (cordYTir+1 > 1) and (cordYTir <= taille);
	ClrScr();


	if grilleIA[cordXTir+1, cordYTir+1].vaisseau = 'O' then 
	begin
		writeln('Vous avez touché un vaisseau ennemi !');
		gotoxy(1,4);
		grilleIA[cordXTir+1, cordYTir+1].touche := True;
		grilleIA[cordXTir+1, cordYTir+1].historique := 'X'; {la case du vaisseau touché est remplacée par un X}
		modifiePlateau(cordXTir+1,cordYTir+1,grilleIA);
		if estVaisseauDetruit(grilleIA, cordXTir+1, cordYTir+1, taille) then 
		begin
			gotoxy(1,3);
			write('Le vaisseau a été détruit !');
			vaisseauxRestants := vaisseauxRestants - 1; {mise à jour du compteur de vaisseaux détruits}
			detectionFinIA(grilleIA,taille,finIA); {les tirs se poursuivent jusqu'à ce qu'un des deux joueurs détruit l'ensemble des vaisseaux}
			majScoreJoueur(grilleIA, taille, tailleV, cordXTir+1, cordYTir+1, scoreJoueur); {à la fin de la partie, le score du joueur est mis à jour en fonction des vaisseaux qu'il a détruit}
		end;
	end
	else
	begin
		gotoxy(1,3);
		writeln('Vous avez tiré dans le vide.');
		grilleIA[cordXTir+1, cordYTir+1].historique := '#'; {si le tir est raté, la case vide est remplacée par un #}
	end;
	
	{les deux plateaux sont affichés ainsi que les deux scores obtenus par le joueur et par l'IA}
	
	affichagePlateaux(grilleJoueur, taille, scoreJoueur); 
	affichagePlateauIA(grilleIA, taille, scoreIA);
end;

end.
