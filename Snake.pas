unit Snake;

INTERFACE

uses CRT;

procedure partieSerpent(var score: Integer); 

IMPLEMENTATION

const LIGNES = 10;
	  COLONNES = 20;
	  UpKey = #72;
	  DownKey = #80;
	  LeftKey = #75;
	  RightKey = #77;
	  
Type Tab = array [0..COLONNES, 0..LIGNES] of Char;

Type Coord = record
  X, Y: Integer;
end;

Type Direction = (Haut, Bas, Gauche, Droite);

Type MonSerpent = record
  tete: Coord;
  queue: array [1..100] of Coord;
  dirActuelle: Direction;
  longueur: Integer;
end;


procedure initialiseGrille(var grille: Tab);  //  initialise les cases du plateau pour qu'elles soient vides 
var
  i, j: Integer;
begin
  for i := 1 to LIGNES  do
  begin
    for j := 1 to COLONNES  do
    begin
      grille[j, i] := ' ';
    end;
  end;
end;

procedure positionPomme(var grille: Tab; var pomme: Coord);  // affecte une position aléatoire à une pomme
begin
  Randomize;
  repeat
    pomme.X := Random(COLONNES - 1) + 1;
    pomme.Y := Random(LIGNES - 1) + 1;
  until grille[pomme.X, pomme.Y] = ' ';			// la case initiale doit etre vide
  grille[pomme.X, pomme.Y] := 'P';
end;

procedure initialiseSerpent(var grille: Tab; var serpent: MonSerpent); // place le serpent a sa position de départ
begin
  serpent.tete.X := COLONNES div 2; 	// placé au milieu de la grille
  serpent.tete.Y := LIGNES div 2;
  serpent.longueur := 1;		// constitué que de sa tete
  serpent.dirActuelle := Droite;
  grille[serpent.tete.X, serpent.tete.Y] := 'O';
end;

procedure afficheGrille(grille: Tab; serpent: MonSerpent; pomme: Coord; compteur: Integer); // affiche la grille à l'ecran avec les positions du serpent et de la pomme 
var
  i, j, k: Integer;
  estCorps: Boolean;
begin
	writeln('Pommes mangées: ', compteur);
	for i := 1 to LIGNES + 1 do      // limitations verticales du plateau 
	begin
		for j := 1 to COLONNES + 1 do     // limitations horizontales du plateau 
		begin
			if (i = 1) or (i = LIGNES + 1) or (j = 1) or (j = COLONNES + 1) then     
				write('#')
			else
			begin
				if (j = pomme.X + 1) and (i = pomme.Y + 1) then      // placement de la pomme
					write('P')
				else if (j = serpent.tete.X + 1) and (i = serpent.tete.Y + 1) then     // placement de la tete du serpent
					write('O')  
				else
					begin
						estCorps := False;
						k := 1;
						while (k<= serpent.longueur) and (not estCorps) do
						begin
							if (j = serpent.queue[k].X + 1) and (i = serpent.queue[k].Y + 1) then
								estCorps := True;
							k := k + 1;
						end;
						if estCorps then      // placement de la queue du serpent
							write('o')
						else write(' ');
					end;
			end;
		end;
		writeln();
	end;
end;


procedure gestionClavier(var serpent: MonSerpent);   // controle de la direction de mouvement du serpent 
var
  key: Char;
begin
  if KeyPressed then
  begin
    key := ReadKey;
    case key of
      UpKey: if serpent.dirActuelle <> Bas then serpent.dirActuelle := Haut;   // fleche vers le haut 
      DownKey: if serpent.dirActuelle <> Haut then serpent.dirActuelle := Bas;   // fleche vers le bas 
      LeftKey: if serpent.dirActuelle <> Droite then serpent.dirActuelle := Gauche;  // fleche vers la gauche 
      RightKey: if serpent.dirActuelle <> Gauche then serpent.dirActuelle := Droite;  // fleche vers la droite
    end;
  end;
end;

procedure deplaceSerpent(var grille: Tab; var serpent: MonSerpent; var pomme: Coord; var compteur: Integer);    // controle du mouvement du serpent
var
	temp, nouvelleTete, ancienneTete: Coord;
	i: Integer;
	pommeMangee: Boolean;
begin
	ancienneTete := serpent.tete;
	pommeMangee := False;
	gestionClavier(serpent);
	case serpent.dirActuelle of				// deplace la tete du serpent en modifiant ses coordonnées
		Haut:
			begin
				nouvelleTete.X := serpent.tete.X;
				nouvelleTete.Y := serpent.tete.Y - 1;
			end;
		Bas:
			begin
				nouvelleTete.X := serpent.tete.X;
				nouvelleTete.Y := serpent.tete.Y + 1;
			 end;
		Gauche:
			begin
				nouvelleTete.X := serpent.tete.X - 1;
				nouvelleTete.Y := serpent.tete.Y;
			end;
		Droite:
			begin
				nouvelleTete.X := serpent.tete.X + 1;
				nouvelleTete.Y := serpent.tete.Y;
			end;
	end;

	// Maj de la position de la tête du serpent
	grille[serpent.tete.X, serpent.tete.Y] := 'o';    // Tete devient une partie du corps  
	serpent.tete := nouvelleTete;
	grille[serpent.tete.X, serpent.tete.Y] := 'O';
    
	if (nouvelleTete.X = pomme.X) and (nouvelleTete.Y = pomme.Y) then	// cas ou le serpent a mangé la pomme
		begin
			pommeMangee := True;     
			positionPomme(grille, pomme);       // nouvelle position de la pomme 
			serpent.longueur := serpent.longueur + 1;      // serpent grandit apres avoir mange une pomme
			compteur:= compteur + 1;      // maj du compteur de pommes
		end
			
	else if (not pommeMangee) then  // cas ou le serpent n'a pas mangé de pomme
		begin			
			for i := 1 to serpent.longueur - 1 do   // on retire le dernier segment de la queue
			begin
				temp := serpent.queue[i];
				serpent.queue[i] := ancienneTete;
				ancienneTete := temp;
			end; 
		end;
end;

function collisionMur(serpent: MonSerpent): Boolean;
begin
	collisionMur := False;
	if (serpent.tete.X = 0) or (serpent.tete.X = COLONNES ) or (serpent.tete.Y = 0) or (serpent.tete.Y = LIGNES ) then     // verifie si le serpent se heurte avec les murs
			collisionMur := True;
end;

function collisionCorps(serpent: MonSerpent): Boolean;
var i: Integer;
begin
	collisionCorps := False;
	for i := 1 to (serpent.longueur - 1) do        // verifie si le serpent se heurte avec son corps
	begin
		if (serpent.tete.X = serpent.queue[i].X) and (serpent.tete.Y = serpent.queue[i].Y) then
			collisionCorps := True;
    end;
end;	

procedure afficherGameOver(score: Integer); 	// annonce la fin du jeu
begin
  textColor(Red);
  gotoXY(30, 10);
  writeLn('########################');
  gotoXY(30, 11);
  writeLn('#                      #');
  gotoXY(30, 12);
  writeLn('#   🍎 GAME OVER 🍎    #');
  gotoXY(30, 13);
  writeLn('#                      #');
  gotoXY(30, 14);
  writeLn('########################');
  textColor(White);
  gotoXY(45, 16);
  writeLn('SCORE: ', score);	// affiche le score
  readLn;
end;


procedure partieSerpent(var score: Integer);	// deroulement d'une partie
var
  delayTime, maxDelay, minDelay, compteur: Integer; 
  grille: Tab; serpent: MonSerpent; pomme: Coord;
begin
  clrScr;
  initialiseGrille(grille);
  positionPomme(grille, pomme);
  initialiseSerpent(grille, serpent);
  compteur := 0;
  maxDelay := 350; 	// delai max
  minDelay := 50; 	 // delai min
  delayTime := maxDelay; 	// commence le délai au maximum
  afficheGrille(grille, serpent, pomme, compteur);
  writeln('Prêt ?');	// previnet le joueur du debut du jeu
  write('3...');
  delay(1000);
  write('2...');
  delay(1000);
  write('1...');
  delay(1000);
    while not(collisionMur(serpent)) and not(collisionCorps(serpent)) do
    begin
		clrScr;   
		deplaceSerpent(grille, serpent, pomme, compteur);
		if not(collisionMur(serpent)) and not(collisionCorps(serpent)) then
			afficheGrille(grille, serpent, pomme, compteur);
		if delayTime > minDelay then  
			delayTime := delayTime - 1;   // accelere la vitesse du mouvement 
		delay(delayTime); // vitesse du jeu
		if not((collisionMur(serpent)) or (collisionCorps(serpent))) then
			afficheGrille(grille, serpent, pomme, compteur);
	end;
	
	score:= score + compteur * 10; //	actualise le score
	writeln(score);
	clrScr;
	afficherGameOver(score);
end;

end.

