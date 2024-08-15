% Punto 1
juega(ana, romanos).
juega(beto, incas).
juega(carola, romanos).
juega(dimitri, romanos).
% elsa no juega -> principio de universo cerrado

desarrollo(ana, herreria).
desarrollo(ana, forja).
desarrollo(ana, emplumado).
desarrollo(ana, laminas).
desarrollo(beto, herreria).
desarrollo(beto, forja).
desarrollo(beto, fundicion).
desarrollo(carola, herreria).
desarrollo(dimitri, herreria).
desarrollo(dimitri, fundicion).

% Punto 2
expertoEnMetales(Jugador):-
  distinct(Jugador, (
    desarrollo(Jugador, herreria),
    desarrollo(Jugador, forja),
    expertoEnMetalesEspecifico(Jugador)
  )).

expertoEnMetalesEspecifico(Jugador):-desarrollo(Jugador, fundicion).
expertoEnMetalesEspecifico(Jugador):-juega(Jugador, romanos).

% Punto 3
% Que no usen findall
civilizacionPopular(Civilizacion):-
  distinct(Civilizacion, (
    juega(Alguien, Civilizacion),
    juega(Otro, Civilizacion),
    Alguien \= Otro
  )).

% Punto 4
alcanceGlobal(Tecnologia):-
  tecnologia(Tecnologia),
  forall(jugador(Jugador), desarrollo(Jugador, Tecnologia)).

tecnologia(Tecnologia):-
  distinct(Tecnologia, (
    desarrollo(_, Tecnologia)
  )).

jugador(Jugador):-
  distinct(Jugador, desarrollo(Jugador, _)).  

% Punto 5
civilizacionLider(Civilizacion):-
  civilizacion(Civilizacion),
  forall(
    (alcanzo(Tecnologia, OtraCivilizacion), OtraCivilizacion \= Civilizacion), 
    alcanzo(Tecnologia, Civilizacion)).

civilizacion(Civilizacion):-distinct(Civilizacion, juega(_, Civilizacion)).

alcanzo(Tecnologia, Civilizacion):-
  juega(Alguien, Civilizacion),
  desarrollo(Alguien, Tecnologia).

% Punto 6
unidad(ana, jinete(caballo)).
unidad(ana, piquero(true, 1)).
unidad(ana, piquero(false, 2)).
unidad(beto, campeon(100)).
unidad(beto, campeon(80)).
unidad(beto, piquero(true, 1)).
unidad(beto, jinete(camello)).
unidad(carola, piquero(false, 3)).
unidad(carola, piquero(true, 2)).
% Dimitri no tiene unidades por principio de universo cerrado

% Punto 7
unidadConMasVida(Jugador, MejorUnidad):-
  jugador(Jugador),
  % es bastante tricky que Vida tiene que ser el primer argumento y Unidad el whitness (testigo)
  % otra opción más imperativa es usar findall y después calcular el mayor a manopla
  aggregate(max(Vida, Unidad), (unidad(Jugador, Unidad), vida(Unidad, Vida)), max(Vida, MejorUnidad)).

vida(jinete(caballo), 90).
vida(jinete(camello), 80).
vida(campeon(Vida), Vida).
vida(piquero(false, 1), 50).
vida(piquero(false, 2), 65).
vida(piquero(false, 3), 70).
vida(piquero(true, Nivel), Vida):-vida(piquero(false, Nivel), VidaSinEscudo), Vida is VidaSinEscudo * 1.1.

% Punto 8
leGana(jinete(_), campeon(_)).
leGana(campeon(_), piquero(_, _)).
leGana(piquero(_, _), jinete(_)).
leGana(jinete(camello), jinete(caballo)).
leGana(Unidad1, Unidad2):-
  mismoTipo(Unidad1, Unidad2),
  vida(Unidad1, VidaUnidad1),
  vida(Unidad2, VidaUnidad2),
  VidaUnidad1 > VidaUnidad2.

mismoTipo(jinete(Animal), jinete(Animal)).
mismoTipo(campeon(_), campeon(_)).
mismoTipo(piquero(_, _), piquero(_, _)).

% Punto 9
puedeSobrevivirAUnAsedio(Jugador):-
  jugador(Jugador),
  % o findall + length
  aggregate_all(count, unidad(Jugador, piquero(true, _)), PiquerosConEscudo),
  aggregate_all(count, unidad(Jugador, piquero(false, _)), PiquerosSinEscudo),
  PiquerosConEscudo > PiquerosSinEscudo.

% Punto 10
% punto a
depende(herreria, emplumado).
depende(emplumado, punzon).
depende(herreria, forja).
depende(forja, fundicion).
depende(fundicion, horno).
depende(herreria, laminas).
depende(laminas, malla).
depende(malla, placas).
depende(molino, collera).
depende(collera, arado).

% punto b
puedeDesarrollar(Jugador, Tecnologia):-
  jugador(Jugador),
  distinct(tecnologiaMapa(Tecnologia)),
  not(desarrollo(Jugador, Tecnologia)),
  forall(dependencia(TecnologiaBase, Tecnologia), desarrollo(Jugador, TecnologiaBase)).

tecnologiaMapa(Tecnologia):-depende(Tecnologia, _).
tecnologiaMapa(Tecnologia):-depende(_, Tecnologia).

dependencia(TecnologiaBase, Tecnologia):-depende(TecnologiaBase, Tecnologia).
dependencia(TecnologiaBase, Tecnologia):-
  depende(TecnologiaBase, OtraTecnologia),
  dependencia(OtraTecnologia, Tecnologia).

% Punto 11
ordenValidoDesarrollo(Jugador, Tecnologias):-
  jugador(Jugador),
  findall(Tecnologia, desarrollo(Jugador, Tecnologia), TecnologiasPosibles),
  permutation(TecnologiasPosibles, Tecnologias),
  ordenValido(Jugador, Tecnologias).

ordenValido(_, []).
ordenValido(Jugador, [Tecnologia|Tecnologias]):-
  % forall(dependencia(TecnologiaBase, Tecnologia), not(member(TecnologiaBase, Tecnologias))),
  ordenValido(Jugador, Tecnologias).
