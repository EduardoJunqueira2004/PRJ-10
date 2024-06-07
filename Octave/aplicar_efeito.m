function sinal_processado = aplicar_efeito(sinal, fa, escolha, parametros, impulso)
  if isempty(parametros)
        parametros = [];
    end
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
    % Aplicar o efeito Wahwah ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % parametros: parâmetros específicos do efeito Wahwah (frequência central e largura de banda)
    disp('Aplicando efeito WahWah...'); % Mensagem de depuração

    % Verificar se os parâmetros foram fornecidos
    if isempty(parametros)
        % Se nenhum parâmetro foi fornecido, usar valores padrão
        freq_central = 1.5; % Frequência central de modulação do Wahwah (ajustável)
        largura_banda = 500; % Largura de banda do Wahwah em Hz (ajustável)
    else
        % Extrair os parâmetros fornecidos
        freq_central = parametros(1);
        largura_banda = parametros(2);
    end

    % Inicializar o sinal processado
    sinal_processado = zeros(size(sinal));

    % Calcular os parâmetros do filtro Wahwah
    t = (0:length(sinal) - 1) / fa;
    mod_signal = 0.5 * (1 + sin(2 * pi * freq_central * t)); % Sinal de modulação no intervalo [0, 1]

    % Definir a faixa de frequência para o efeito Wahwah
    f_min = 300; % Frequência mínima do Wahwah em Hz
    f_max = 3000; % Frequência máxima do Wahwah em Hz

    % Loop para aplicar o efeito Wahwah ao sinal de áudio
    for i = 1:size(sinal, 2)
        % Aplicar o filtro passa-banda em blocos
        bloco_tamanho = 1024;
        for j = 1:bloco_tamanho:length(sinal)
            fim_bloco = min(j + bloco_tamanho - 1, length(sinal));

            % Gerar as frequências de corte moduladas
            f_corte_central = f_min + (f_max - f_min) * mod_signal(j:fim_bloco); % Frequência central modulada
            f_corte_inf = max(f_corte_central - largura_banda / 2, 20); % Frequência mínima de 20 Hz
            f_corte_sup = min(f_corte_central + largura_banda / 2, fa / 2); % Frequência máxima fa/2

            % Obter as médias das frequências de corte para o bloco
            f_corte_inf_mean = mean(f_corte_inf);
            f_corte_sup_mean = mean(f_corte_sup);

            % Normalizar as frequências de corte em relação à frequência de Nyquist
            Wn = [f_corte_inf_mean f_corte_sup_mean] / (fa / 2);

            % Verificar se as frequências de corte são válidas e em ordem ascendente
            if Wn(1) < Wn(2) && all(Wn > 0 & Wn < 1)
                [b, a] = butter(2, Wn, 'bandpass');
                bloco_sinal = sinal(j:fim_bloco, i);
                bloco_filtrado = filter(b, a, bloco_sinal);
                sinal_processado(j:fim_bloco, i) = bloco_filtrado;
            else
                sinal_processado(j:fim_bloco, i) = sinal(j:fim_bloco, i);
            end
        end
    end

    % Normalizar o sinal processado
    max_val = max(abs(sinal_processado(:)));
    if max_val > 0
        sinal_processado = sinal_processado / max_val; % Normalização manual
    end

    % Mensagem de depuração para confirmar o processamento
    disp('Efeito WahWah aplicado com sucesso.');
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

