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
function sinal_filtrado = filtro_passe_banda(sinal, fa, f_corte_inf, f_corte_sup)
    % Verificar se as frequências de corte estão no intervalo correto
    f_corte_inf = max(f_corte_inf, 0);
    f_corte_sup = min(f_corte_sup, fa / 2);

    % Normalizar as frequências de corte em relação à frequência de Nyquist
    Wn = [f_corte_inf f_corte_sup] / (fa / 2);

    % Garantir que Wn está dentro do intervalo [0, 1]
    if any(Wn <= 0) || any(Wn >= 1)
        error('As frequências de corte normalizadas devem estar entre 0 e 1.');
    end

    % Filtro de passa-banda
    [b, a] = butter(2, Wn, 'bandpass');
    sinal_filtrado = filter(b, a, sinal);
end

function sinal_processado = aplicar_wahwah(sinal, fa, parametros)
    % Aplicar o efeito de Wahwah ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % parametros: parâmetros específicos do efeito Wahwah (frequência central e banda de passagem)

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

    % Inicializar o sinal processado
    sinal_processado = zeros(size(sinal));

    % Aplicar o filtro de Wahwah ao sinal de áudio
    for i = 1:size(sinal, 2)
        f_corte_inf = f - largura_banda / 2;
        f_corte_sup = f + largura_banda / 2;
        % Garantir que as frequências de corte estão dentro do intervalo permitido
        f_corte_inf = max(f_corte_inf, 0);
        f_corte_sup = min(f_corte_sup, fa / 2);
        sinal_processado(:, i) = filtro_passe_banda(sinal(:, i), fa, f_corte_inf, f_corte_sup);
    end

    % Normalizar o sinal processado
    sinal_processado = normalize(sinal_processado, 'range');
end


function sinal_processado = aplicar_tremolo(sinal, fa, parametros)
    % Aplicar o efeito de Tremolo ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % parametros: parâmetros específicos do efeito Tremolo (frequência e profundidade)

    disp('Aplicando efeito Tremolo...'); % Mensagem de depuração

    % Verificar se os parâmetros foram fornecidos corretamente
    if length(parametros) < 2
        error('Parâmetros insuficientes. Forneça a frequência e a profundidade do tremolo.');
    end

    % Extrair os parâmetros fornecidos
    freq_tremolo = parametros(1);
    profundidade = parametros(2);

    % Calcular a modulação do tremolo
    t = (0:length(sinal) - 1) / fa;
    mod = (1 + profundidade * sin(2 * pi * freq_tremolo * t))';

    % Aplicar a modulação ao sinal
    sinal_processado = sinal .* mod;

    % Normalizar o sinal processado
    sinal_processado = normalize(sinal_processado, 'range');

    % Mensagem de depuração para confirmar o processamento
    disp('Efeito Tremolo aplicado com sucesso.');
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

