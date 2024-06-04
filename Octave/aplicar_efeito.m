function sinal_processado = aplicar_efeito(sinal, fa, escolha, parametros, impulso)
    switch escolha
        case 1 % Wahwah
            sinal_processado = aplicar_wahwah(sinal, fa, parametros);
        case 2 % Tremolo
            sinal_processado = aplicar_tremolo(sinal, fa, parametros);
        case 3 % Reverb
            if isempty(impulso)
                error('Impulso não carregado para o efeito Reverb.');
            end
            sinal_processado = aplicar_reverb(sinal, fa, impulso);
        otherwise
            error('Escolha de efeito inválida.');
    end
end

function sinal_processado = aplicar_wahwah(sinal, fa, parametros)
    freq_central = parametros(1);
    banda_passagem = parametros(2);
    largura_banda = 0.1 * freq_central;
    f_max = 1 - banda_passagem / 2;
    f_min = banda_passagem / 2;
    f = f_min + (f_max - f_min) * (1 + sin(2 * pi * freq_central * (0:length(sinal) - 1) / fa)) / 2;
    f_corte_inf = f - largura_banda / 2;
    f_corte_sup = f + largura_banda / 2;
    sinal_processado = zeros(size(sinal));
    for i = 1:size(sinal, 2)
        sinal_processado(:, i) = filtro_passe_banda(sinal(:, i), fa, f_corte_inf(i), f_corte_sup(i));
    end
    sinal_processado = normalize(sinal_processado, 'range');
end

function sinal_filtrado = filtro_passe_banda(sinal, fa, f_corte_inf, f_corte_sup)
    [b, a] = butter(2, [f_corte_inf f_corte_sup] / (fa / 2), 'bandpass');
    sinal_filtrado = filter(b, a, sinal);
end

function sinal_processado = aplicar_tremolo(sinal, fa, parametros)
    % Implementar o efeito Tremolo
    % ...
end

function sinal_processado = aplicar_reverb(sinal, fa, impulso)
    % Aplicar a convolução para cada canal separadamente
    sinal_processado = zeros(size(sinal));
    for i = 1:size(sinal, 2)
        sinal_processado(:, i) = conv(sinal(:, i), impulso, 'same');
    end
    % Normalizar o sinal processado
    sinal_processado = normalize(sinal_processado, 'range');
end

