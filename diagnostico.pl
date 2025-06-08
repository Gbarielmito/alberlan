% ------------------------------------------
% Base de Conhecimento: Sintomas e Doenças
% ------------------------------------------

:- dynamic(presente/1).  % Permite adicionar sintomas em tempo de execução

% Doenças
doenca(gripe).
doenca(resfriado).
doenca(dengue).
doenca(pneumonia).

% Sintomas
sintoma(febre).
sintoma(dor_cabeca).
sintoma(tosse).
sintoma(dor_garganta).
sintoma(coriza).
sintoma(cansaco).
sintoma(dor_muscular).
sintoma(falta_ar).
% ------------------------------------------
% Regras de Inferência com Pontuação
% ------------------------------------------

% Cada regra contribui com uma pontuação para a doença.
% Use pesos de 1.0 a 0.1 para ajustar a influência.

% Gripe
pontuar(gripe, 0.4) :- presente(febre).
pontuar(gripe, 0.3) :- presente(dor_cabeca).
pontuar(gripe, 0.3) :- presente(dor_muscular).

% Resfriado
pontuar(resfriado, 0.5) :- presente(coriza).
pontuar(resfriado, 0.3) :- presente(tosse).
pontuar(resfriado, 0.2) :- presente(dor_garganta).

% Dengue
pontuar(dengue, 0.4) :- presente(febre).
pontuar(dengue, 0.3) :- presente(dor_cabeca).
pontuar(dengue, 0.2) :- presente(dor_muscular).
pontuar(dengue, 0.1) :- presente(cansaco).

% Pneumonia
pontuar(pneumonia, 0.4) :- presente(febre).
pontuar(pneumonia, 0.3) :- presente(tosse).
pontuar(pneumonia, 0.3) :- presente(falta_ar).

% ------------------------------------------
% Consulta principal
% ------------------------------------------

consulta :-
    writeln('Digite seus sintomas (use ponto final depois de cada).'),
    writeln('Exemplo: assert(presente(febre)).'),
    writeln('Digite todos os sintomas antes de chamar diagnosticar/0.'),
    writeln('Digite diagnosticar. para ver possíveis doenças.').

% Diagnóstico probabilístico
diagnosticar :-
    findall(D, doenca(D), Doencas),
    diagnosticar_todas(Doencas).

diagnosticar_todas([]).
diagnosticar_todas([Doenca | Resto]) :-
    calcular_probabilidade(Doenca, Probabilidade),
    format('Probabilidade de ~w: ~2f~n', [Doenca, Probabilidade]),
    diagnosticar_todas(Resto).

% Calcula a soma das pontuações para cada doença
calcular_probabilidade(Doenca, Probabilidade) :-
    findall(P, pontuar(Doenca, P), Pontuacoes),
    sumlist(Pontuacoes, Soma),
    Probabilidade is min(Soma, 1.0).

% ------------------------------------------
% Exemplo de uso:
% ?- consulta.
% ?- assert(presente(febre)).
% ?- assert(presente(dor_cabeca)).
% ?- assert(presente(dor_muscular)).
% ?- diagnosticar.
% Probabilidade de gripe: 1.00
% Probabilidade de resfriado: 0.00
% Probabilidade de dengue: 0.90
% Probabilidade de pneumonia: 0.40
% ------------------------------------------