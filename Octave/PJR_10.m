pkg load signal
clc; clear all; close all;

%-.------------------------------------------------------------
%JPRJ-10 Processador de Efeitos de áudio:Wahwah,tremolo e Reverb
%funções:
function sinal_processado = aplicar_efeito(sinal, fa, escolha, parametros)
    % Aplicar o efeito selecionado ao sinal de áudio
    % sinal: sinal de áudio original
    % fa: frequência de amostragem do sinal
    % escolha: inteiro indicando o efeito desejado (1 para Wahwah, 2 para Tremolo, 3 para Reverb)
    % parametros: parâmetros específicos do efeito (pode ser vazio para alguns efeitos)


    % Selecionar o efeito com base na escolha do usuário
    switch escolha
        case 1
            sinal_processado = aplicar_wahwah(sinal, fa, parametros);
        case 2
            sinal_processado = aplicar_tremolo(sinal, fa, parametros);
        case 3
            sinal_processado = aplicar_reverb(sinal, fa, parametros);
        otherwise
            error('Escolha inválida.');
    end
end

%-.------------------------------------------------------------
%main:
% Solicitar o número do áudio desejado ao usuário
numero_audio = input('Escolha o número do áudio (1, 2 ou 3): ');

% Verificar se o número de áudio está dentro do intervalo esperado
while numero_audio < 1 || numero_audio > 3
    % Exibir uma mensagem de erro
    disp('Número de áudio inválido. Escolha 1, 2 ou 3.');

    % Solicitar novamente o número do áudio ao usuário
    numero_audio = input('Escolha o número do áudio (1, 2 ou 3): ');
end
% Carregar o sinal de áudio com base na escolha do usuário
if numero_audio == 1
    [sinal, fa] = audioread('audio1.wav');
    sound(sinal, fa);
elseif numero_audio == 2
    [sinal, fa] = audioread('audio2.wav');
    sound(sinal, fa);
elseif numero_audio == 3
    [sinal, fa] = audioread('audio3.wav');
    sound(sinal, fa);

end


% Definir a escolha de efeito e os parâmetros (caso necessário)

% Solicitar a escolha de efeito ao usuário
escolha = input('Escolha o efeito desejado (1 para Wahwah, 2 para Tremolo, 3 para Reverb): ');

parametros = []; % Parâmetros específicos do efeito, se aplicável

% Chamar a função para aplicar o efeito ao sinal de áudio
sinal_processado = aplicar_efeito(sinal, fa, escolha, parametros);

