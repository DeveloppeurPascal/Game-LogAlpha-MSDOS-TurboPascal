@echo off
set code=gamelna
ren logalpha.dat logalpha.$�$
copy logalpha.dk0 logalpha.dat
lha a c:\olf_soft\lzh\%code% logalpha.exe logalpha.dat setup.cfg
del logalpha.dat
ren logalpha.$�$ logalpha.dat
set code=
echo on
