-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE "public"."Cliente" (
    "idCliente" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "telefone" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cliente_pkey" PRIMARY KEY ("idCliente")
);

-- CreateTable
CREATE TABLE "public"."CartaoFidelidade" (
    "idCartao" SERIAL NOT NULL,
    "numeroCartao" TEXT NOT NULL,
    "pontosAcumulados" INTEGER NOT NULL DEFAULT 0,
    "dataCriacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "clienteId" INTEGER NOT NULL,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CartaoFidelidade_pkey" PRIMARY KEY ("idCartao")
);

-- CreateTable
CREATE TABLE "public"."Funcionario" (
    "idFuncionario" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "cargo" TEXT NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Funcionario_pkey" PRIMARY KEY ("idFuncionario")
);

-- CreateTable
CREATE TABLE "public"."Produto" (
    "idProduto" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "preco" DECIMAL(10,2) NOT NULL,
    "categoria" TEXT NOT NULL,
    "disponivel" BOOLEAN NOT NULL DEFAULT true,
    "funcionarioId" INTEGER NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Produto_pkey" PRIMARY KEY ("idProduto")
);

-- CreateTable
CREATE TABLE "public"."Compra" (
    "idCompra" SERIAL NOT NULL,
    "clienteId" INTEGER NOT NULL,
    "dataHora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "valorTotal" DECIMAL(10,2) NOT NULL,
    "pontosGerados" INTEGER NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Compra_pkey" PRIMARY KEY ("idCompra")
);

-- CreateTable
CREATE TABLE "public"."ItemCompra" (
    "idItemCompra" SERIAL NOT NULL,
    "compraId" INTEGER NOT NULL,
    "produtoId" INTEGER NOT NULL,
    "quantidade" INTEGER NOT NULL,
    "precoUnitario" DECIMAL(10,2) NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ItemCompra_pkey" PRIMARY KEY ("idItemCompra")
);

-- CreateTable
CREATE TABLE "public"."Promocao" (
    "idPromocao" SERIAL NOT NULL,
    "descricao" TEXT NOT NULL,
    "percentualDesconto" DECIMAL(5,2) NOT NULL,
    "dataInicio" TIMESTAMP(3) NOT NULL,
    "dataFim" TIMESTAMP(3) NOT NULL,
    "funcionarioId" INTEGER NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Promocao_pkey" PRIMARY KEY ("idPromocao")
);

-- CreateTable
CREATE TABLE "public"."ProdutoPromocao" (
    "promocaoId" INTEGER NOT NULL,
    "produtoId" INTEGER NOT NULL,

    CONSTRAINT "ProdutoPromocao_pkey" PRIMARY KEY ("promocaoId","produtoId")
);

-- CreateTable
CREATE TABLE "public"."Premio" (
    "idPremio" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "pontosNecessarios" INTEGER NOT NULL,
    "descricao" TEXT NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Premio_pkey" PRIMARY KEY ("idPremio")
);

-- CreateTable
CREATE TABLE "public"."Resgate" (
    "idResgate" SERIAL NOT NULL,
    "cartaoId" INTEGER NOT NULL,
    "premioId" INTEGER NOT NULL,
    "dataResgate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Resgate_pkey" PRIMARY KEY ("idResgate")
);

-- CreateIndex
CREATE UNIQUE INDEX "Cliente_email_key" ON "public"."Cliente"("email");

-- CreateIndex
CREATE UNIQUE INDEX "CartaoFidelidade_numeroCartao_key" ON "public"."CartaoFidelidade"("numeroCartao");

-- CreateIndex
CREATE UNIQUE INDEX "CartaoFidelidade_clienteId_key" ON "public"."CartaoFidelidade"("clienteId");

-- CreateIndex
CREATE UNIQUE INDEX "Funcionario_email_key" ON "public"."Funcionario"("email");

-- CreateIndex
CREATE INDEX "Compra_clienteId_idx" ON "public"."Compra"("clienteId");

-- CreateIndex
CREATE INDEX "Compra_dataHora_idx" ON "public"."Compra"("dataHora");

-- CreateIndex
CREATE INDEX "ItemCompra_compraId_idx" ON "public"."ItemCompra"("compraId");

-- CreateIndex
CREATE INDEX "ItemCompra_produtoId_idx" ON "public"."ItemCompra"("produtoId");

-- CreateIndex
CREATE INDEX "Promocao_funcionarioId_idx" ON "public"."Promocao"("funcionarioId");

-- CreateIndex
CREATE INDEX "Promocao_dataInicio_dataFim_idx" ON "public"."Promocao"("dataInicio", "dataFim");

-- CreateIndex
CREATE INDEX "Resgate_cartaoId_idx" ON "public"."Resgate"("cartaoId");

-- CreateIndex
CREATE INDEX "Resgate_premioId_idx" ON "public"."Resgate"("premioId");

-- AddForeignKey
ALTER TABLE "public"."CartaoFidelidade" ADD CONSTRAINT "CartaoFidelidade_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "public"."Cliente"("idCliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Produto" ADD CONSTRAINT "Produto_funcionarioId_fkey" FOREIGN KEY ("funcionarioId") REFERENCES "public"."Funcionario"("idFuncionario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Compra" ADD CONSTRAINT "Compra_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "public"."Cliente"("idCliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ItemCompra" ADD CONSTRAINT "ItemCompra_compraId_fkey" FOREIGN KEY ("compraId") REFERENCES "public"."Compra"("idCompra") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ItemCompra" ADD CONSTRAINT "ItemCompra_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "public"."Produto"("idProduto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Promocao" ADD CONSTRAINT "Promocao_funcionarioId_fkey" FOREIGN KEY ("funcionarioId") REFERENCES "public"."Funcionario"("idFuncionario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProdutoPromocao" ADD CONSTRAINT "ProdutoPromocao_promocaoId_fkey" FOREIGN KEY ("promocaoId") REFERENCES "public"."Promocao"("idPromocao") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProdutoPromocao" ADD CONSTRAINT "ProdutoPromocao_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "public"."Produto"("idProduto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Resgate" ADD CONSTRAINT "Resgate_cartaoId_fkey" FOREIGN KEY ("cartaoId") REFERENCES "public"."CartaoFidelidade"("idCartao") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Resgate" ADD CONSTRAINT "Resgate_premioId_fkey" FOREIGN KEY ("premioId") REFERENCES "public"."Premio"("idPremio") ON DELETE RESTRICT ON UPDATE CASCADE;

