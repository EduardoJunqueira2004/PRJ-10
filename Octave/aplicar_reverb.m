function sinal_processado = aplicar_reverb(sinal, fa, parametros)
    % Aplicar o efeito de Reverb ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % parametros: parâmetros específicos do efeito Reverb (tempo de reverb)

    disp('Aplicando efeito Reverb...'); % Mensagem de depuração

    % Extrair os parâmetros fornecidos
    tempo_reverb = parametros(1);

    % Gerar a resposta ao impulso para o efeito de reverb
    imp_resp = reverberationIR(fa, tempo_reverb);

    % Aplicar a convolução para cada canal separadamente
    sinal_processado = zeros(size(sinal));
    for i = 1:size(sinal, 2)
        sinal_processado(:, i) = conv(sinal(:, i), imp_resp, 'same');
    end

    % Normalizar o sinal processado
    sinal_processado = normalize(sinal_processado, 'range');
end

function imp_resp = reverberationIR(fa, tempo_reverb)
    % Gera uma resposta ao impulso para simular o efeito de reverb
    imp_resp_len = round(tempo_reverb * fa);
    imp_resp = randn(imp_resp_len, 1);
    imp_resp = imp_resp - mean(imp_resp); % Remover o componente de DC
    imp_resp = imp_resp / max(abs(imp_resp)); % Normalizar para amplitude máxima de 1
    imp_resp = [imp_resp; zeros(2 * imp_resp_len, 1)]; % Adicionar eco para prolongar o reverb
end

