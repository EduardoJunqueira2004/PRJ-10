pkg load signal
clc; clear all; close all;

% Mini Projeto APS PL Data:17/06/24
% Eduardo Junqueira nº30241
% Gonçalo Guimarães nº20456
% -.------------------------------------------------------------
% JPRJ-10 Processador de Efeitos de áudio: Wahwah, Tremolo e Reverb
% -.------------------------------------------------------------

% Solicitar o número do áudio desejado ao utilizador
numero_audio = input('Escolha o número do áudio (1, 2): ');

% Verificar se o número de áudio está dentro do intervalo esperado
while numero_audio < 1 || numero_audio > 2
    % Exibir uma mensagem de erro
    disp('Número de áudio inválido. Escolha 1 ou 2.');
    % Solicitar novamente o número do áudio ao utilizador
    numero_audio = input('Escolha o número do áudio (1, 2): ');
end

% Carregar o sinal de áudio com base na escolha do utilizador
if numero_audio == 1
    [sinal, fa] = audioread('Input.wav');
elseif numero_audio == 2
    [sinal, fa] = audioread('Arctic Monkeys - Whyd You Only Call Me When Youre High.wav');
end

% Reproduzir o áudio original
sound(sinal, fa);

% Solicitar a escolha de efeito ao utilizador
escolha_efeito = input('Escolha o efeito desejado (1 para Wahwah, 2 para Tremolo, 3 para Reverb): ');

% Definir os parâmetros de acordo com o efeito escolhido
if escolha_efeito == 1
    % Parâmetros do efeito Wahwah
    parametros = [0.5, 900]; % Frequência central e largura da banda de passagem
elseif escolha_efeito == 2
    % Parâmetros do efeito Tremolo
    parametros = [0.5, 1]; % Frequência central e largura da banda de passagem

else
    parametros = []; % Parâmetros vazios para Reverb
end

% Se o efeito escolhido for Reverb, solicitar impulso
if escolha_efeito == 3
    while true
        % Exibir o menu de impulsos
        disp('Escolha o impulso desejado:');
        disp('1: Impulso 1 - Sala 1.4 som 1');
        disp('2: Impulso 2 - Sala 1.4 som 2');
        disp('3: Impulso 3 - Sala de Redes SR3.1.2');
        disp('4: Impulso 4 - WC 1');
        disp('5: Impulso 5 - WC 2');
        disp('0: Sair');

        % Solicitar a escolha de impulso ao utilizador
        escolha_impulso = input('Digite o número correspondente ao impulso desejado: ');

        % Verificar se o utilizador escolheu sair
        if escolha_impulso == 0
            disp('Saindo da escolha de impulso...');
            return; % Sair do script principal
        end

        % Verificar se o impulso está dentro do intervalo esperado
        if escolha_impulso >= 1 && escolha_impulso <= 5
            % Carregar o impulso selecionado
            switch escolha_impulso
                case 1
                    [impulso, ~] = audioread('impulso_sala_1.4.2.wav');
                case 2
                    [impulso, ~] = audioread('impulso_sala1.4.3.wav');
                case 3
                    [impulso, ~] = audioread('impulso_sala_sr3.1.2.wav');
                case 4
                    [impulso, ~] = audioread('WC_1.wav');
                case 5
                    [impulso, ~] = audioread('WC_2.wav');
            end

            % Verificar se o impulso é estéreo e converter para mono se necessário
            if size(impulso, 2) > 1
                impulso = sum(impulso, 2) / size(impulso, 2); % Converter para mono
            end

            disp('Impulso carregado com sucesso.');
            break; % Sair do loop após a escolha válida
        else
            % Exibir uma mensagem de erro
            disp('Número de impulso inválido. Escolha 1, 2, 3, 4, 5 ou 0 para sair.');
        end
    end
else
    impulso = []; % Definir como vazio se não for Reverb
end

% Chamar a função para aplicar o efeito ao sinal de áudio
sinal_processado = aplicar_efeito(sinal, fa, escolha_efeito, parametros, impulso);

% Reproduzir o áudio processado
sound(sinal_processado, fa);

% Plotar gráficos dos sinais originais e processados
figure;

% Sinal original
subplot(2, 1, 1);
plot((1:length(sinal))/fa, sinal);
title('Sinal Original');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Sinal processado
subplot(2, 1, 2);
plot((1:length(sinal_processado))/fa, sinal_processado);
title('Sinal Processado');
xlabel('Tempo (s)');
ylabel('Amplitude');

disp('Gráficos gerados com sucesso.');

% Obter o nome do arquivo original sem a extensão
[~, nome_arquivo, extensao] = fileparts(['audio' num2str(numero_audio) '.wav']);

% Definir o sufixo do efeito com base na escolha do usuário
switch escolha_efeito
    case 1
        sufixo = '_com_wahwah';
    case 2
        sufixo = '_com_tremolo';
    case 3
        sufixo = '_com_reverb';
    otherwise
        error('Escolha de efeito inválida.');
end

% Criar o nome do novo arquivo com o sufixo do efeito aplicado
nome_arquivo_saida = [nome_arquivo sufixo extensao];

% Salvar o áudio processado como um novo arquivo
audiowrite(nome_arquivo_saida, sinal_processado, fa);
disp(['Áudio processado salvo como ' nome_arquivo_saida]);

