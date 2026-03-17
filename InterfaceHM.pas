Unit InterfaceHM;

INTERFACE

uses Crt,Sysutils;

procedure affichageTitre(var res: string);
procedure afficherGameOver(var res: String; scoreIA, scoreJoueur: Integer);
procedure quitterPartie(var retour,quitter:Boolean);
procedure affichageMenu(var compteur:Integer);
procedure affichageRegles(var regles: Text);

IMPLEMENTATION

procedure affichageRegles(var regles: Text);
var ligne: String;
begin 
	assign(regles, 'reglesStarWars.text');
	reset(regles);
	while not EOF(regles) do
	begin
		readln(regles, ligne); 
		writeln(ligne);
	end;
	close(regles);
end;

procedure affichageTitre(var res: string); //Affiche des titres en couleur
begin
	gotoxy(36,12);
	TextColor(14);
	writeln(res);
	TextColor(15);
	readln();
	clrScr();
end;

procedure afficherGameOver(var res: String; scoreIA, scoreJoueur: Integer); // annonce la fin du jeu
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
	write('SCORE: ', scoreJoueur);
	if (scoreIA < scoreJoueur) then
			res := '🏆 VICTOIRE 🏆'
	else if (scoreIA > scoreJoueur) then		// affiche le nombre de points gagnés
			res := '🤡 DEFAITE 🤡 '
	else if (scoreIA = scoreJoueur) then
		res := '🤝 EGALITE 🤝 '
	else 
		writeln('Vous allez quitter le jeu');	//Si aucun des 3 cas, cela signifie que le joueur a choisi de quitter
	readln; 	
end;


procedure quitterPartie(var retour,quitter:Boolean); //Vérifie si le joueur veut quitter ou retourner au menu du jeu
var choix:Char;
begin

//Initialisation : le joueur continue la partie//
retour:=False;
quitter:=False;

//Affichage//
gotoxy(70,20);
write('R : RETOUR');
gotoxy(70,21);
write('Q : QUITTER');
choix:=Readkey();

//Lecture du choix du joueur//
	case upperCase(choix) of	//Lecture de la lettre en majuscule ou minuscule//
		
		//Si R est pressé, le joueur retourne au menu	
		'R' : retour:=True;

		//Si Q est pressé, le joueur quitte le jeu
		
		'Q' : quitter:=True;
	end;
	ClrScr();
end;

procedure affichageMenu(var compteur:Integer); //Affiche le menu
begin
	compteur:=1;
	gotoxy(35,10);
	TextColor(14);
	writeln('MENU');
	TextColor(15);
	gotoxy(18,12);
	writeln('Veuillez choisir un niveau de difficulte');
	gotoxy(19,13);
	writeln('appuyer sur une touche pour continuer');
	gotoxy(9,16);
	writeln('A chaque fin de tour, vous pouvez taper Q pour quitter la partie');
	Readkey();
	Clrscr();
	gotoxy(35,10);
	TextColor(14);
	writeln('MENU');
	TextColor(15);
	gotoxy(25,12);
	writeln('Facile');
	gotoxy(25,13);
	writeln('Moyen');
	gotoxy(25,14);
	writeln('Difficile');
	gotoxy(25,15);
	writeln('Chaos');
	gotoXY(25,compteur+11);
end;

end.
