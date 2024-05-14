function sinal_processado = aplicar_efeito(sinal, fa, escolha, parametros)
    % Selecionar o efeito com base na escolha do utilizador
    while true
        switch escolha
            case 1
                sinal_processado = aplicar_wahwah(sinal, fa, parametros);
                break
            case 2
                sinal_processado = aplicar_tremolo(sinal, fa, parametros);
                break
            case 3
                sinal_processado = aplicar_reverb(sinal, fa, parametros);
                break
            otherwise
                % Se a escolha for inválida, pedir uma nova entrada
                escolha = input('Escolha inválida. Por favor, escolha 1, 2 ou 3: ');
        end
    end
end
