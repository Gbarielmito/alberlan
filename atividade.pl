% Fatos sobre doenças
doenca(gripe).
doenca(resfriado).
doenca(covid_19).
doenca(alergia).

% Fatos sobre sintomas
sintoma(febre).
sintoma(dor_cabeca).
sintoma(dor_corpo).
sintoma(tosse).
sintoma(coriza).
sintoma(espirros).
sintoma(dor_garganta).
sintoma(falta_ar).
sintoma(coceira_olhos).
sintoma(contato_covid).

% Regras de diagnóstico
% Gripe: febre + dor de cabeça + dor no corpo + tosse
diagnostico(gripe, Sintomas) :-
    member(febre, Sintomas),
    member(dor_cabeca, Sintomas),
    member(dor_corpo, Sintomas),
    member(tosse, Sintomas).

% Resfriado: coriza + espirros + dor de garganta
diagnostico(resfriado, Sintomas) :-
    member(coriza, Sintomas),
    member(espirros, Sintomas),
    member(dor_garganta, Sintomas).

% COVID-19: febre + tosse + (falta de ar OU contato com infectado)
diagnostico(covid_19, Sintomas) :-
    member(febre, Sintomas),
    member(tosse, Sintomas),
    (member(falta_ar, Sintomas); member(contato_covid, Sintomas)).

% Alergia: espirros + coceira nos olhos + coriza (sem febre)
diagnostico(alergia, Sintomas) :-
    member(espirros, Sintomas),
    member(coceira_olhos, Sintomas),
    member(coriza, Sintomas),
    not(member(febre, Sintomas)).

% Regras adicionais para casos parciais
% Gripe leve (sem febre alta)
diagnostico(gripe_leve, Sintomas) :-
    not(member(febre, Sintomas)),
    member(dor_cabeca, Sintomas),
    member(dor_corpo, Sintomas),
    member(tosse, Sintomas).

% COVID-19 assintomático (apenas contato)
diagnostico(covid_19_assintomatico, Sintomas) :-
    member(contato_covid, Sintomas),
    not(member(febre, Sintomas)),
    not(member(tosse, Sintomas)).

% Resfriado com tosse
diagnostico(resfriado, Sintomas) :-
    member(coriza, Sintomas),
    member(espirros, Sintomas),
    member(tosse, Sintomas),
    not(member(febre, Sintomas)).

% Alergia respiratória (sem coceira nos olhos)
diagnostico(alergia_respiratoria, Sintomas) :-
    member(espirros, Sintomas),
    member(coriza, Sintomas),
    not(member(coceira_olhos, Sintomas)),
    not(member(febre, Sintomas)).

% Consulta principal
diagnosticar :-
    writeln('Sistema de Diagnóstico Médico'),
    writeln('Sintomas disponíveis:'),
    writeln('1. febre        2. dor_cabeca   3. dor_corpo    4. tosse'),
    writeln('5. coriza       6. espirros     7. dor_garganta 8. falta_ar'),
    writeln('9. coceira_olhos 10. contato_covid'),
    nl,
    writeln('Digite os sintomas como uma lista Prolog (ex.: [febre,dor_cabeca,tosse]):'),
    read(SintomasInput),
    nl,
    
    % Encontra todos os diagnósticos possíveis
    findall(Doenca, diagnostico(Doenca, SintomasInput), Doencas),
    
    % Remove duplicatas
    sort(Doencas, DoencasUnicas),
    
    % Mostra resultados
    (   DoencasUnicas = [] 
    ->  writeln('Nenhum diagnóstico corresponde aos sintomas fornecidos.')
    ;   writeln('Possíveis diagnósticos:'),
        listar_diagnosticos(DoencasUnicas)
    ).

% Auxiliar para listar diagnósticos
listar_diagnosticos([]).
listar_diagnosticos([D|Resto]) :-
    write('- '), write(D), nl,
    listar_diagnosticos(Resto).