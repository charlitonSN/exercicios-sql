-- Selecione todos os clientes com email cadastrado
SELECT * FROM clientes WHERE flEmail = 1;


-- Selecione todas transações de 50 pontos (exatos)
SELECT * FROM clientes WHERE qtdePontos = 50;


-- Selecione todos clientes com mais de 500 pontos
SELECT * FROM clientes WHERE qtdePontos > 500;


-- Selecione produtos que contêm ‘churn’ no nome
SELECT * FROM produtos WHERE DescNomeProduto LIKE '%churn%';


-- 1. Lista de transações com apenas 1 ponto;
SELECT * FROM transacoes WHERE QtdePontos = 1;


-- 2. Lista de pedidos realizados no fim de semana