# inteli-robo-digital-luiz-borges

## Robô Digital - Simulação

O projeto Robô Digital tem por objetivo a elaboração de uma solução completa de integração entre as Tecnologias de Automação (TA) e as Tecnologias de Informação (TI). Trata-se de uma representação digital para um braço robótico com conexão em tempo real com sua contrapartida no mundo real. Para a construção deste sistema, será necessário construir três elementos:

- Backend: será necessário construir um backend capaz de armazenar informações como deslocamento do robô, sua posição e enviar informações em tempo real para um ambiente de simulação. Para interação com o backend, deve-se também construir uma API que permita o envio e recebimento de dados por clientes.

- Frontend: para que o usuário possa interagir com o sistema, uma aplicação Frontend deve ser construída. Ela deve possibilitar que o usuário realize requisições de deslocamento do manipulador robótico. Os deslocamentos podem ser realizados tanto em espaço de juntas como coordenadas globais. Cada deslocamento deve ser armazenado. Deve ser possível visualizar a posição atual do robô pela interface.

- Simulação: o sistema de simulação do comportamento robótico deve ser implementado utilizando uma representação tridimensional de sua cadeia cinemática. Recomenda-se a utilização da engine Godot para realizar esta implementação. O sistema de simulação deve realizar requisições para a API desenvolvida no sistema atualizar a posição-alvo do robô e receber sua posição atualizada.

Para este entregável, espera-se que o estudante possa desenvolver a etapa de simulação do projeto.

Para a solução da questão proposta, espera-se encontrar:  
- (Até 1.5 Ponto) - Implementação da simulação da cadeia cinemática do robô.
- (Até 0.5 Ponto) - Utilização correta da API desenvolvida.
- (Até 1.0 Ponto) - Documentação do sistema proposto.

## Desenvolvimento 

Para a implementação dos dos componentes de frontend, backend e simulação da atividade proposta, optei por desenvoler o fronted no mesmo ambiente de simulação recomendado: a Plataforma Godot. Utilizando a linguagem GDScript, desenvolvi uma interface onde é possível controlar o deslocamento da garra de um robô virtual nos planos x, y e z, representada em um plano 2D. As coordenadas definidas são enviadas para o servidor, via aplicação de websocket. 

<img src="https://user-images.githubusercontent.com/40524905/229399556-c53dd0ab-ec16-465e-be66-96469ab3a87c.png" width=60% height=60%>

O servidor, implementado em Python, estabelece uma comunicação com a interface gráfica cliente, recebendo as coordenadas, as desenpacotando para ficarem prontas para sua utlização na movimentação de um robô físico que pode ser conectado a esta aplicação futuramente. Após a execução do movimento do robô, as coordenadas de movimentação são enviadas de volta para a interface de usuário, que as exibe e as utiliza como referência para a animação gráfica da representação da garra em um plano 2D.

<img src="https://user-images.githubusercontent.com/40524905/229396502-20211ccd-03c6-4a82-b8fe-85db1fcf4a1c.png" width=60% height=60%>

Para a composição do servidor, foram utilizadas principalmenre as bibliotecas WebsSockets e SQLAlchemy, que permite o desenvolvimento de dois componentes de aplicações web, criação de servidor e banco de dados apenas com a linguagem Python.
