function sinal_processado = aplicar_wahwah(sinal, fa, parametros, largura_banda)
    % Aplicar o efeito de Wahwah ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % parametros: parâmetros específicos do efeito Wahwah (frequência central e banda de passagem)
    % largura_banda: largura da banda de passagem do filtro de Wahwah

    % Verificar se os parâmetros foram fornecidos
    if isempty(parametros)
        % Se nenhum parâmetro foi fornecido, usar valores padrão
        freq_central = 0.1; % Frequência central do Wahwah (ajustável)
        banda_passagem = 0.05; % Banda de passagem do Wahwah (ajustável)
    else
        % Extrair os parâmetros fornecidos
        freq_central = parametros(1);
        banda_passagem = parametros(2);
    end
    largura_banda = 0.1 * freq_central;
    % Calcular os parâmetros do filtro de Wahwah
    f_max = 1 - banda_passagem / 2;
    f_min = banda_passagem / 2;
    f = f_min + (f_max - f_min) * (1 + sin(2 * pi * freq_central * (0:length(sinal) - 1) / fa)) / 2;

    % Calcular as frequências de corte
    f_corte_inf = freq_central - largura_banda / 2;
    f_corte_sup = freq_central + largura_banda / 2;

    % Aplicar o filtro de Wahwah ao sinal de áudio
    sinal_processado = zeros(size(sinal));
    for i = 1:size(sinal, 2)
        sinal_processado(:, i) = filtro_passe_banda(sinal(:, i), fa, f, f_corte_inf, f_corte_sup);
    end
end

