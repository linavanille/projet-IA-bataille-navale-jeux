Unit Commun;

Interface

uses
 Sysutils, Crt;
 
Type Difficulte = (Facile, Moyen, Difficile,Chaos);

Type Gameplay = record //Permet de stocker des informations selon si la case est touchée, déja tirée dessus, la catégorie de vaisseau contenu,l'historique de tir du joueur et l'allure du vaisseau
	touche : Boolean;
	vaisseau : Char;
	tir : Boolean;
	typeV : Char;
	historique: Char;
	end;
	
Type Vaisseau = record	//Associe chaque catégorie de vaisseau à sa taille et son nombre dans le niveau de difficulte
	nombre : Integer;
	taille : Integer;
	end;

const MAX1 = 19;
Type Grid = Array [1..MAX1]of array[1..MAX1] of Gameplay;//Type des plateaux

procedure affichagePlateaux(var grille: Grid; taille, scoreJoueur: Integer);
procedure modifiePlateau(x,y : Integer; var grille:Grid);
procedure initialisation(grille:Grid;x,y : Integer; var tailleV: Integer);

Implementation

procedure affichagePlateaux(var grille: Grid; taille, scoreJoueur: Integer);//Affiche les plateaux 
var
	i, j: Integer;
begin
	writeln('SCORE: ', scoreJoueur);
	for i := 1 to taille + 2 do
	begin
		writeln();
	for j := 1 to taille + 2 do
		write(grille[j][i].vaisseau, ' ');
	end;
	writeln();
end;

procedure modifiePlateau(x,y : Integer; var grille:Grid);	//modifie les cases visées selon si le tir touche ou non un vaisseau
begin
		if grille[x,y].vaisseau = 'O' then	//Cas où un vaisseau est touché
			begin
				grille[x,y].touche:=True;
				grille[x,y].tir:=True;
				grille[x,y].vaisseau := 'X';
			end
		else if (grille[x,y].vaisseau = ' ') and (grille[x,y].tir = False) then	//Cas où rien n'est touché
			begin
			grille[x,y].touche:= False;
			grille[x,y].tir:= True;	
			grille[x,y].vaisseau:= '#';
			end
	
end;

procedure initialisation(grille:Grid;x,y : Integer; var tailleV: Integer);	//Définit la taille du vaisseau contenu en (x,y)
begin
	case grille[x,y].typeV of
	
		'A': 			//aeroglisseur
			tailleV:=1;
	
		'N':			//navette
			tailleV:=2;
		
		'D': 			//destroyer
			tailleV:=3;
	else
	tailleV:=0;
	end;
end;
end.
