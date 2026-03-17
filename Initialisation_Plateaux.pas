Unit Initialisation_Plateaux;

INTERFACE

uses
Sysutils, Crt,Commun,InterfaceHM;

procedure initialisationPlateaux(var grille1, grille2 : Grid; var taille: Integer; scoreJoueur : Integer ;var niveau : Difficulte);

IMPLEMENTATION

procedure creationPlateaux(var taille  :Integer;var grille1, grille2: Grid);
var i,j : Integer;
begin

{Fermer les coins du plateau}
grille1[taille+2][taille+2].vaisseau:='/';
grille1[taille+2][taille+2].tir:=True;
grille1[1][1].vaisseau:='/';
grille1[1][1].tir:=True;
grille1[1][taille+2].vaisseau:='\';
grille1[1][taille+2].tir:=True;
grille1[taille+2][1].vaisseau:='\';
grille1[taille+2][1].tir:=True;
grille2[taille+2][taille+2].vaisseau:='/';
grille2[taille+2][taille+2].tir:=True;
grille2[1][1].vaisseau:='/';
grille2[1][1].tir:=True;
grille2[1][taille+2].vaisseau:='\';
grille2[1][taille+2].tir:=True;
grille2[taille+2][1].vaisseau:='\';
grille2[taille+2][1].tir:=True;

for i:=0 to taille+2 do
begin
	for j:=0 to taille+2 do
	begin
		grille2[i,j].historique:=grille2[i,j].vaisseau;
	end;
end;

{Grilles vides}
	for i:=2 to taille+1 do
	begin
		for j:=2 to taille+2 do
		begin
			grille1[i,j].vaisseau := ' ';
			grille1[i,j].touche:=False;
			grille2[i,j].vaisseau := ' ';
			grille2[i,j].historique := ' ';
			grille2[i,j].touche:=False;
		end;
{Délimitation des plateaux}
	begin
	grille1[i][1].vaisseau:= Chr(i+47);
	grille1[i][1].tir:= True;
	grille2[i][1].vaisseau := Chr(i+47) ;	
	grille2[i][1].historique := Chr(i+47) ;
	grille2[i][1].tir := True;
	grille1[taille+2][i].vaisseau:='|';
	grille1[taille+2][i].tir:=True;
	grille2[taille+2][i].vaisseau:='|';
	grille2[taille+2][i].historique:='|';
	grille2[taille+2][i].tir:=True;
	grille1[1][i].vaisseau:= Chr(i+63);
	grille1[1][i].tir:= True;
	grille2[1][i].vaisseau := Chr(i+63);
	grille2[1][i].historique := Chr(i+63);
	grille2[1][i].tir := True;
	grille1[i][taille+2].vaisseau:='_';
	grille1[i][taille+2].tir:=True;
	grille2[i][taille+2].vaisseau:='_';
	grille2[i][taille+2].historique:='_';
	grille2[i][taille+2].tir:=True;
	end;
	end;
end;

procedure choixDifficulte(var taille : Integer; var niveau : Difficulte);
var 
	curseur : Char;
	i : Integer;
begin
	{Menu du jeu}
	taille := 0;
	affichageMenu(i);
	i := 0;
    
    {Choix difficulte}
	repeat
		curseur := Readkey();
		case curseur of
			#80 : 
				begin
					if i < 3 then
					begin
						i := i + 1;
						GotoXY(58, i + 11);
					end;
				end;
			#72:
				begin
					if i > 0 then
					begin
						i := i - 1;
						GotoXY(58, i + 11);
					end;
				end;
			#13 : 
				begin
					case i of
						0: niveau := Facile;
						1: niveau := Moyen;
						2: niveau := Difficile;
						3: niveau := Chaos;
					else
						writeln('selection invalide');
					end;
				end;
		end;
	until curseur = #13;  
	Clrscr();

	{Taille du plateau}
	case niveau of
		Facile: taille := 8;
		Moyen: taille := 9; 
		Difficile: taille := 10; 
		Chaos: taille := 10;
	else
	end;
end;



function vaisseauxNonAdjacents(grille: Grid; cordX, cordY, taille: Integer; sens: String): Boolean;
var
	i: Integer;
	nonAdjacent: Boolean;
begin
	nonAdjacent := True;

	if sens = 'H' then {quand le vaisseau est orienté horizontalement, toutes les cases qui l'entourent sont rendues inaccessibles pour le placement des autres vaisseaux}
	begin
		i := 0;
		while (i < taille) and nonAdjacent do
		begin
			nonAdjacent := not ((grille[cordX , cordY+1].vaisseau ='O') or
                                (grille[cordX + i + 1, cordY ].vaisseau = 'O') or
                                (grille[cordX + taille+1, cordY + 1].vaisseau = 'O') or
                                (grille[cordX + i+1, cordY + 2].vaisseau = 'O'));
			i := i + 1;
		end;
	end
	else {quand le vaisseau est orienté verticalement, toutes les cases qui l'entourent sont rendues inaccessibles pour le placement des autres vaisseaux}
	begin
		i := 0;
		while (i < taille) and nonAdjacent do
		begin
			nonAdjacent := not ((grille[cordX+1, cordY ].vaisseau = 'O') or
                                (grille[cordX , cordY + i + 1].vaisseau = 'O') or
                                (grille[cordX + 2, cordY + i + 1].vaisseau ='O') or
                                (grille[cordX+1, cordY + taille+1 ].vaisseau = 'O'));
			i := i + 1;
		end;
	end;

	vaisseauxNonAdjacents := nonAdjacent;
end;


procedure selectionVaisseau(var destroyer, navette, aeroglisseur: Vaisseau;var choixVais: Vaisseau;var nomVais: String;var niveau: Difficulte; var destroyersRestants, navettesRestants, aeroglisseursRestants: Integer; var vaisseauSelectionne: Boolean);

begin
	vaisseauSelectionne := False;
	writeln('Quel vaisseau souhaitez-vous placer ?');
	readln(nomVais);
	nomVais:=upperCase(nomVais); {le joueur sélectionne le vaisseau qu'il veut}

	case nomVais of {tant qu'il reste des vaisseaux de la cétgorie choisie, le vaisseau peut bien être choisi, sinon le joueur doit à nouveau entrer un vaisseau}
	'D':
	begin
		if destroyersRestants > 0 then
		begin
			choixVais := destroyer;
			vaisseauSelectionne := True;
		end
		else
			writeln('Plus de destroyers à placer.');
	end;
	
	'N':
	begin
		if navettesRestants > 0 then
		begin
			choixVais := navette;
			vaisseauSelectionne := True;
		end
		else
			writeln('Plus de navettes à placer.');
	end;
	
	'A':
	begin
		if aeroglisseursRestants > 0 then
		begin
			choixVais := aeroglisseur;
			vaisseauSelectionne := True;
		end
		else
			writeln('Plus de aeroglisseurs à placer.');
	end
	else
		writeln('Vaisseau inconnu. Veuillez réessayer.');
	end;
end;


procedure saisieCoordonnees(var cordX, cordY: Integer; var sens: String; var coordonneesValides: Boolean);
var cordlettre:Char;
begin
	coordonneesValides := False;
	writeln('Selectionnez la case de placement du cockpit');
	readln(cordlettre,cordX);
	cordY:=Ord(cordlettre)-64;

	writeln('Entrez H pour placer horizontalement, V pour verticalement');
	readln(sens);
	sens:=upperCase(sens);

	if (sens = 'H') or (sens = 'V') then
		coordonneesValides := True
	else
		writeln('Sens de placement invalide.'); {le vaisseau ne peut pas être placé diagonalement}
	ClrScr();
end;


procedure verificationEmplacement(grille: Grid; cordX, cordY: Integer; choixVais: Vaisseau; sens: String; var emplacementValide: Boolean);
var
	i: Integer;
	espaceOccupe: Boolean;
begin
	ClrScr();
	emplacementValide := True;
	espaceOccupe := False;

	if not vaisseauxNonAdjacents(grille, cordX, cordY, choixVais.taille, sens) then 
	begin
		writeln('Emplacement invalide : vaisseau adjacent détecté.'); {si les vaisseaux sont adjacents, l'emplacement est eronné}
		emplacementValide := False;
	end
	else
	begin
		if sens = 'H' then {lorsque le vaisseau est orienté horizontalement, on vérifie l'emplacement tant qu'il est occupé}
		begin
			i := 0;
			while (i < choixVais.taille) and not espaceOccupe do
			begin
				if grille[cordX + i+1, cordY+1].vaisseau <> ' ' then
				begin
					writeln('Emplacement déjà occupé.');
					emplacementValide := False;
					espaceOccupe := True;
				end;
				i := i + 1;
			end;
		end
		else {on reprend le même raisonnement lorsque le vaisseau est orienté verticalement}
		begin
			i := 0;
			while (i < choixVais.taille) and not espaceOccupe do
			begin
				if grille[cordX+1, cordY + i+1].vaisseau <> ' ' then
				begin
					writeln('Emplacement déjà occupé.');
					emplacementValide := False;
					espaceOccupe := True;
				end;
				i := i + 1;
			end;
		end;
	end;
end;



procedure placerVaisseau(var grille: Grid; cordX, cordY: Integer; choixVais: Vaisseau; sens: String);
var
	i: Integer;
begin
	if sens = 'H' then {placement des vaisseaux dans le sens horizontal, le "début" du vaisseau étant la case de placement choisie par le joueur}
	begin
		for i := 0 to choixvais.taille-1 do
		begin
			grille[cordX + i+1, cordY+1].vaisseau := 'O';
			case choixvais.taille of
			3: 
				begin
				grille[cordX+i+1,cordY+1].typeV := 'D';
				end;
			2:
				begin
				grille[cordX+i+1,cordY+1].typeV := 'N';
				end;
			1:
				begin
				grille[cordX+i+1,cordY+1].typeV := 'A';
				end;
			end;
		end;
	end
	else {même principe pour le placement vertical}
	begin
		for i := 0 to choixvais.taille-1 do
		begin
			grille[cordX+1, cordY + i+1].vaisseau := 'O';
			case choixvais.taille of
			3 : 
				begin
				grille[cordX+1,cordY+i+1].typeV := 'D';
				end;
			2:
				begin
				grille[cordX+1,cordY+i+1].typeV := 'N';
				end;
			1:
				begin
				grille[cordX+1,cordY+i+1].typeV := 'A';
				end;
			end;
		end;
	end;
	
	writeln('Vaisseau placé avec succès.');
end;

procedure initialiserVaisseaux(var destroyer, navette, aeroglisseur: Vaisseau; niveau: Difficulte);
begin
    destroyer.taille := 3;
    navette.taille := 2;
    aeroglisseur.taille := 1;

    case niveau of {en fonction du niveau, le nombre de vaisseaux à placer par catégorie diffère}
        Facile:
        begin
            destroyer.nombre := 1;
            navette.nombre := 3;
            aeroglisseur.nombre := 0;
        end;
        Moyen:
        begin
            destroyer.nombre := 1;
            navette.nombre := 1;
            aeroglisseur.nombre := 2;
        end;
        Difficile:
        begin
            destroyer.nombre := 0;
            navette.nombre := 1;
            aeroglisseur.nombre := 3;
        end;
        Chaos:
        begin
            destroyer.nombre := 0;
            navette.nombre := 0;
            aeroglisseur.nombre := 4;
        end;
    end;
end;

procedure choixPlacementVaisseaux(niveau: Difficulte; var grille1: Grid; taille, scoreJoueur: Integer);
var aeroglisseur,navette,destroyer:Vaisseau;
var
	nomVais: String;
	choixVais: Vaisseau;
	cordX, cordY,j: Integer;
	sens: String;
	emplacementValide, vaisseauSelectionne, coordonneesValides: Boolean;
	destroyersRestants, navettesRestants, aeroglisseursRestants: Integer;
	
begin
	initialiserVaisseaux(destroyer, navette, aeroglisseur, niveau); {on appelle la procédure pour intialiser le nombre de vaisseaux à placer en fonction de la difficulté chosie}

	destroyersRestants := destroyer.nombre;
	navettesRestants := navette.nombre;
	aeroglisseursRestants := aeroglisseur.nombre;
	
  
	while (destroyersRestants > 0) or (navettesRestants > 0) or (aeroglisseursRestants > 0) do
	{affichage des disponnibilités de vaisseaux à placer}
	begin
		gotoxy(2,3);
		TextColor(14);
		write('ARSENAL');
		TextColor(15);
		gotoxy(2,5);
		write('D : Destroyers : x',destroyersRestants);
			for j:=1 to destroyer.taille do
			begin
				gotoxy(2,5+j);
				write('O');
			end;
		gotoxy(27,5);
		write('N : Navettes : x', navettesRestants);
			for j:=1 to navette.taille do
			begin
				gotoxy(27,5+j);
				write('O');
			end;
		gotoxy(2,10);
		write('A : Aeroglisseurs : x',aeroglisseursRestants);
			for j:=1 to aeroglisseur.taille do
			begin
				gotoxy(2,10+j);
				write('O');
			end;
		writeln();
		affichagePlateaux(grille1,taille, scoreJoueur);{le plateau du joueur est affiché}
		selectionVaisseau(destroyer,navette,aeroglisseur,choixVais, nomVais,niveau, destroyersRestants, navettesRestants, aeroglisseursRestants, vaisseauSelectionne);
		if vaisseauSelectionne then {placement du vaisseau, uniquement si les coordonnées sont valides, s'il reste de vaisseaux de cette catégorie et si l'emplacement est libre}
		begin
			saisieCoordonnees(cordX, cordY, sens, coordonneesValides);

			if coordonneesValides then
			begin
				verificationEmplacement(grille1, cordX, cordY, choixVais, sens, emplacementValide);

				if emplacementValide then
				begin
					placerVaisseau(grille1, cordX, cordY, choixVais, sens);

					if nomVais = 'D' then
						destroyersRestants := destroyersRestants - 1
					else if nomVais = 'N' then
						navettesRestants := navettesRestants - 1
					else if nomVais = 'A' then
						aeroglisseursRestants := aeroglisseursRestants - 1;
				end;
			end;
		end;
	end;
	ClrScr();
	affichagePlateaux(grille1,taille, scoreJoueur); {le plateau du joueur avec les vaisseaux placés est affiché}
end;


function choisirVaisseauAleatoire(destroyer, navette, aeroglisseur: Vaisseau;destroyersRestants, navettesRestants, aeroglisseursRestants: Integer): Vaisseau;
var
    choix, compteur: Integer;
    vaisseauChoisi: Vaisseau;
begin
	randomize;
    compteur := 0;

    vaisseauChoisi.taille := 0;
    vaisseauChoisi.nombre := 0;

    while (vaisseauChoisi.nombre = 0) and (compteur < 10) do
    begin
        choix := Random(3); {l'IA choisit une catégorie de vaisseaux aléatoirement en tirant un chiffre compris entre 0 et 2}
        case choix of
            0: if destroyersRestants > 0 then vaisseauChoisi := destroyer;
            1: if navettesRestants > 0 then vaisseauChoisi := navette;
            2: if aeroglisseursRestants > 0 then vaisseauChoisi := aeroglisseur;
        end;
        compteur := compteur + 1;
    end;

    choisirVaisseauAleatoire := vaisseauChoisi;
end;

procedure placementAleatoireIA(niveau: Difficulte; var grille2: Grid; taille: Integer); {par le même principe que le placement des vaisseaux du joueur, l'IA appelle les procédures nécessaires pour les vérifications de l'emplacement et des vaisseaux restants avant de placer un vaisseau}
var 
    aeroglisseur, navette, destroyer: Vaisseau;
    choixVais: Vaisseau;
    cordXIA, cordYIA: Integer;
    sens: Char;
    emplacementValide: Boolean;
    destroyersRestants, navettesRestants, aeroglisseursRestants, tentatives: Integer;
begin
    randomize;
    initialiserVaisseaux(destroyer, navette, aeroglisseur, niveau); {l'IA initialise les vaisseaux en fonction du niveau saisi par le joueur}
    destroyersRestants := destroyer.nombre;
    navettesRestants := navette.nombre;
    aeroglisseursRestants := aeroglisseur.nombre;

    while (destroyersRestants > 0) or (navettesRestants > 0) or (aeroglisseursRestants > 0) do
    begin
        choixVais := choisirVaisseauAleatoire(destroyer,navette,aeroglisseur,destroyersRestants, navettesRestants, aeroglisseursRestants); 

        tentatives := 0;
        emplacementValide := False;

        while (not emplacementValide) and (tentatives <= 50) do
        begin
            cordXIA := Random(taille) + 1; {choix aléatoire des coordonnées de placement, +1 car random commence à 0}
            cordYIA := Random(taille) + 1;
            if Random(2) = 0 then {de même pour l'orientation}
                sens := 'H'
            else
                sens := 'V';

            verificationEmplacement(grille2, cordXIA, cordYIA,choixVais, sens, emplacementValide);
            ClrScr();
            tentatives := tentatives + 1;
        end;

        if emplacementValide then
        begin
            placerVaisseau(grille2, cordXIA, cordYIA, choixVais, sens);
            ClrScr();
	{on met à jour le compteur de vaisseaux restants après chaque placement}
            if choixVais.taille = destroyer.taille then
                destroyersRestants := destroyersRestants - 1
            else if choixVais.taille = navette.taille then
                navettesRestants := navettesRestants - 1
            else if choixVais.taille = aeroglisseur.taille then
                aeroglisseursRestants := aeroglisseursRestants - 1;
        end;
	end;
end;

procedure initialisationPlateaux(var grille1, grille2 : Grid; var taille: Integer;  scoreJoueur : Integer ; var niveau : Difficulte);	//Initialise les deux plateaux
begin
	choixDifficulte(taille, niveau); {le joueur choisit le niveau qu'il souhaite}
	creationPlateaux(taille,grille1,grille2); {la grille vide et délimitée est générée}
	choixPlacementVaisseaux(niveau, grille1, taille, scoreJoueur); {le joeuur place ses vaisseaux}
	placementAleatoireIA(niveau,grille2,taille); {l'IA place ses vaisseaux}
	affichagePlateaux(grille2,taille,scoreJoueur); {le plateau de l'IA est affiché pour la démonstration du jeu, dans une vraie partie le joueur ne peut pas voir le plateau de l'IA}
	ClrScr();
end;

end.
