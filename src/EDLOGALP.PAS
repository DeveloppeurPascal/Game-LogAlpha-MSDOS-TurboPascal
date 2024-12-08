program Editeur_Log_Alpha;
{
Auteur: Patrick Pr‚martin.
Date: 26/02/1992.
Langage: Turbo Pascal 6.0
But: Edition des fichiers de donn‚es de 'Log Alpha'.
}
uses
    u_dat,
    u_m_util,
    u_sgf,
    u_ger_chaine,
    printer,
    crt;

var
   liste : t_liste;
   ch : string;
   ph : p_phrase;
   i,
   j : word;
   x, y : word;

procedure imprime (liste : t_liste);
var
   ph : p_phrase;
begin
  writeln (lst, 'Nom du fichier: ', c_nom_dat);
  writeln (lst);
  writeln (lst, 'Nombre de phrases: ', liste.nb_phrases);
  writeln (lst);
  ph := liste.phrase;
  while (ph <> nil) do
    begin
      writeln (lst, '- ', ph^.str);
      ph := ph^.next;
    end;
  {endwhile}
  write (lst, #12);
end; { Imprime }

begin
  writeln ('Editeur de fichiers de Log Alpha.');
  writeln ('(c) Patrick Pr‚martin 02/26/1992.');
  writeln;
  c_nom_dat := get_fich_name (c_nom_dat, 'DAT');
  if exist (c_nom_dat)
  then
    load_dat (liste)
  else
    begin
      liste.nb_phrases := 0;
      liste.extension := 0;
      liste.phrase := nil;
    end;
  {endif}
  write ('Combien de lignes … saisir ? ');
  readln (i);
  inc (liste.nb_phrases, i);
  for j := 1 to i do
    begin
      x := wherex;
      y := wherey;
      repeat
        gotoxy (x, y);
        clreol;
        writeln ('Phrase ', j);
        clreol;
        readln (ch);
      until (ch <> '');
      new (ph);
      ph^.used := false;
      ph^.next := liste.phrase;
      liste.phrase := ph;
      ph^.str := set_maj_chaine (ch);
    end;
  {endif}
  if confirm ('Sauvegarde de ce fichier ?')
  then
    save_dat (liste);
  {endif}
  if confirm ('Impression de ce fichier ?')
  then
    imprime (liste);
  {endif}
  done_dat (liste);
end.
