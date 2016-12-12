%%%% <Matricola> <Cognome> <Nome>
%%%% <eventuali collaborazioni>

%version 1.2 (Luka)

% DA FARE:
%	x*x=x^2
%	Sorting

%as_monomial(F1 * F2, M) :-	
%	M = m(C, TD, VPs),
%	totalDegree(F1 * F2, TD),	
%	coeff(F1 * F2, C),
%	preMono(F1 * F2, VPsN),
%	predsort(compare, VPsN, VPs),
%	!.

as_monomial(F1, M) :-
	M = m(C, TD, VPs),
	totalDegree(F1, TD),
	coeff(F1, C),
	preMono(F1, VPs),
	!.

as_monomial(F1 * F2, M) :-	
	M = m(C, TD, EVPs),
	inList(F1 * F2, VPs),
	msort(VPs, OVPs),
	toListInExp(OVPs, EVPs),
	totalDegree(EVPs, TD),	
	coeff(EVPs, C),
	!.

%toListInExp([], EVPs).

toListInExp([X], X).

toListInExp([X | OVPs], X * EVPs) :-
	toListInExp(OVPs, EVPs),
	!.
	

inList(F1, [F1^1]) :-
	 atom(F1),
	 !.
	 
inList(F1 ^ F2, [F1^F2]) :-
	 atom(F1),
	 number(F2),
	 !.
	 
%inList(F1, [F1]) :-
%	 atom(F1),
%	 !.
	 
inList(F1, [F1]) :-
	 number(F1),
	 !.

inList(F1 * F2, Ls):-
	 inList(F1, Ls2),
	 append([F2], Ls2, Ls),
	 !.

compare(v(_, X), v(_, Y)) :-
	sort([X, Y], [X, Y]).

totalDegree(F1 * F2, TD) :-		%calcolo il grado del monomio
	listTD(F1 * F2, L),
	sum(L, TD),
	!.

totalDegree(F1, TD) :-
	listTD(F1, L),
	sum(L, TD),
	!.

listTD(F1 * F2, [L | Ls]) :-		
	extractD(F2, TD1),
	L is TD1,
	!,
	listTD(F1, Ls).

listTD(F1, [L]) :-
	extractD(F1, TD1),
	L is TD1.

	
extractD(F1 ^ _, 0) :-			%se F1 è un numero il primo elemento 
	number(F1),				%e una potenza, dunque non lo 
	!.					%consideriamo
	
extractD(F1 ^ F2, TD1) :-
	\+ number(F1),
	integer(F2),
	TD1 is F2,
	!.
	
extractD(F1, 0):-
	number(F1),
	!.

extractD(_, 1).

sum([], 0).				%calcolo la somma di una lista di numeri
sum([X], X).			%utile per il grado massimo
sum([X, Y | Ys], T):- 
	S is X+Y, 
	sum([S | Ys], T).    

coeff(F1 * F2, C):-		%calcolo il coefficente del monomio
	listC(F1 * F2, L),
	product(L, C),
	!.

coeff(F1, C) :-
	listC(F1, L),
	product(L,C),
	!.

listC(F1 * F2, [F2 | Cs]) :-		%se F2 è un numero lo aggiungo
	integer(F2),
	listC(F1, Cs).
	
listC(F1 * F2, [C | Cs]) :-		%se F2 è una potenza, la calcolo e 
	is_pow(F2, C),			%aggiungo il risultato alla lista
	listC(F1, Cs),
	!.
	

listC(F1 * _, Cs) :-			%se F2 è altro non lo aggiungo
	listC(F1, Cs),
	!.
	
listC(F1, [C]) :-
	integer(F1),
	C is F1, 
	!.

listC(F1, [C]) :-
	is_pow(F1, C),
	!.
	
listC(_, [1]) :-
	!.

is_pow(F1^F2,P):-			%F1^F2 è una potenza se entrambi sono
	number(F1),			%numeri, P è il risultato
	number(F2),
	pow2(F1,F2,P).

pow2(X,Y,Z) :- Z is X**Y.

product([], 1).			%calcolo il prodotto di una lista di numeri
 					%utile per il calcolo del coefficente
product([X], R) :- 
	R is X,
	!.
	
product([X, Y | Xs], R) :- 
	R1 is X * Y, 
	product([R1 | Xs], R).


preMono(F1 * F2, M) :-		%scrivo il monomio con la notazione v(C,I)
	number(F2),			%se F2 è un numero non lo considero
	!,
	preMono(F1, M).

preMono(F1 * F2, M) :-		%se F2 è una potenza non la considero
	is_pow(F2, _),
	!,
	preMono(F1, M).
	
preMono(F1 * F2, [M | Ms]) :- %altrimenti lo considero
	as_exp(F2, M),
	!,
	preMono(F1, Ms).
	
preMono(F1, []) :-
	number(F1),
	!.

preMono(F1, []) :-
	is_pow(F1, _),
	!.
	
preMono(F1, [M]) :-
	!,
	as_exp(F1, M).

as_exp(F1 ^ F2, M) :-
	\+ number(F1),
	M = v(F2, F1),
	!.
	
as_exp(F1, M) :-
	\+ number(F1),
	M = v(1, F1),
	!.
