# Deuses do Sistema

## 1. Descrição do domínio

### Integrantes da equipe

- Brian Costa Bandeira — https://github.com/bcb-maker
- Diogo Henrique Pereira de Oliveira — https://github.com/DiogoH9
- Lázaro Martins Rodrigues — https://github.com/Lazaro-laz
- Pedro Augusto Ribeiro Souza — https://github.com/pars1-auri
- Mateus Henrique Soares Ramos — https://github.com/mhsr-rgb

### Tema do sistema

**Cardtina** é um sistema de cardápio digital e cartão fidelidade para uma cantina escolar. O sistema lista os produtos disponíveis, divulga promoções e permite que clientes acumulem pontos em compras para trocá-los por prêmios.

### Usuários do sistema

Os **clientes** são alunos e demais membros da escola que consultam o cardápio, realizam compras, acompanham os pontos do cartão fidelidade e resgatam prêmios. Os **funcionários** são responsáveis pelo cadastro dos produtos, criação de promoções e administração do sistema.

### Problema que o sistema resolve

A cantina recebia reclamações sobre os preços dos produtos e enfrentava dificuldade para comunicar promoções aos clientes. O Cardtina centraliza o cardápio e as ofertas em um único sistema e cria um programa de fidelidade que incentiva o retorno dos clientes.

## 2. Modelo conceitual

![Modelo Conceitual](db/conceitual.png)

O modelo conceitual está disponível também diretamente em [db/conceitual.png](./db/conceitual.png).

### Entidades

**Cliente** representa cada pessoa que compra na cantina. Seus atributos permitem o cadastro, o login e a comunicação com o usuário. O campo `telefone` é opcional porque o cliente pode concluir o cadastro sem informar um número de telefone.

**CartaoFidelidade** representa o cartão digital de pontos vinculado ao cliente. Ele armazena o número do cartão, o saldo de pontos e a data de criação.

**Funcionario** representa os administradores responsáveis por cadastrar produtos e criar promoções. Seus atributos permitem identificar o funcionário responsável por essas operações.

**Produto** representa cada item vendido na cantina, como salgados e bebidas. O produto possui descrição, preço, categoria e indicação de disponibilidade.

**Compra** representa uma transação realizada por um cliente. Ela registra data e hora, valor total e quantidade de pontos gerados.

**ItemCompra** é a entidade associativa entre `Compra` e `Produto`. Ela registra quais produtos fazem parte de cada compra, suas quantidades e o preço unitário praticado no momento da compra.

**Promocao** representa ofertas e descontos criados pela cantina. Ela armazena a descrição, o percentual de desconto, o período de validade e o funcionário responsável.

**ProdutoPromocao** é a entidade associativa que resolve o relacionamento N:M entre `Produto` e `Promocao` no modelo lógico relacional.

**Premio** representa os itens que podem ser resgatados com pontos do cartão fidelidade. Ele registra o nome, a descrição e a quantidade de pontos necessária para o resgate.

**Resgate** registra cada troca de pontos realizada por um cartão fidelidade, relacionando o cartão ao prêmio e guardando a data do resgate.

### Relacionamentos e cardinalidades

Um **Cliente possui um CartaoFidelidade**, e cada cartão pertence a um único cliente, formando uma relação 1:1. No modelo lógico, `CartaoFidelidade.clienteId` é obrigatório e único. O lado do cliente aparece como opcional no Prisma porque o banco não consegue obrigar a criação do cartão no mesmo instante do cadastro do cliente; a regra de negócio exige que o cartão seja criado para todo cliente ativo.

Um **Cliente pode realizar várias Compras**, mas cada compra pertence a um único cliente, formando uma relação 1:N. Uma **Compra possui vários ItemCompra**, e cada item pertence a uma compra. Um **Produto pode aparecer em vários ItemCompra**, permitindo que o mesmo produto participe de muitas compras.

Um **Funcionario gerencia vários Produtos**, mas cada produto possui um funcionário responsável pelo cadastro. Um **Funcionario cria várias Promocoes**, mas cada promoção possui um funcionário responsável pela criação. Uma **Promocao pode se aplicar a vários Produtos**, e um produto pode participar de várias promoções; por isso, o modelo lógico usa `ProdutoPromocao` como tabela associativa.

Um **CartaoFidelidade pode realizar vários Resgates**, e cada resgate pertence a um cartão. Um **Premio pode aparecer em vários Resgates**, permitindo que diferentes cartões resgatem o mesmo prêmio ao longo do tempo.

## 3. Modelo lógico — Prisma

O modelo lógico está implementado no arquivo [prisma/schema.prisma](./prisma/schema.prisma). Cada `model` representa uma tabela, cada atributo representa uma coluna e cada campo `@relation` define uma chave estrangeira.

O schema usa os tipos `String`, `Int`, `Boolean`, `DateTime` e `Decimal`. Todas as entidades possuem uma chave primária com `@default(autoincrement())`. Os campos `criadoEm` usam `@default(now())` e os campos `atualizadoEm` usam `@updatedAt` quando há sentido em registrar a atualização da entidade.

O único campo opcional é `Cliente.telefone`. Ele foi definido como `String?` porque o telefone pode não ser informado no cadastro; nome, e-mail, senha e os demais dados necessários ao domínio são obrigatórios.

### Diagrama lógico em Mermaid

```mermaid
erDiagram
    CLIENTE ||--o| CARTAO_FIDELIDADE : possui
    CLIENTE ||--o{ COMPRA : realiza
    COMPRA ||--|{ ITEM_COMPRA : contem
    PRODUTO ||--o{ ITEM_COMPRA : aparece_em
    FUNCIONARIO ||--o{ PRODUTO : gerencia
    FUNCIONARIO ||--o{ PROMOCAO : cria
    PROMOCAO ||--o{ PRODUTO_PROMOCAO : aplica_se
    PRODUTO ||--o{ PRODUTO_PROMOCAO : participa
    CARTAO_FIDELIDADE ||--o{ RESGATE : realiza
    PREMIO ||--o{ RESGATE : e_resgatado

    CLIENTE {
        int idCliente PK
        string nome
        string email UK
        string senha
        string telefone "opcional"
    }
    CARTAO_FIDELIDADE {
        int idCartao PK
        string numeroCartao UK
        int pontosAcumulados
        datetime dataCriacao
        int clienteId FK
    }
    FUNCIONARIO {
        int idFuncionario PK
        string nome
        string email UK
        string senha
        string cargo
    }
    PRODUTO {
        int idProduto PK
        string nome
        string descricao
        decimal preco
        string categoria
        boolean disponivel
        int funcionarioId FK
    }
    COMPRA {
        int idCompra PK
        int clienteId FK
        datetime dataHora
        decimal valorTotal
        int pontosGerados
    }
    ITEM_COMPRA {
        int idItemCompra PK
        int compraId FK
        int produtoId FK
        int quantidade
        decimal precoUnitario
    }
    PROMOCAO {
        int idPromocao PK
        string descricao
        decimal percentualDesconto
        datetime dataInicio
        datetime dataFim
        int funcionarioId FK
    }
    PRODUTO_PROMOCAO {
        int promocaoId PK, FK
        int produtoId PK, FK
    }
    PREMIO {
        int idPremio PK
        string nome
        int pontosNecessarios
        string descricao
    }
    RESGATE {
        int idResgate PK
        int cartaoId FK
        int premioId FK
        datetime dataResgate
    }
```

## 4. Modelo físico — migrations e seed

O modelo físico é representado pela migration inicial em [prisma/migrations](./prisma/migrations). Ela cria as tabelas, chaves primárias, chaves estrangeiras, índices e restrições do modelo lógico.

O seed está em [prisma/seed.js](./prisma/seed.js). Ele cria dados fictícios para todas as tabelas na ordem correta: funcionário e clientes, cartões, produtos, prêmios, promoções, associações de promoções, compras, itens de compra e resgates.

Para instalar as dependências e validar o projeto, execute:

```bash
npm install
npx prisma format
npx prisma validate
```

Para aplicar as migrations no banco Neon configurado em `DATABASE_URL`, execute:

```bash
npx prisma migrate deploy
npx prisma db seed
```

Para abrir uma interface visual com as tabelas e os registros, execute:

```bash
npx prisma studio
```

Depois de executar a migration e o seed no Neon, deve ser incluído neste README um print do Prisma Studio ou do painel do Neon mostrando as tabelas e os dados populados.

## 5. Configuração do ambiente

Copie `.env.example` para `.env` e substitua a URL genérica pela URL real do banco Neon. O arquivo `.env` não deve ser versionado. O arquivo [`.env.example`](./.env.example) contém somente o formato genérico exigido:

```text
DATABASE_URL="postgresql://usuario:senha@host/banco?sslmode=require"
```

A proteção do ambiente está definida em [`.gitignore`](./.gitignore). Para verificar se o `.env` está protegido, execute:

```bash
git status .env
```

A saída esperada é que o caminho não apareça como arquivo novo ou modificado.

## 6. Protótipo de interface

O protótipo das telas está disponível no [Figma](https://www.figma.com/design/r5sLU0QOgZ4hToJPFeEhzX/TRABALHO?m=auto&t=QsZna7bScbwtO6Xf-6).

Principais telas previstas:

- Login e cadastro.
- Visualização do saldo de pontos.
- Exibição do número do cartão digital.
- Histórico das últimas compras.
- Troca de pontos por prêmios.
- Divulgação de promoções.
