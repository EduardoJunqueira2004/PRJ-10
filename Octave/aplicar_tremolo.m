function sinal_processado = aplicar_tremolo(sinal, fa, parametros)
    % Aplicar o efeito de Tremolo ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % parametros: parâmetros específicos do efeito Tremolo (frequência e profundidade)

    disp('Aplicando efeito Tremolo...'); % Mensagem de depuração

    % Extrair os parâmetros fornecidos
    freq_tremolo = parametros(1);
    profundidade = parametros(2);

    % Calcular a modulação do tremolo
    t = (0:length(sinal) - 1) / fa;
    mod = (1 + profundidade * sin(2 * pi * freq_tremolo * t))';

    % Aplicar a modulação ao sinal
    sinal_processado = sinal .* mod;

    %Normalizar o sinal processado
    sinal_processado=normalize(sinal_processado, 'range');
end

