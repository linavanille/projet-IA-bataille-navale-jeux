unit MiniJeux;

INTERFACE

uses CRT, Morpion, Puissance4,Pendu,Snake ;

procedure jouer(var score: Integer);

IMPLEMENTATION

procedure affichageMenu(var menu: Text);	// affiche le menu des jeux qu ele joueur peut chosir 
var ligne: String;
begin 
	assign(menu, 'menuJeux.text');
	reset(menu);
	while not EOF(menu) do
	begin
		readln(menu, ligne); 
		writeln(ligne);
	end;
	close(menu);
end;

procedure jouer(var score: Integer);  // joue la partie du jeu choisi et actualise le score
var choix: Integer;	
	menu: Text; 
begin
	write('oui');
	affichageMenu(menu);
	readln(choix);
	clrScr;
	case choix of
		1: partieSerpent(score);
		2: partieMorpion(score);
		3: partiePuissance4(score); 
		4: partiePendu(score);
		else writeln('Choix invalide. Veuillez choisir un nombre entre 0 et 4.');
	end;   
	writeln; 
	clrScr;
end;

end.








