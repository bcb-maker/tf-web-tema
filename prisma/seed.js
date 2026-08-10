const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  await prisma.resgate.deleteMany();
  await prisma.produtoPromocao.deleteMany();
  await prisma.itemCompra.deleteMany();
  await prisma.compra.deleteMany();
  await prisma.cartaoFidelidade.deleteMany();
  await prisma.premio.deleteMany();
  await prisma.promocao.deleteMany();
  await prisma.produto.deleteMany();
  await prisma.funcionario.deleteMany();
  await prisma.cliente.deleteMany();

  const funcionario = await prisma.funcionario.create({
    data: {
      nome: 'Ana Souza',
      email: 'ana.funcionaria@cardtina.test',
      senha: 'hash-de-teste-funcionario',
      cargo: 'Administradora'
    }
  });

  const cliente1 = await prisma.cliente.create({
    data: {
      nome: 'João Silva',
      email: 'joao.cliente@cardtina.test',
      senha: 'hash-de-teste-cliente',
      telefone: '31999990000'
    }
  });

  const cliente2 = await prisma.cliente.create({
    data: {
      nome: 'Maria Oliveira',
      email: 'maria.cliente@cardtina.test',
      senha: 'hash-de-teste-cliente-2'
    }
  });

  const cartao1 = await prisma.cartaoFidelidade.create({
    data: {
      numeroCartao: 'CARD-000001',
      pontosAcumulados: 80,
      clienteId: cliente1.idCliente
    }
  });

  const cartao2 = await prisma.cartaoFidelidade.create({
    data: {
      numeroCartao: 'CARD-000002',
      pontosAcumulados: 35,
      clienteId: cliente2.idCliente
    }
  });

  const coxinha = await prisma.produto.create({
    data: {
      nome: 'Coxinha de frango',
      descricao: 'Salgado de frango com massa crocante.',
      preco: 6.5,
      categoria: 'Salgados',
      disponivel: true,
      funcionarioId: funcionario.idFuncionario
    }
  });

  const suco = await prisma.produto.create({
    data: {
      nome: 'Suco natural de laranja',
      descricao: 'Suco natural servido gelado.',
      preco: 5.0,
      categoria: 'Bebidas',
      disponivel: true,
      funcionarioId: funcionario.idFuncionario
    }
  });

  const premio = await prisma.premio.create({
    data: {
      nome: 'Salgado grátis',
      pontosNecessarios: 50,
      descricao: 'Troque 50 pontos por um salgado disponível na cantina.'
    }
  });

  const promocao = await prisma.promocao.create({
    data: {
      descricao: 'Desconto de volta às aulas',
      percentualDesconto: 10,
      dataInicio: new Date('2026-02-01T00:00:00.000Z'),
      dataFim: new Date('2026-12-31T23:59:59.000Z'),
      funcionarioId: funcionario.idFuncionario
    }
  });

  await prisma.produtoPromocao.createMany({
    data: [
      { promocaoId: promocao.idPromocao, produtoId: coxinha.idProduto },
      { promocaoId: promocao.idPromocao, produtoId: suco.idProduto }
    ]
  });

  const compra = await prisma.compra.create({
    data: {
      clienteId: cliente1.idCliente,
      valorTotal: 18.0,
      pontosGerados: 18,
      itens: {
        create: [
          {
            produtoId: coxinha.idProduto,
            quantidade: 2,
            precoUnitario: 6.5
          },
          {
            produtoId: suco.idProduto,
            quantidade: 1,
            precoUnitario: 5.0
          }
        ]
      }
    }
  });

  await prisma.resgate.create({
    data: {
      cartaoId: cartao1.idCartao,
      premioId: premio.idPremio,
      dataResgate: new Date('2026-08-01T12:00:00.000Z')
    }
  });

  console.log(`Seed concluído: compra ${compra.idCompra} criada para ${cliente1.nome}.`);
  console.log(`Cartões criados: ${cartao1.numeroCartao} e ${cartao2.numeroCartao}.`);
}

main()
  .catch((error) => {
    console.error('Erro ao executar o seed:', error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
