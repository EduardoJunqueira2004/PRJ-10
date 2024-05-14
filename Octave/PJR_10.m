pkg load signal
clc; clear all; close all;
%Mini Projeto APS PL Data:14/04/24
%Eduardo Junqueira nº30241
%Gonçalo Guimarães nº20456
%-.------------------------------------------------------------
%JPRJ-10 Processador de Efeitos de áudio:Wahwah,tremolo e Reverb
%-.------------------------------------------------------------
%main:
% Solicitar o número do áudio desejado ao utilizador
numero_audio = input('Escolha o número do áudio (1, 2 ou 3): ');

% Verificar se o número de áudio está dentro do intervalo esperado
while numero_audio < 1 || numero_audio > 3
    % Exibir uma mensagem de erro
    disp('Número de áudio inválido. Escolha 1, 2 ou 3.');

    % Solicitar novamente o número do áudio ao utilizador
    numero_audio = input('Escolha o número do áudio (1, 2 ou 3): ');
end
% Carregar o sinal de áudio com base na escolha do utilizador
if numero_audio == 1
    [sinal, fa] = audioread('audio1.wav');
elseif numero_audio == 2
    [sinal, fa] = audioread('audio2.wav');
elseif numero_audio == 3
    [sinal, fa] = audioread('audio3.wav');
end

sound(sinal, fa);
% Solicitar a escolha de efeito ao utilizador
escolha = input('Escolha o efeito desejado (1 para Wahwah, 2 para Tremolo, 3 para Reverb): ');

parametros = []; % Parâmetros específicos do efeito% Chamar a função:

%Teste
% Chamar a função para aplicar o efeito ao sinal de áudio
sinal_processado = aplicar_efeito(sinal, fa, escolha, parametros);

% Reproduzir o áudio processado
sound(sinal_processado, fa);

% Obter o nome do arquivo original sem a extensão
[~, nome_arquivo, extensao] = fileparts(['audio' num2str(numero_audio) '.wav']);

% Criar o nome do novo arquivo com o sufixo do efeito aplicado
nome_arquivo_saida = [nome_arquivo '_com_wahwah' extensao];

% Salvar o áudio processado como um novo arquivo
audiowrite(nome_arquivo_saida, sinal_processado, fa);
disp(['Áudio processado salvo como ' nome_arquivo_saida]);
