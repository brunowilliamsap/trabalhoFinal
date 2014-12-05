# **Proposta Final**

## Grupo
Beatriz Leite Negrão 610534

Bruno Williams Antunes Pereira 558222

Gustavo Cesar 558311

##Tema:
Implementar o sensor IrDA ao processador

##Material Utilizado:
Placa Altera DE2-115 – Ciclone IV
ModelSim-Altera 10.1d
Quartus II 13.0

##Intodução:
Fundada em 1993 por 50 empresas, IrDA fornece especificações para um conjunto de protocolos de comunicação de infravermelhos sem fio e o nome “IrDA” também se refere a esse conjunto de protocolos. 

A principal razão para a utilização da IrDA tinha sido a transferência de dados sem fio sobre o “ultimo metro”. Assim foi implementado em dispositivos portáteis, como telefones celulares, laptops, câmeras, impressoras, dispositivos médicos e muito mais.

As principais características deste tipo de comunicação óptica sem fio esta na transferência física de dados segura, através do uso de LOS (Line-of-Sight) e baixa BER (Taxa de erro de bits).

Obs: LOS é um tipo de propagação de radiação eletromagnética ou propagação de ondas acústica

Obs1: BER (taxa de erros de bits) é o número de erros de bits dividido pelo número total de bits transmitidos durante um intervalo de tempo estudado.

##Proposta:
1-	Entender e reconhecer o sinal transmitido para o chip da Altera através do pino PIN_YI5 (Receptor de IrDA embutido na placa DE2-115).

2-	Quando o IrDA for acionado, o dado é transmitido para um registrador e salvo na memoria através da instrução lw. (enquanto essa operação é realizada um LED ficará acesso).

3-	Também toda vez que IrDA é acionado, um determinado registrador será incrementado em 1, através da instrução addi $registrador, $registrador, 1.

4-	O valor contido nesse registrador será passado para o display de 7segmentos de forma que teremos um contador para a quantidade de vezes que o infravermelho foi acionado.

##Resultados Preliminares
Até agora o foco do grupo foi em pesquisa, em entender o que é e como funciona o IrDA. Agora começaremos as implementações das funções que utilizaremos e também do uso do IrDA no processador.

##Entendendo melhor IrDA
###IrDA na FPGA D2-115
![My IrDA] (https://github.com/brunowilliamsap/trabalhoFinal/blob/master/IrDA.png)
Conexão entre FPGA e IR

###Especificações
![My camadas] (https://github.com/brunowilliamsap/trabalhoFinal/blob/master/camadas.png)
Camadas de protocolos

=>	**IrPHV (Infrared Physical Layer Specification) [obrigatória]**

É a camada física das especificações IrDA.
Compreende definições ópticas link, modulação, codificações, verificação de redundância cíclica (CRC) e o enquadramento. Taxas de dados diferentes usam esquemas de modulação /codificações:

•	SIR: 9,6-115,2 kbit / s, assíncrona, rzi , UART-like, 3/16 pulso

•	MIR: 0,576-1,152 Mbit / s, rzi , 1/4 pulso, HDLC bit stuffing

•	FIR: 4 Mbit / s, 4 PPM

•	VFIR: 16 Mbit / s, NRZ , HHH (1,13)

•	UFIR: 96 Mbit / s, NRZI , 8b / 10b

•	GigaIR: 512 Mbit / s - 1 Gbit / s, NRZI, 2-ASK, 4-ASK, 8b / 10b

Outras características são as seguintes:

•	Range: standard: 1 m; baixo poder de baixa potência: 0,2 m; padrão de baixa potência: 0,3 m, A 10 GigaIR também definir novos modelos de uso que suportam distâncias maiores Link para até vários metros.

•	cone mínimo ± 15 °

•	Velocidade: 2,4 kbit / s para 1 Gbit / s

•	Modulação: baseband , nenhuma transportadora

•	Janela de infravermelhos

•	Comprimento de onda: 850-900 nm

O tamanho do quadro depende da taxa de dados em sua maioria varia entre 64 bytes e 64 kbytes. Além disso blocos maiores de dados podem ser transferidos através do envio de vários quadros consecutivos. Isto pode ser ajustado com um parâmetro chamado Tamanho de Janela (1-127). Finalmente blocos de dados de até 8Mbytes pode ser enviados de uma só vez. Combinado com uma baixa taxa de erros de bit geralmente 10-9, que a comunicação poderia ser muito eficiente em comparação com outras soluções sem fio.

As especificações físicas IrDA requerem um mínimo de irradiância seja mantida de modo que um sinal visível até um metro de distância. Da mesma forma, as especificações exigem que a irradiância máxima não seja ultrapassada para que o receptor não seja sobrecarregado com o brilho de quando um dispositivo chega perto.

Obs: Irradiância é a energia de radiação eletromagnética por unidade de área (fluxo por radiação) incidente sobre uma superfície.

Comunicações de dados IrDA opera em modo half-duplex porque durante a transmissão o receptor de um dispositivo é cegado pela luz do próprio transmissor e portanto a comunicação no modo full-duplex não é viável.

Obs: Sistema Half-Duplex fornece comunicação em ambos sentidos, mas apenas uma direção de cada vez (não simultaneamente). Normalmente uma vez que um receptor começa a receber o sinal, ele deve aguardar o transmissor parar de transmitir, antes de responder. 

Obs: Sistema Full-Duplex fornece comunicação em ambos sentidos e ao contrário do half-duplex permite que isso aconteça simultaneamente.

=>	**IrLAP (Infrared Link Access Protocol) [obrigatória]**

É a segunda camada das especificações IrDA.
Encontra-se no topo da camanda IrPHY e abaixo da camada IrLMP. Representa o Link Layer Dados do modelo OSI. As especificações mais importantes são:

•	Controle de acesso

•	Descoberta de potencias parceiros de comunicação

•	Estabelecimento de uma conexão bidirecional confiável

•	Distribuição das funções do dispositivo primário / secundário

•	Negociação de parâmetros de QoS

Na camada IrLAP os dispositivos de comunicação são divididos em um dispositivo principal e um ou mais dispositivos secundários. O dispositivo principal controla os dispositivos secundários. 

=>	**IrLMP (Infrared Link Management Protocol) [obrigatário]**

É a terceira camada das especificações IrDA.
Pode ser dividida em duas partes: LM-MUX (Link Management Multiplexer) e LM-IAS (Link Management Information Service Access).

->	LM-MUX
Encontra-se no topo da camada IrLAP.

Suas conquistas mais importantes são:

o	Fornece múltiplos canais lógicos 

o	Permite troca dos dispositivos principal / secundário.

->	LM-IAS
Fornece uma lista onde os provedores de serviços podem registrar seus serviços para outros dispositivos possam acessar esses serviços via consulta do LM-IAS.

=>	**Tiny TP (Tiny Transport Protocol) [opcional]**

Encontra-se no topo da camada IrLMP.
Fornece:

•	Transporte de mensagens grandes por SAR (Segmentação e Remontagem)

•	Controle de fluxo, dando créditos para cada canal lógico.

=>	**IrCOMM (Infrared Communications Protocol) [opcional]**

Permite que o infravermelho seja tratado como um uma porta serial ou porta paralela.

•	OBEX (troca de objeto) [opcional]

Prevê troca de objetos de dados arbitrários entres dispositivos de infravermelho.
Encontra-se na parte superior do protocolo Tiny TP. O uso do Tiny TP é obrigatório para o uso do OBEX.

•	IrLAN (Infrared Local Area Network) [opcional]

Prevê a possibilidade de conectar um dispositivo de infravermelho a uma rede local.
Existem 3 métodos possíveis :

•	Access Point

•	Peer to Peer

•	Hosted

Como o IrLAN encontra-se acima do protocolo Tiny TP, O Tiny TP deve ser implementado para que o IrlAN possa trabalhar.

•	IrSimple

Atinge pelo menos 4 a 10 vezes mais rápida a velocidade de transmissão de dados através da melhoria da eficiência do protocolo IrDA .

##Bibliografia
•http://en.wikipedia.org/wiki/Infrared_Data_Association

•User Manual DE2-115

•Technical Data Sheet Infrared Remote-control Receiver Module
