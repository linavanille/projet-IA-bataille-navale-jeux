unit Puissance4;

INTERFACE

uses CRT;

procedure partiePuissance4(var score: Integer);

IMPLEMENTATION

const
  LIGNES = 6;
  COLONNES = 7;
  VICTOIRE = '🏆 VICTOIRE 🏆';
  DEFAITE = '🤡 DEFAITE 🤡 ';
  EGALITE = '🤝 EGALITE 🤝 ';

Type 
	Board = array[1..LIGNES, 1..COLONNES] of Char;

procedure initialiseGrille(var grille: Board); // initialise la grille de jeu avec des espaces 
var
  i, j: Integer;
begin
  for i := 1 to LIGNES do
    for j := 1 to COLONNES do
      grille[i, j] := ' ';
end;



procedure afficheGrille(grille: Board); // affiche la grille
var
  i, j: Integer;
begin
	writeln(' 1 | 2 | 3 | 4 | 5 | 6 | 7 | ');
	for i := 1 to LIGNES do
	begin
		write(' ');
		for j := 1 to COLONNES do
			write(grille[i, j], ' | ');      
	writeln;
	end;
end;

procedure afficheChutePion(colonne, ligne: Integer; joueur: Char; var grille: Board); // affiche les pions pendant leur descente dans la grille
var
	i: Integer;
begin
	for i := 1 to ligne do
	begin
		grille[i, colonne] := joueur; // place le pion temporairement dans la grille
		clrScr;
		afficheGrille(grille); 
		delay(200); 	// temps d'attente pour l'effet de chute du pion
	grille[i, colonne] := ' '; 	// efface le pion temporaire de cette position
	end;
	grille[ligne, colonne] := joueur; // place définitivement le pion à la position finale
	clrScr;
	afficheGrille(grille);	 // affiche la grille avec le pion à sa position finale
end;


function colonneRemplie(colonne: Integer; grille: Board): Boolean; // verifie si la colonne choisie est remplie
var res: Boolean;
begin
	res := False;
	if grille[1, colonne] <> ' ' then 
		res:= True;
	colonneRemplie := res;
end;

function grillePleine(grille: Board): Boolean; // verifie si la grille est pleine
var
  i, j: Integer;
begin
	grillePleine := True;  // on suppose que la grille est pleine
	i := 1;
	while (i < LIGNES) and grillePleine do
	begin
		j:= 1;
		while (j < COLONNES) and grillePleine do
		begin
			if grille[i, j] = ' ' then //si une case est vide alors la grille n'est pas pleine
				grillePleine := False;
		end;
	end;
end;


procedure placement(colonne: Integer; joueur_actuel: Char; var grille: Board); // verifie si le choix de colonne est valide et place le pion
var ligne: Integer;
begin
  ligne := LIGNES;
  while (ligne > 0) and (Grille[ligne, colonne] <> ' ') do
    ligne := ligne - 1;
  if ligne > 0 then
  begin    
    afficheChutePion(colonne, ligne, joueur_actuel, grille);
    grille[ligne, colonne] := joueur_actuel;
   end;
    
end;


function ligneHorizontale(grille: Board; joueur_actuel: Char): Boolean; // verifie si le joueur a aligner 4 pions horizontalement 
var res :Boolean;
	i,j: Integer;
begin
	res :=False;
	i:=1;
	while (i<=LIGNES) and (not res) do
	begin
		j:=1;
		while (j<=COLONNES-3) and (not res) do
		begin
			if (grille[i, j] = joueur_actuel) and (grille[i, j + 1] = joueur_actuel) and (grille[i, j + 2] = joueur_actuel) and (grille[i, j + 3] = joueur_actuel) then // compare 3 cases sur la meme ligne
				res:=True;
			j:=j+1;
		end;
		i:=i+1;
	end;
	ligneHorizontale:=res;
end;
 
function ligneVerticale(grille: Board; joueur_actuel: Char): Boolean; // verifie si le joueur a aligner 4 pions verticalement 
var res:Boolean;
	i,j: Integer;
begin
	res := False;
	j:=1;
	while (j <= COLONNES) and (not res) do
	begin
		i:=1; 
		while (i <= LIGNES - 3) and (not res) do
		begin
			if (grille[i, j] = joueur_actuel) and (grille[i + 1, j] = joueur_actuel) and (grille[i + 2, j] = joueur_actuel) and (grille[i + 3, j] = joueur_actuel) then // compare 3 cases
				res:=True;
			i:=i+1;
		end;
		j:=j+1;
	end;
	ligneVerticale:=res;
end;

function ligneDiag1(grille: Board; joueur_actuel: Char): Boolean; // verifie si le joueur a aligner 4 pions en diagonale
var	res: boolean;
	i,j: Integer;
begin
	res := False;
	i := 4;
	while (i <= LIGNES) and (not res) do 
	begin
		j:= 1;
		while (j <= COLONNES - 3) and (not res) do
		begin
			if (grille[i, j] = joueur_actuel) and (grille[i - 1, j + 1] = joueur_actuel) and (grille[i - 2, j + 2] = joueur_actuel) and (grille[i - 3, j + 3] = joueur_actuel) then
				res:=True;
			j:=j+1;
		end;
		i:= i+1;
	end;
	ligneDiag1 := res;
end;

function ligneDiag2(grille: Board; joueur_actuel: Char): Boolean;  // verifie si le joueur a aligner 4 pions sur une diagonale descendante
var res: boolean;
	i,j: Integer;
begin
	res := False;
	i:=1;
	while (i<=LIGNES - 3) and (not res) do 
	begin
		j:=1;
		while (j<=COLONNES - 3) and (not res) do
		begin
			if (grille[i, j] = joueur_actuel) and (grille[i + 1, j + 1] = joueur_actuel) and (grille[i + 2, j + 2] = joueur_actuel) and (grille[i + 3, j + 3] = joueur_actuel) then
				res:= True;
				j:= j+1;
		end;
		i:= i+1;
	end;
	ligneDiag2 := res;
end;

function estGagnant(joueur_actuel: Char; grille: Board): Boolean; 	// verifie si le joueur a aligner 4 pions sur une diagonale montante
begin
	if ligneVerticale(grille,joueur_actuel) or ligneHorizontale(grille,joueur_actuel) or ligneDiag1(grille,joueur_actuel) or ligneDiag2(grille,joueur_actuel) then
		estGagnant:= True
	else 
		estGagnant:= False; // aucune victoire
end;

procedure saisirCoupPuiss(var grille: Board; var joueur_actuel: Char); 	// place le pion
var valide : boolean;
	choixColonne: Integer;
begin
	joueur_actuel:= 'X';
	repeat		// verifie si l'entree est valide
		valide := False;
		writeln('Choisissez une colonne (1-7) : ');
		readln(choixColonne);
		if (choixColonne > 0) and (choixColonne < COLONNES + 1) and (not colonneRemplie(choixColonne, grille)) then
		begin
			placement(choixColonne, joueur_actuel, grille); 	// place le pion
			valide := True;
		end
		else writeln('Choix de colonne invalide. Veuillez réessayer.');
	until valide;
end;


procedure gagneIA(var grille: Board; var valide: boolean; var joueur_actuel: Char); // verifie si l'IA peut gagner avce le coup suivant
var i, j: Integer;
begin
	joueur_actuel := 'O';
	valide := False;
	i := LIGNES;
	while (i > 0) and not valide do  
	begin
		j := 1;   // sinon j depasse COLONNES
		while (j <= COLONNES)  and (not valide) do 
		begin
			if (((grille[i, j] = ' ') and (i = LIGNES)) or ((grille[i, j] = ' ') and (grille[i + 1, j] <> ' '))) then // verifie que c'est bien la premiere ligne a remplir 
			begin
				grille[i, j] := joueur_actuel;   // simule le coup de l'IA dans cette colonne
				if estGagnant(joueur_actuel, grille) then  // verifie si le coup gagne la partie 
				begin
					grille[i, j] := ' ';	// libere la case pour ne pas afficher deux fois 
					placement(j, joueur_actuel, grille);
					valide := True;
				end
				else grille[i, j] := ' '; // annule le coup si le coup ne gagne pas la partie
			end;
			j := j + 1;
		end;
		i := i - 1;
	end;
end;

procedure bloqueIA(var grille: Board; var valide: boolean; var joueur_actuel: Char); // verifie si l'IA peut bloquer un coup gagnant du joueur 
var
	i, j: Integer;
	joueur_adverse: Char;
begin
	joueur_adverse := 'X';
	joueur_actuel := 'O';
	valide := False;
	i := LIGNES;
	while (i > 0) and not valide do  
	begin
	j := 1;   // sinon j depasse COLONNES
		while (j <= COLONNES)  and (not valide) do 
		begin
			if (((grille[i, j] = ' ') and (i = LIGNES)) or ((grille[i, j] = ' ') and (grille[i + 1, j] <> ' '))) then // verifie que c'est bien la première colonne qu'il peut remplir 
			begin
				grille[i, j] := joueur_adverse;    // simule le coup du joueur 
				if estGagnant(joueur_adverse, grille) then  // verifie si le coup gagne la partie
				begin
					grille[i, j] := ' ';
					placement(j, joueur_actuel, grille);  // si le coup gagne la partie alors il place un pion IA 
					valide := True
				end
				else grille[i, j] := ' ';  // annule le coup s'il ne bloque pas le joueur 
			end;
			j := j + 1;
		end;
		i := i - 1;
	end;
end;

procedure coupIA(var grille: Board; var joueur_actuel: Char);	// resume la startegie de l'IA
var	valideBloquant, valideGagnant: boolean;
	j: Integer;
begin
	joueur_actuel := 'O';
	gagneIA(grille, valideGagnant, joueur_actuel);
	if not valideGagnant then
		begin
		bloqueIA(grille, valideBloquant, joueur_actuel);
		if not valideBloquant then    // s'il ne peut ni bloquer, ni gagner, il joue aléatoirement
		begin
			repeat 
				randomize();
				j := random(COLONNES) + 1;	
			until not colonneRemplie(j, grille);
			placement(j, joueur_actuel, grille);
		end;
	end;
end;

procedure afficherGameOver(res: String; var score: Integer); // annonce la fin du jeu
begin  	
	clrScr; 
	textColor(white); 
	gotoXY(30, 10);
	writeLn('#######################');
	gotoXY(30, 11);
	writeLn('#                     #');
	gotoXY(30, 12);
	writeLn('#    ',res,'   #');
	GotoXY(30, 13);
	writeLn('#                     #');
	gotoXY(30, 14);
	writeLn('#######################');	
	gotoXY(43, 17);
	write('SCORE: ');
	case res of 		// affiche le nombre de points gagnés
		VICTOIRE: 
		begin
			writeln('+100');
			score := score + 100;
		end;			
		DEFAITE: 
		begin
			writeln('-100');
			score := score - 100;
		end;
		EGALITE: writeln('0');
	end;
	readln; 	
end;

procedure partiePuissance4(var score: Integer);		// deroulement d'une partie
var grille: Board; 
	joueur_actuel: Char; 
begin
	initialiseGrille(grille);
	afficheGrille(grille);
	repeat	
		saisirCoupPuiss(grille, joueur_actuel);
		clrScr;
		afficheGrille(grille);
		if (not estGagnant(joueur_actuel,grille)) and (not grillePleine(grille)) then		
		begin
			coupIA(grille, joueur_actuel);	
			delay(900);
			clrScr;			// retarde l'affichage du coup de l'IA
			afficheGrille(grille);
		end;
	until estGagnant(joueur_actuel, grille) or grillePleine(grille);
	if estGagnant(joueur_actuel,grille) then
		begin
			clrScr;
			afficheGrille(grille);
			delay(800);
			if joueur_actuel = 'X' then		// affiche le résultat du jeu et le score actualisé
				afficherGameOver(VICTOIRE, score)
			else afficherGameOver(DEFAITE, score);	
		end
		else if grillePleine(grille) then
			afficherGameOver(EGALITE, score);
end;

end.
