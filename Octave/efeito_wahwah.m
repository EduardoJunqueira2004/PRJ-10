function sinal_processado = aplicar_wahwah(sinal, fa, parametros)
    % Aplicar o efeito de Wahwah ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % parametros: parâmetros específicos do efeito Wahwah (frequência central e banda de passagem)

    % Verificar se os parâmetros foram fornecidos
    if isempty(parametros)
        % Se nenhum parâmetro foi fornecido, usar valores padrão
        freq_central = 0.5; % Frequência central do Wahwah
        banda_passagem = 0.2; % Banda de passagem do Wahwah
    else
        % Extrair os parâmetros fornecidos
        freq_central = parametros(1);
        banda_passagem = parametros(2);
    end

    % Calcular os parâmetros do filtro de Wahwah
    f_max = 1 - banda_passagem / 2;
    f_min = banda_passagem / 2;
    f = f_min + (f_max - f_min) * (1 + sin(2 * pi * freq_central * (0:length(sinal) - 1) / fa)) / 2;

    % Aplicar o filtro de Wahwah ao sinal de áudio
    sinal_processado = zeros(size(sinal));
    for i = 1:size(sinal, 2)
        sinal_processado(:, i) = filtro_passe_banda(sinal(:, i), f, fa);
    end
end

% Função para aplicar um filtro de passa-banda ao sinal de áudio
function sinal_filtrado = filtro_passe_banda(sinal, f, fa)
    % Aplicar um filtro de passa-banda ao sinal de áudio
    % sinal: sinal de áudio original
    % f: vetor de frequências para o filtro
    % fa: frequência de amostragem do sinal

    % Criar o filtro de passa-banda
    ordem = 8; % Ordem do filtro
    filtro = fir1(ordem, f * 2);

    % Aplicar o filtro ao sinal de áudio
    sinal_filtrado = filter(filtro, 1, sinal);
end

