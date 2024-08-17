% Aquí va el código.

% 1_
%persona(Persona).

persona(ana).
persona(beto).
persona(carola).
persona(dimitri).

%civilizacion(Tipo).

civilizacion(romanos).
civilizacion(incas).

%personaJuegaCon(Persona,Civilizacion).

personaJuegaCon(ana,romanos).
personaJuegaCon(beto,incas).
personaJuegaCon(carola,romanos).
personaJuegaCon(dimitri,romanos).

%tecnologia(Tecnologia).

tecnologia(herreria).
tecnologia(forja).
tecnologia(fundicion).
tecnologia(emplumado).
tecnologia(laminas).

%tecnologias(Persona,[Tecnologia]).

personaDesarrollo(ana,[herreria,forja,emplumado,laminas]).
personaDesarrollo(beto,[herreria,forja,fundicion]).
personaDesarrollo(carola,[herreria]).
personaDesarrollo(dimitri,[herreria,fundicion]).

% 2_

%expertoEnMateriales(Persona)

expertoEnMateriales(Persona) :- personaDesarrollo(Persona,Tecnologias),
                                member(herreria,Tecnologias), member(forja,Tecnologias),
                                member(fundicion,Tecnologias).
expertoEnMateriales(Persona) :- personaDesarrollo(Persona,Tecnologias),
                                member(herreria,Tecnologias), member(forja,Tecnologias),
                                personaJuegaCon(Persona,romanos).

%3_

%civilizacionEsPopular(Civilizacion).

civilizacionEsPopular(Civilizacion) :-  civilizacion(Civilizacion),
                                        findall(Civilizacion,personaJuegaCon(_,Civilizacion), Lista),
                                        length(Lista, Numero), Numero > 1.

%4_

%tieneDesarrollada(Persona,Tecnologia).

tieneDesarrollada(Persona,Tecnologia) :- personaDesarrollo(Persona,ListaTecnologias),member(Tecnologia,ListaTecnologias).

%alcanceGlobal(Tecnologia).

alcanceGlobal(Tecnologia) :- tecnologia(Tecnologia),
                             forall(persona(Persona),tieneDesarrollada(Persona,Tecnologia)).

%5_

tecnologiasSegunCivilizacion(Civilizacion,ListaBuena) :- civilizacion(Civilizacion), 
                                                        findall(Tecnologia,(personaJuegaCon(Persona,Civilizacion),personaDesarrollo(Persona,Tecnologias),member(Tecnologia,Tecnologias)), Lista), 
                                                        list_to_set(Lista, ListaBuena).
 

%civilizacionLider(Civilizacion).

civilizacionLider(Civilizacion) :- civilizacion(Civilizacion), 
                                   tecnologiasSegunCivilizacion(Civilizacion,Lista1),
                                   forall(civilizacion(OtraCivilizacion), (tecnologiasSegunCivilizacion(OtraCivilizacion,Lista2),subset(Lista2,Lista1))).
                                   
                                   

%UNIDADES

%6_

personaTiene(ana, [jinete(caballo), piquero(escudo, 1), piquero(sinEscudo, 2)]).
personaTiene(beto, [campeon(100), campeon(80), piquero(escudo, 1), jinete(camello)]).
personaTiene(carola, [piquero(sinEscudo, 3), piquero(escudo, 2)]).
personaTiene(dimitri, []).

%7_

%obtenerVida(Unidad, Vida).
obtenerVida(campeon(VidaDelCampeon), VidaDelCampeon).
obtenerVida(jinete(camello), 80).
obtenerVida(jinete(caballo), 90).
obtenerVida(piquero(escudo, 1), 55).
obtenerVida(piquero(escudo, 2), 71.5).
obtenerVida(piquero(escudo, 3), 77).
obtenerVida(piquero(sinEscudo, 1), 50).
obtenerVida(piquero(sinEscudo, 2), 65).
obtenerVida(piquero(sinEscudo, 3), 70).

compararVida(Unidad1, Unidad2, Unidad1) :- obtenerVida(Unidad1, Vida1), obtenerVida(Unidad2, Vida2), Vida1 >= Vida2, Unidad1 \= Unidad2.
compararVida(Unidad1, Unidad2, Unidad2) :- obtenerVida(Unidad1, Vida1), obtenerVida(Unidad2, Vida2), Vida1 < Vida2,Unidad1 \= Unidad2.

buscarUnidadMasVida([Unidad], Unidad).
buscarUnidadMasVida([PrimeraUnidad | UnidadesRestantes], Unidad) :- buscarUnidadMasVida(UnidadesRestantes, UnidadTemporal), compararVida(PrimeraUnidad, UnidadTemporal, Unidad).

unidadConMasVida(Persona, Unidad) :- personaTiene(Persona, Unidades), buscarUnidadMasVida(Unidades, Unidad).

%8_

enfrentarUnidades(jinete(_), campeon(_), jinete(_)) :- !.
enfrentarUnidades(campeon(_), jinete(_), jinete(_)) :- !.
enfrentarUnidades(campeon(_), piquero(_,_), campeon(_)) :- !.
enfrentarUnidades(piquero(_,_), campeon(_), campeon(_)) :- !.
enfrentarUnidades(piquero(_,_), jinete(_), piquero(_,_)) :- !.
enfrentarUnidades(jinete(_), piquero(_,_), piquero(_,_)) :- !.
enfrentarUnidades(jinete(caballo), jinete(_), jinete(caballo)) :- !.
enfrentarUnidades(jinete(_), jinete(caballo), jinete(caballo)) :- !.

enfrentarUnidades(Unidad1, Unidad2, Unidad) :- compararVida(Unidad1, Unidad2, Unidad).

%9_ 

sobrevivirAsedio(Persona) :- persona(Persona), 
                           findall(1, (personaTiene(Persona, Unidades), member(piquero(escudo,_), Unidades)), ListaEscudos), 
                           findall(1, (personaTiene(Persona, Unidades), member(piquero(sinEscudo,_), Unidades)), ListaSinEscudos), 
                           length(ListaEscudos, Cantidad1) ,
                           length(ListaSinEscudos, Cantidad2), 
                           Cantidad1 > Cantidad2.

%10 

arbol(herreria, []).
arbol(emplumado, [herreria]). 
arbol(forja, [herreria]).
arbol(laminas, [herreria]).
arbol(punta, [herreria, emplumado]).
arbol(fundicion, [herreria, forja]).
arbol(mallado, [herreria, laminas]).
arbol(horno, [herreria, forja, fundicion]).
arbol(placas, [herreria, laminas, mallado]).
arbol(molino, []).
arbol(collera, [molino]).
arbol(arado, [molino, collera]).

comprobarDesarrollo(Tecnologia, Tecnologias) :- tecnologia(Tecnologia), (member(Tecnologia, Tecnologias)).

puedeDesarrollar(Tecnologia, Persona) :- personaDesarrollo(Persona, Tecnologias), arbol(Tecnologia, Dependencias), comprobarDesarrollo(Tecnologia, Tecnologias), subset(Dependencias, Tecnologias).

% Consulta a puedeDesarrollar(Tecnologia, Persona).
% Tecnologia = herreria,
% Persona = ana ;
% Tecnologia = emplumado,
% Persona = ana ;
% Tecnologia = forja,
% Persona = ana ;
% Tecnologia = laminas,
% Persona = ana ;
% Tecnologia = herreria,
% Persona = beto ;
% Tecnologia = forja,
% Persona = beto ;
% Tecnologia = fundicion,
% Persona = beto ;
% Tecnologia = herreria,
% Persona = carola ;
% Tecnologia = herreria,
% Persona = dimitri ;
% false.

%11 ordenValido(Persona,ListaOrdenada).

nivel(Tecnologia,Nivel) :- arbol(Tecnologia,Lista), length(Lista,Nivel).

obtenerMaximoNivel([], ListaNueva, ListaNueva).

obtenerMaximoNivel(Tecnologias, Acumulador, ListaNueva) :-
                                                            Tecnologias \= [],
                                                            findall(Nivel, (member(Tecno, Tecnologias), nivel(Tecno, Nivel)), ListaNiveles),
                                                            max_member(Mayor, ListaNiveles),
                                                            findall(Tecnologia, (member(Tecnologia, Tecnologias), arbol(Tecnologia, Lista), length(Lista, Longitud), Longitud == Mayor), ListaAux),
                                                            subtract(Tecnologias, ListaAux, ListaRecortada), 
                                                            append(Acumulador, ListaAux, NuevoAcumulador), 
                                                            obtenerMaximoNivel(ListaRecortada, NuevoAcumulador, ListaNueva).


ordenValido(Persona,ListaOrdenada) :- personaDesarrollo(Persona,Tecnologias), obtenerMaximoNivel(Tecnologias,[], ListaAlReves), reverse(ListaAlReves,ListaOrdenada).
