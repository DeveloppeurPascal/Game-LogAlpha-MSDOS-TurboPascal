program Log_Alpha;
{
Auteur: Patrick Pr‚martin.
Date: 26/02/1992. (1.0)
Langage: Turbo Pascal 6.0
But: Jeu: L'ordinateur va choisir des s‚ries de 10 lettres, le joueur devra
     trouver la 11Šme logique.
}
uses
    crt,
    olf_software,
    u_aff_chaine,
    u_m_util,
    u_curseur,
    u_dat;

const
     dat_vers : string [10] = '02/26/1992';
     num_vers : string [3] = '1.0';

var
   liste : t_liste;
   carac : char;

function ask (nb : word; ch : string) : boolean;
var
   x, y : word;
   i, j : word;
   c,
   carac : char;
begin
  i := random (length (ch) - 11);
  textcolor (red);
  write (nb : 3, ' - ');
  textcolor (white);
  for j := 0 to 9 do
    begin
      write (ch [i+j], ' ');
    end;
  {endfor}
  writeln;
  textcolor (lightgray);
  write ('What is the next letter ? ');
  x := wherex;
  y := wherey;
  c := ' ';
  textcolor (lightblue);
  repeat
    carac := upcase (readkey);
    if (carac in ['A'..'Z'])
    then
      c := carac;
    {endif}
    gotoxy (x, y);
    write (c);
  until ((carac = #13) and (c in ['A'..'Z']));
  writeln;
  writeln;
  ask := (c = ch [i+10]);
end; { Ask }

procedure jeu (nb_ask : word);
var
   i : word;
   ph : p_phrase;
   score : word;
begin
  ph := liste.phrase;
  score := 0;
  clrscr;
  textcolor (yellow);
  affic_center_ln ('Log Alpha');
  gotoxy (1, 5);
  for i := 1 to nb_ask do
    begin
      repeat
        ph := ph^.next;
        if (ph = nil)
        then
          ph := liste.phrase;
        {endif}
      until ((random (100) < 50) and (not ph^.used));
      ph^.used := true;
      if (ask (i, ph^.str))
      then
        inc (score);
      {endif}
    end;
  {endfor}
  clrscr;
  textcolor (yellow);
  affic_center_ln ('Log Alpha');
  writeln;
  writeln;
  textcolor (lightgray);
  score := (score * 100) div nb_ask;
  writeln ('Your score is: ', score, '% with ', nb_ask, ' questions.');
  ph := liste.phrase;
  while (ph <> nil) do
    begin
      ph^.used := false;
      ph := ph^.next;
    end;
  {endwhile}
end; { Jeu }

function get_nb_ask (max : word) : word;
var
   c : char;
   x, y : word;
   res : word;
begin
  textbackground (black);
  clrscr;
  textcolor (yellow);
  affic_center_ln ('Log Alpha');
  gotoxy (1, 5);
  textcolor (lightgray);
  write ('How many questions do you want ? ');
  x := wherex;
  y := wherey;
  writeln;
  writeln;
  writeln ('+ or - to change value.');
  writeln ('High Value = ', max);
  textcolor (red);
  res := 1;
  repeat
    gotoxy (x, y);
    write (res);
    clreol;
    c := readkey;
    case (c) of
      '+' :
        begin
          inc (res);
          if (res > max)
          then
            res := 1;
          {endif}
        end;
      '-' :
        begin
          dec (res);
          if (res < 1)
          then
            res := max;
          {endif}
        end;
    end;
  until ((c = #13) and (res > 0) and (res <= max));
  get_nb_ask := res;
end; { Get_Nb_Ask }

begin
  checkbreak := false;
  init_licence ('GAMELNA');
  init_olf_message (mess_shareware);
  init_olf_software ('Log Alpha '+num_vers, #155' Patrick Pr‚martin '+dat_vers);
  asm
     mov ah, 0
     mov al, 0
     int 10h
  end;
  directvideo := false;
  curseur_off;
  load_dat (liste);
  textcolor (white);
  textbackground (black);
  clrscr;
  textcolor (yellow);
  gotoxy (16, 1);
  affic_center_ln ('Log Alpha');
  textcolor (lightgray);
  affic_center_ln ('(c) Patrick Pr‚martin '+dat_vers);
  affic_center_ln ('(c) Olf Software 1992');
  writeln;
  textcolor (white);
  writeln ('   This program is shareware, if you use');
  writeln ('it, please send 50 FF to');
  textcolor (red);
  affic_center_ln ('Patrick Pr‚martin');
  affic_center_ln ('Lot. Le Soleiadou');
  affic_center_ln ('13790 Rousset');
  affic_center_ln ('France.');
  writeln;
  textcolor (lightgray);
  affic_center_ln ('Press a key to start...');
  while keypressed do
    carac := readkey;
  {endwhile}
  while not keypressed do;
  while keypressed do
    carac := readkey;
  {endwhile}
  clrscr;
  randomize;
  repeat
    curseur_off;
    jeu (get_nb_ask (liste.nb_phrases));
  until (not confirm ('Play again ?'));
  curseur_off;
  asm
     mov ah, 0
     mov al, 3
     int 10h
  end;
  textcolor (lightgray);
  textbackground (black);
  done_dat (liste);
  clrscr;
  writeln ('See you later...');
  curseur_on;
end.
