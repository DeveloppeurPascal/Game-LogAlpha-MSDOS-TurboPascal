unit u_dat;
{
Auteur: Patrick Pr‚martin.
Date: 26/02/1992.
Langage: Turbo Pascal 6.0
But: Gestion du fichier de donn‚es de 'Log Alpha'.
}
interface

type
    p_phrase = ^t_phrase;
    t_phrase = record
                 str : string;
                 used : boolean;
                 next : p_phrase;
    end;
    t_liste = record
                phrase : p_phrase;
                nb_phrases : word;
                extension : word;
    end;

var
   c_nom_dat : string;

procedure load_dat (var liste : t_liste);
procedure save_dat (var liste : t_liste);
procedure done_dat (liste : t_liste);

implementation
uses
    u_codage;

procedure load_dat (var liste : t_liste);
var
   fich : file;
   ch : string;
   ph : p_phrase;
   nb : byte;
begin
  assign (fich, c_nom_dat);
  {$i-}
  reset (fich, 1);
  {$i+}
  if (ioresult <> 0)
  then
    begin
      writeln ('I can not open LOGALPHA.DAT');
      writeln ('Fatal error...');
      halt (1);
    end;
  {endif}
  blockread (fich, liste.extension, sizeof (liste.extension));
  blockread (fich, liste.nb_phrases, sizeof (liste.nb_phrases));
  liste.phrase := nil;
  while not eof (fich) do
    begin
      new (ph);
      if (ph = nil)
      then
        begin
          writeln ('Heap error: not enough memory to run...');
          halt (1);
        end;
      {endif}
      blockread (fich, nb, sizeof (nb));
      blockread (fich, ch, nb);
      ph^.str := ch_decoder (ch);
      ph^.next := liste.phrase;
      liste.phrase := ph;
      ph^.used := false;
    end;
  {endif}
  close (fich);
end; { Load_Dat }

procedure save_dat (var liste : t_liste);
var
   fich : file;
   ch : string;
   ph : p_phrase;
   nb : byte;
begin
  assign (fich, c_nom_dat);
  {$i-}
  rewrite (fich, 1);
  {$i+}
  if (ioresult <> 0)
  then
    begin
      writeln ('I can not open '+c_nom_dat);
      writeln ('Fatal error...');
      halt (1);
    end;
  {endif}
  blockwrite (fich, liste.extension, sizeof (liste.extension));
  blockwrite (fich, liste.nb_phrases, sizeof (liste.nb_phrases));
  ph := liste.phrase;
  while not (ph = nil) do
    begin
      ch := ch_coder (ph^.str);
      nb := succ (length (ch));
      blockwrite (fich, nb, sizeof (nb));
      blockwrite (fich, ch, nb);
      ph := ph^.next;
    end;
  {endif}
  close (fich);
end; { Save_Dat }

procedure done_dat (liste : t_liste);
var
   ph : p_phrase;
begin
  ph := liste.phrase;
  while (ph <> nil) do
    begin
      liste.phrase := ph^.next;
      dispose (ph);
      ph := liste.phrase;
    end;
  {endwhile}
end; { Done_Dat }

begin
  c_codage_1 := $28;
  c_codage_2 := $33;
  c_nom_dat := 'LOGALPHA.DAT';
end. { Fin de 'U_Dat'. }
