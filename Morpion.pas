unit Morpion;

INTERFACE

uses CRT;

procedure partieMorpion(var score: Integer);

IMPLEMENTATION

const TAILLE_GRILLE = 3;
	NB_DE_PIONS_A_ALIGNER = 3;
	VICTOIRE = '🏆 VICTOIRE 🏆';
    DEFAITE = '🤡 DEFAITE 🤡 ';
    EGALITE = '🤝 EGALITE 🤝 ';
	

type t_indice_grille = 1..TAILLE_GRILLE;
	t_pion = 0..2;
	t_grille = array[t_indice_grille, t_indice_grille] of t_pion;


procedure initialiserGrille(var grille: t_grille);  // initialise le tableau avec des espaces
var
  i, j: t_indice_grille;
begin
  for i := 1 to TAILLE_GRILLE do
    for j := 1 to TAILLE_GRILLE do
      grille[i, j] := 0;
end;

procedure afficherGrille(grille: t_grille); // affiche la grille 
var
  i, j: t_indice_grille;
begin
  writeln('Grille actuelle :');
  for i := 1 to TAILLE_GRILLE do
  begin
    for j := 1 to TAILLE_GRILLE do
    begin
      case grille[i, j] of
        0: write(' . ');
        1: write(' X ');
        2: write(' O ');
      end;
      if j < TAILLE_GRILLE then
        write('|');
    end;
    writeln;
    for j := 1 to TAILLE_GRILLE - 1 do		// affiche les délimitations en fonction de la taille de la grille
		write('---+');
	writeln('---');
  end;
end;

procedure changerJoueur(var joueur_actuel: t_pion);		
begin
  if joueur_actuel = 1 then
    joueur_actuel := 2
  else
    joueur_actuel := 1;
end;

function test_Ligne_Horiz(grille : t_grille; joueur_actuel: t_pion): Boolean;	// verifie si un joueur a aligner le bon nombre de pions horizontalement
var i,j, compt: Integer;
	res: boolean;
begin
	res := false;
	i := 1;
	repeat
		compt := 0;
		for j:= 1 to (TAILLE_GRILLE - 1) do 
		begin
			if (grille[i, j] =  joueur_actuel) and (grille[i, j] = grille[i, j + 1]) then	// compare deux cases sur la meme ligne cote a cote
				compt := compt + 1;
		end;
		if (compt = NB_DE_PIONS_A_ALIGNER - 1) then 
			res := true
		else i := i + 1;
	until res or (i = TAILLE_GRILLE + 1);
	test_Ligne_Horiz := res;
end;

function test_Ligne_Vert(grille : t_grille; joueur_actuel: t_pion): Boolean;	// verifie si un joueur a aligner le bon nombre de pions verticalement
var i,j, compt: Integer;
	res: boolean;
begin
	res := false;
	j := 1;
	repeat
		compt:= 0;
		for i:= 1 to (TAILLE_GRILLE - 1) do 
		begin
			if (grille[i, j] = joueur_actuel) and (grille[i, j] = grille[i + 1, j]) then		// compare deux cases sur la meme colonne cote a cote
				compt := compt + 1;
		end;
		if (compt = NB_DE_PIONS_A_ALIGNER - 1) then 		// le compteur ajoute 1 si 2 cases sont egales
			res := True
			else j:= j + 1;
	until res or (j = TAILLE_GRILLE + 1); // verifie la dernière colonne puis sort
	test_Ligne_Vert := res;
end;

function test_Diag1(grille : t_grille; joueur_actuel : t_pion): Boolean;	// verifie si un joueur a aligner deux cases sur la diagonale descendante cote a cote
var i, comptDiag1: Integer;
	res: boolean;
begin
	res:= False;
	comptDiag1 := 0;
	for i := 1 to (TAILLE_GRILLE - 1) do
	begin
		if (grille[i, i] <> 0) and (grille[i, i] = grille[i + 1, i + 1]) then    //compare deux cases sur la diagonale descendante 
			comptDiag1 := comptDiag1 + 1;
	end;
	if (comptDiag1 = NB_DE_PIONS_A_ALIGNER- 1 ) then
		res := True;
	test_Diag1 := res;
end;

function test_Diag2(grille : t_grille; joueur_actuel : t_pion): Boolean; // verifie si un joueur a aligner deux cases sur la diagonale montante
var i, comptDiag2: Integer;
	res: boolean;
begin
	res := false;
	comptDiag2 := 0;
	for i := 1 to (TAILLE_GRILLE - 1) do
	begin
		if (grille[i, TAILLE_GRILLE - i + 1] = joueur_actuel) and (grille[i, TAILLE_GRILLE - i + 1] = grille[i + 1, TAILLE_GRILLE - (i + 1) + 1]) then //compare deux cases sur la diag montante
			comptDiag2 := comptDiag2 + 1;
	end;
	if (comptDiag2 = NB_DE_PIONS_A_ALIGNER -1) then
		res := True;
	test_Diag2 := res;
end;

function estGagnant(grille: t_grille; joueur_actuel: t_pion): Boolean; // regroupe toutes les fonctions test et renvoie si le joueur est gagnant
var res: Boolean;
begin
	res := false;
	if test_Ligne_Horiz(grille, joueur_actuel) or test_Ligne_Vert(grille, joueur_actuel) or test_Diag1(grille,joueur_actuel) or test_Diag2(grille,joueur_actuel) then
		res := True;
	estGagnant := res;
end;


function estMatchNul(grille: t_grille): Boolean;	// verifie si toutes cases sont remplies
var
  i, j: Integer; 
  res: Boolean;
begin
	res := True; // suppose que le match est nul
	i:=1;
	while (i <= TAILLE_GRILLE) and res do
	begin
		j:=1;
		while (j <= TAILLE_GRILLE) and res do
		begin
			if grille[i, j] = 0 then
				res:= false; // une case est vide donc la partie continue
			j:= j + 1;
		end;
		i:= i + 1;	
	end;
	estMatchNul:= res;
end;

procedure gagneIA(var grille: t_grille; var valide: boolean; joueur_actuel: t_pion);     // verifie si l'IA peut saisir un coup gagnant
var 
  i, j: Integer;
begin
	valide := False;
	i:=1;
	while (i<=TAILLE_GRILLE) and (not valide) do
	begin
		j:=1;
		while (j<=TAILLE_GRILLE) and (not valide) do
		begin
			if grille[i, j] = 0 then 	//  la case initiale doit etre vide
			begin
				grille[i, j] := joueur_actuel; 		// on simule le coup de l'IA
				if estGagnant(grille, joueur_actuel) then	 // verifie si l'IA gagne avec ce coup
					valide := True 		// si le coup est valide, le pion est placé
				else	grille[i, j] := 0; 		// sinon, il est reinitilisé et on continue avec la case suivante
			end;
			j:=j+1;
		end;
		i:=i+1;
	end;
end;

procedure bloqueIA(var grille: t_grille; var valide: boolean; joueur_actuel: t_pion);     // verifie si l'IA peut bloquer un coup gagnant
var 
  i, j: Integer;
  joueur_adverse: t_pion;
begin
	valide:= false;
	if joueur_actuel = 1 then
		joueur_adverse := 2
	else
		joueur_adverse := 1; 
	i:=1;
	while (i<=TAILLE_GRILLE) and (not valide) do
	begin
		j:=1;
		while (j<=TAILLE_GRILLE) and (not valide) do
		begin
			if grille[i, j] = 0 then 	// la case doit etre vide
			begin
				grille[i, j] := joueur_adverse; 		// on simule le coup du joueur
				if estGagnant(grille, joueur_adverse) then	 // verifie si le joueur gagne avec ce coup
				begin
					grille[i, j] := joueur_actuel; // si le coup est valide, l'IA place son pion
					valide := True 		
				end
				else	grille[i, j] := 0; 	// sinon, il est reinitialisé et on continue avec la case suivante
			end;
			j:=j+1;
		end;
		i:=i+1;
	end;
end;

procedure coupIA(var grille: t_grille; joueur_actuel: t_pion); 		// resume la strategie de l'IA
var
  valide, valideGagnant, valideBloquant: boolean;
  i, j: t_indice_grille;
begin
	gagneIA(grille, valideGagnant, joueur_actuel);		// verifie s'il peut gagner
	if not valideGagnant then		// si l'IA ne peut pas gagner avec le coup suivant
	begin
		bloqueIA(grille, valideBloquant, joueur_actuel);		// verifie s'il peut bloquer 
		if not valideBloquant then 		// si l'IA ne peut pas bloquer avec le coup suivant 
		begin			// place aleatoirement
			randomize();
			valide := False;
			repeat
				i := Random(TAILLE_GRILLE) + 1;
				j := Random(TAILLE_GRILLE) + 1;
				if grille[i, j] = 0 then
				begin
					grille[i, j] := joueur_actuel;
					valide := True;
				end
				else valide := False;
			until valide;
		end;
	end;
end;

procedure saisirCoup(joueur_actuel: t_pion; var grille: t_grille); // place le pion joueur 
var
  i, j: t_indice_grille;
  valide: Boolean;
begin
	valide:= false;
    repeat
      writeln('Joueur 1, entrez les coordonnées (ligne et colonne) de votre coup : ');
      write('Ligne : ');
      readln(i);
      write('Colonne : ');
      readln(j);
      if (i in [1..TAILLE_GRILLE]) and (j in [1..TAILLE_GRILLE]) and (grille[i, j] = 0) then	// verifie si l'entree est valide
      begin
        grille[i, j] := joueur_actuel;
        valide := True;
      end
      else
      begin
        writeln('Coup invalide. Réessayez.');
        valide := False;
      end;
    until valide;
end;

procedure afficherGameOver(res: String; var score: Integer);	// annonce la fin du jeu
begin  	
	clrScr; 
	textColor(white); 
	gotoXY(30, 10);
	writeln('#######################');
	gotoXY(30, 11);
	writeln('#                     #');
	gotoXY(30, 12);
	writeln('#    ',res,'   #');
	GotoXY(30, 13);
	writeln('#                     #');
	gotoXY(30, 14);
	writeln('#######################');	
	gotoXY(43, 17);
	write('SCORE: ');
	case res of 		// affiche le resultat et actualise le score
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

procedure partieMorpion(var score: Integer); 		// deroulement d'une partie
var grille: t_grille;
	joueur_actuel: t_pion;
begin
	initialiserGrille(grille);
	afficherGrille(grille);
	joueur_actuel := 2;
	repeat 
		changerJoueur(joueur_actuel);
		if joueur_actuel = 1 then
			saisirCoup(joueur_actuel, grille)
		else if not estGagnant(grille, joueur_actuel) then 			// si le joueur ne gagne pas, l'IA peut jouer
			coupIA(grille, joueur_actuel);
		clrScr;
		afficherGrille(grille);
		delay(800);				// retarde l'affichage du pion IA
	until estGagnant(grille, joueur_actuel) or estMatchNul(grille);
	if estGagnant(grille, joueur_actuel) then
	begin
		if (joueur_actuel = 1) then
			afficherGameOver(VICTOIRE, score)
		else afficherGameOver(DEFAITE, score)
	end
	else afficherGameOver(EGALITE, score);
	readln;
end;

end.
