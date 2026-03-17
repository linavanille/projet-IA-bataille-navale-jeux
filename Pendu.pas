unit Pendu;

INTERFACE

uses Crt;

procedure partiePendu(var score:Integer); {la partie de pendu actualise le score obtenu dans la bataille navale}

IMPLEMENTATION

type
	typeMot = record {structure regroupant les informations liées au mot à deviner}
		motADeviner: string;
		motCache: string;
		lettresUtilisees: array['A'..'Z'] of Boolean;
		lettresFausses: string;
		tentativesRestantes: Integer;
	end;

procedure lectureMotsFichier(var mots: array of string); {la procédure lit les mots d'un fichier existant et en prend un poru le faire deviner}
var
	fichier: Text;
	mot: String; {il s'agit du mot stocké à l'emplacement i du tableau de chaînes}
	i: Integer;
begin
	assign(fichier, 'Pendu.txt');
	reset(fichier);
	i := 0; {index permettant de parcourir les lignes du fichier}

	readln(fichier, mot);{la première ligne du fichier est ignorée puisqu'il s'agit du titre}

	while not eof(fichier) do
	begin
		readln(fichier, mot);
		if i < length(mots) then 
		begin
			mots[i] := mot; {le mot est stocké dans le tableau}
			i := i + 1;
		end;
	end;
	close(fichier);
end;

procedure initialisationMotCache(var mot: typeMot); {le mot à deviner est caché avec des _ à la place des lettres}
var
	i: Integer;
begin
	mot.motCache := '';
	for i := 1 to length(mot.motADeviner) do
	begin
		if mot.motADeviner[i] in ['A'..'Z', 'a'..'z'] then {on vérifie dans un premier temps si tous les caractères sont des lettres}
			mot.motCache := mot.motCache + '_'; {dans ce cas, les lettres sont remplacées par des _ }
	end;
end;

procedure initialisationLettresUtilisees(var mot: typeMot); {au départ, aucune lettre n'est utilisée}
var
	lettre: Char;
begin
	for lettre := 'A' to 'Z' do
		mot.lettresUtilisees[lettre] := False;
end;

procedure affichageMotCache(var mot: typeMot); {affiche le mot à deviner modifié par la procédure initialisationMotCache}
begin
	writeln('Mot à trouver: ', mot.motCache);
end;

procedure affichageLettresUtilisees(var mot: typeMot); 
var
	lettre: Char;
begin
	writeln('Lettres utilisées: '); 
	for lettre := 'A' to 'Z' do
	begin
		if mot.lettresUtilisees[lettre] then
			write(lettre, ' '); {affichage à l'écran de l'historique des lettres utilisées par le joueur}
	end;
	writeln;
end;

procedure affichageLettresFausses(var mot: typeMot);
begin
	writeln('Lettres fausses : ', mot.lettresFausses); {affichage à l'écran de l'historique des lettres fausses utilisées par le joueur}
end;

procedure affichagePendu(tentatives: Integer); {pour chaque lettre fausse, le bonhomme obtient une partie de son corps}
begin
	case tentatives of {gestion de l'affichage avec un case of du nombre de lettres/tentatives ratées}
		0:	begin
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('|     | ');
				gotoxy(55,3);
				write('|     O ');
				gotoxy(55,4);
				write('|    /|\');
				gotoxy(55,5);
				write('|    / \');
				gotoxy(55,6);
				write('|');
			end;
		1:  begin    
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('|     | ');
				gotoxy(55,3);
				write('|     O ');
				gotoxy(55,4);
				write('|    /|\');
				gotoxy(55,5);
				write('|    / ');
				gotoxy(55,6);
				write('|');
			end;
		2:  begin    
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('|     | ');
				gotoxy(55,3);
				write('|     O ');
				gotoxy(55,4);
				write('|    /|\');
				gotoxy(55,5);
				write('|');
				gotoxy(55,6);
				write('|');
			end;
		3:  begin    
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('|     | ');
				gotoxy(55,3);
				write('|     O ');
				gotoxy(55,4);
				write('|    /|');
				gotoxy(55,5);
				write('|');
				gotoxy(55,6);
				write('|');
			end;
		4: begin    
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('|     | ');
				gotoxy(55,3);
				write('|     O ');
				gotoxy(55,4);
				write('|     |');
				gotoxy(55,5);
				write('|');
				gotoxy(55,6);
				write('|');
			end;
		5: begin    
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('|     | ');
				gotoxy(55,3);
				write('|     O ');
				gotoxy(55,4);
				write('|');
				gotoxy(55,5);
				write('|');
				gotoxy(55,6);
				write('|');
			end;
		6:  begin    
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('|     | ');
				gotoxy(55,3);
				write('| ');
				gotoxy(55,4);
				write('|');
				gotoxy(55,5);
				write('|');
				gotoxy(55,6);
				write('|');
			end;
		7: begin     				{lorsqu'aucune tentative n'a été ratée, le pendu n'affiche que la structure extérieure du dessin}
				gotoxy(55,1);
				write('-------');
				gotoxy(55,2);
				write('| ');
				gotoxy(55,3);
				write('| ');
				gotoxy(55,4);
				write('|');
				gotoxy(55,5);
				write('|');
				gotoxy(55,6);
				write('|');
			end;
	end;
end;

procedure demandeLettre(var mot: typeMot; var lettre: Char);
begin
	repeat
		writeln('Entrez une lettre : ');
		readln(lettre); {lecture de la lettre entrée par le joueur}
		lettre := UpCase(lettre); 
	until (lettre in ['A'..'Z']) and (not mot.lettresUtilisees[lettre]); {re demande une entrée au joueur tant que celle ci n'est pas une lettre ET déjà été utilisée}

	mot.lettresUtilisees[lettre] := True; {dans ce cas, la lettre est ajoutée au répertoire de lettres utilisées}
end;

function suppressionEspacesDebutFin(s: string): string; {permet d'effacer les esapces en début et en fin de mot lorsque celui ci est donné par le joueur}
var
	i, debut, fin: Integer;
	resultat: string;
begin
	debut := 1;
	fin := length(s);

	while (debut <= fin) and (s[debut] = ' ') do
		debut:=debut+1;

	while (fin >= debut) and (s[fin] = ' ') do
		fin := fin - 1;

	resultat := '';
	for i := debut to fin do
		resultat := resultat + s[i];

	suppressionEspacesDebutFin := resultat;
end;

procedure demanderMotEntier(var mot: typeMot);
var
	motEntier: string;
begin
	gotoxy(1,8);
	write('Entrez le mot entier si vous pensez l''avoir reconnu : ');
	readln(motEntier);

	motEntier := suppressionEspacesDebutFin(UpCase(motEntier)); {les éventuels espaces en début et fin de mot sont supprimés, et le mot est mis en majuscule}
	mot.motADeviner := UpCase(mot.motADeviner); {le mot à deviner est également mis en majuscules}

	if motEntier = mot.motADeviner then {si les deux mots sont identiques alors le mot à deviner est affiché}
		mot.motCache := mot.motADeviner
	else
	begin
		writeln('Ce n''est pas le bon mot.');
		readln;
	end;
end;

procedure miseAJourMotCache(var mot: typeMot; lettre: Char);
var
	i: Integer;
	lettreTrouvee: Boolean;
begin
	lettreTrouvee := False;

	for i := 1 to length(mot.motADeviner) do
	begin
		if UpCase(mot.motADeviner[i]) = lettre then {si la lettre donnée par le joueur se trouve dans le mot à deviner}
		begin
			mot.motCache[i] := UpCase(mot.motADeviner[i]);
			lettreTrouvee := True;
		end;
	end;

	if not lettreTrouvee then {si la lettre ne se trouve pas dans le mot, alors on met à jour:}
	begin
		mot.tentativesRestantes := mot.tentativesRestantes - 1; {décrémentation des tentatives}
		mot.lettresFausses := mot.lettresFausses + lettre + ' '; {ajout de la lettre fausse dans le "registre"}
		affichagePendu(mot.tentativesRestantes); {l'affichage du pendu est mis à jour}
		gotoxy(1,9);
		writeln('La lettre ', lettre, ' ne fait pas partie du mot.');
	end;
end;

function motCacheComplet(var mot: typeMot): Boolean; {vérifie si tout le mot a été deviné}
var
	i: Integer;
	complet: Boolean;
begin
	complet := True;

	for i := 1 to length(mot.motCache) do
	begin
		if mot.motCache[i] = '_' then
		begin
			complet := False;
		end;
	end;

	motCacheComplet := complet;
end;

procedure jeuPendu(score: Integer; var mot: typeMot);
var
	lettre: Char;
	reponse: String;
	motDevine: Boolean;
begin 							{initialisation de l'affichage}
	mot.tentativesRestantes := 7; 
	initialisationMotCache(mot);
	initialisationLettresUtilisees(mot);
	mot.lettresFausses := '';
	affichagePendu(mot.tentativesRestantes);

	while (mot.tentativesRestantes > 0) and (not motCacheComplet(mot)) do
	begin
		ClrScr();
		writeln('Bienvenue dans le Jeu du Pendu!');
		affichageMotCache(mot);
		affichagePendu(mot.tentativesRestantes);
		writeln();
		gotoxy(1, 3);
		writeln('Tentatives restantes : ', mot.tentativesRestantes);
		gotoxy(1, 4);
		affichageLettresUtilisees(mot);
		gotoxy(1, 5);
		affichageLettresFausses(mot);

		repeat
			gotoxy(1, 6);
			write('Voulez-vous deviner le mot entier ? (O/N) : '); {le joueur a le choix entre entrer le mot en entier ou juste une lettre}
			readln(reponse);
			reponse := UpCase(reponse);
		until (reponse = 'O') or (reponse = 'N');

		if reponse = 'O' then
		begin
			demanderMotEntier(mot);
			if mot.motCache = mot.motADeviner then
				motDevine:= True;
		end
		else
		begin
			demandeLettre(mot, lettre);
			miseAJourMotCache(mot, lettre);
		end;
		
		if not motDevine then 
		begin
			demandeLettre(mot, lettre); {si le mot donné est faux, une lettre est redemandée}
			miseAJourMotCache(mot, lettre);
		end;
	end;

	if motCacheComplet(mot) then
	begin
		gotoxy(1, 10);
		writeln('Félicitations Padawan, vous avez deviné le mot!');
		score := score + 100;  {mise à jour du score de la bataille navale avec un bonus }
		writeln('Cette partie de pendu vous a apporté 100 points supplémentaires');
		writeln('SCORE: ', score);
	end
	else
	begin
		gotoxy(1, 10);
		writeln('Pas de chance padawan... vous avez épuisé toutes vos tentatives. Le mot était : ', mot.motADeviner);
		score := score - 100;  { Mise à jour du score de la bataille navale avec un malus }
		writeln('Cette partie de pendu vous a fait perdre 100 points');
		writeln('SCORE: ', score);
		end;
end;

procedure partiePendu(var score: Integer);
var 
	motsDuFichier: array of string;
	motADeviner: typeMot;

begin
	randomize;
	setLength(motsDuFichier, 60); {on fixe le nombre de mots possibles à deviner}
	lectureMotsFichier(motsDuFichier);
	motADeviner.motADeviner := motsDuFichier[Random(Length(motsDuFichier))];
	jeuPendu(score, motADeviner); {le jeu renvoie un score qui actualise celui de la bataille navale}
	readln();
end;

end.

