function imp_resp = reverberationIR(fa, tempo_reverb)
    % Gera uma resposta ao impulso para simular o efeito de reverb
    imp_resp_len = round(tempo_reverb * fa);
    imp_resp = randn(imp_resp_len, 1);
    imp_resp = imp_resp - mean(imp_resp); % Remover o componente de DC
    imp_resp = imp_resp / max(abs(imp_resp)); % Normalizar para amplitude máxima de 1
    imp_resp = [imp_resp; zeros(2 * imp_resp_len, 1)]; % Adicionar eco para prolongar o reverb

