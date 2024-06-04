function sinal_filtrado = filtro_passe_banda(sinal, fa, f_passagem, f_corte_inf, f_corte_sup)
    % Aplicar um filtro de passa-banda ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % f_passagem: frequência central da banda de passagem
    % f_corte_inf: frequência de corte inferior da banda de passagem
    % f_corte_sup: frequência de corte superior da banda de passagem
f_corte_inf = 800;  % Frequência de corte inferior
f_corte_sup = 1600;  % Frequência de corte superior

% Verificar se os valores estão dentro da faixa esperada
if f_corte_inf < 0 || f_corte_inf > fa / 2 || f_corte_sup < 0 || f_corte_sup > fa / 2
    error('Valores de frequência de corte fora do intervalo permitido.');
end
    % Calcular a largura da banda de passagem
    largura_banda = f_corte_sup - f_corte_inf;

    % Normalizar as frequências de corte
    Wn = [f_corte_inf, f_corte_sup] / (fa / 2);

    % Definir a ordem do filtro de Butterworth
    ordem = 6; % Ajuste conforme necessário

    % Projetar o filtro de Butterworth
    [b, a] = butter(ordem, Wn, 'bandpass');

    % Aplicar o filtro ao sinal de áudio
    sinal_filtrado = filter(b, a, sinal);
end

