# tf-web-tema
# Deuses do Sistema

## 1. Descrição do domínio

### Integrantes da equipe
- Brian Costa Bandeira - https://github.com/bcb-maker
- Diogo Henrique Pereira de Oliveira - https://github.com/DiogoH9
- Lázaro Martins Rodrigues - https://github.com/Lazaro-laz
- Pedro Augusto Ribeiro Souza - https://github.com/pars1-auri
- Mateus Henrique Soares Ramos - https://github.com/mhsr-rgb

### Tema do sistema
**Cardtina** é um sistema de cardápio digital e cartão fidelidade para a cantina escolar. Além de listar os produtos disponíveis (como um cardápio online), o sistema atualiza os clientes sobre promoções e permite acumular pontos em compras, trocáveis por prêmios (salgados).

### Usuários do sistema
- **Clientes**: alunos e demais membros da escola que consultam o cardápio, realizam compras, acompanham seus pontos no cartão fidelidade e trocam pontos por prêmios.
- **Funcionários/Administradores**: responsáveis por cadastrar e manter os produtos do cardápio, criar promoções e administrar o sistema.

### Problema que o sistema resolve
Havia muita reclamação sobre o preço dos produtos da cantina e falta de comunicação com os clientes. O Cardtina resolve isso oferecendo um canal centralizado de informação (cardápio sempre atualizado e divulgação de promoções) e cria um diferencial de fidelização por meio do cartão de pontos, incentivando o retorno dos clientes e dando a eles algo em troca de sua fidelidade.

---

## 2. Modelo Conceitual

![Modelo Conceitual](db/conceitual.png)

### Entidades

**Cliente**
Representa cada usuário que compra na cantina. Possui `id_cliente`, `nome`, `email`, `senha` e `telefone`. Esses atributos existem para permitir o cadastro/login do usuário e para que a comunicação de promoções e atualizações chegue até ele.

**Cartão Fidelidade**
Representa o cartão digital de pontos vinculado a cada cliente. Possui `numero_cartao`, `pontos_acumulados` e `data_criacao`. É a entidade central do diferencial do sistema: guarda o saldo de pontos que o cliente pode trocar por prêmios.

**Funcionário**
Representa os administradores do sistema, responsáveis pela gestão do cardápio e das promoções. Possui `id_funcionario`, `nome`, `email`, `senha` e `cargo`, permitindo login administrativo e identificação de quem realizou cada cadastro/alteração.

**Produto**
Representa cada item vendido na cantina (ex: salgados, bebidas). Possui `id_produto`, `nome`, `descricao`, `preco`, `categoria` e `disponivel`. Esses atributos existem para compor o cardápio online e informar claramente ao cliente o que está sendo vendido, por quanto e se está disponível no momento.

**Compra**
Representa uma transação realizada por um cliente na cantina. Possui `id_compra`, `data_hora`, `valor_total` e `pontos_gerados`. Registra o histórico de consumo do cliente e é a base para o cálculo de pontos do cartão fidelidade.

**Item_Compra**
Entidade associativa entre Compra e Produto, pois uma compra pode conter vários produtos e um produto pode aparecer em várias compras. Possui `quantidade` e `preco_unitario`, necessários para detalhar exatamente o que foi comprado e a que preço, já que o preço de um produto pode mudar ao longo do tempo.

**Promoção**
Representa ofertas e descontos divulgados pela cantina. Possui `id_promocao`, `descricao`, `percentual_desconto`, `data_inicio` e `data_fim`. Existe para atender à necessidade de manter os clientes informados sobre preços e ofertas, reduzindo reclamações sobre valores.

**Prêmio**
Representa os itens que podem ser resgatados com pontos do cartão fidelidade. Possui `id_premio`, `nome`, `pontos_necessarios` e `descricao`, definindo o que o cliente pode ganhar e quantos pontos são necessários para o resgate.

**Resgate**
Entidade associativa entre Cartão Fidelidade e Prêmio, pois um cartão pode resgatar vários prêmios ao longo do tempo e um mesmo prêmio pode ser resgatado por vários cartões diferentes. Possui `data_resgate`, para registrar o histórico de trocas.

### Relacionamentos

- Um **Cliente** possui exatamente um **Cartão Fidelidade**, e cada Cartão Fidelidade pertence a um único Cliente (1:1).
- Um **Cliente** pode realizar várias **Compras**, mas cada Compra pertence a um único Cliente (1:N).
- Uma **Compra** pode conter vários **Produtos**, e um **Produto** pode estar presente em várias Compras, relacionamento N:M resolvido pela entidade **Item_Compra**. Os pontos gerados em cada compra são calculados proporcionalmente ao valor total gasto.
- Um **Cartão Fidelidade** pode resgatar vários **Prêmios**, e um **Prêmio** pode ser resgatado por vários Cartões diferentes, relacionamento N:M resolvido pela entidade **Resgate**.
- Um **Funcionário** gerencia vários **Produtos**, mas cada Produto é gerenciado por um único Funcionário responsável pelo cadastro (1:N).
- Um **Funcionário** cria várias **Promoções**, mas cada Promoção é criada por um único Funcionário (1:N).
- Uma **Promoção** pode se aplicar a vários **Produtos**, e um **Produto** pode estar em várias Promoções ao mesmo tempo (N:M).

---

## 3. Sobre o Figma (protótipo de interface)

Título:
Cardtina

Descrição:
O Cardtina é um projeto de interface desenvolvido no Figma com foco na criação de wireframes para um sistema de cartão digital de uma cantina escolar. O projeto apresenta a estrutura visual e a organização das telas principais do aplicativo, oferecendo uma experiência simples e intuitiva para os usuários da cantina escolar.

Principais funcionalidades:
- Wireframe da página de login
- Wireframe da página de cadastro
- Tela de visualização de pontos acumulados
- Sistema de troca de pontos por prêmios (salgados)
- Exibição do número do cartão digital
- Histórico das últimas compras
- Organização da navegação entre telas

https://www.figma.com/design/r5sLU0QOgZ4hToJPFeEhzX/TRABALHO?m=auto&t=QsZna7bScbwtO6Xf-6