-- Selecione todos os clientes com email cadastrado
SELECT * FROM clientes WHERE flEmail = 1;


-- Selecione todas transações de 50 pontos (exatos)
SELECT * FROM clientes WHERE qtdePontos = 50;


-- Selecione todos clientes com mais de 500 pontos
SELECT * FROM clientes WHERE qtdePontos > 500;


-- Selecione produtos que contêm ‘churn’ no nome
SELECT * FROM produtos WHERE DescNomeProduto LIKE '%churn%';


-- Qual o saldo de pontos total do sistema?
SELECT SUM(qtdePontos) AS total_pts FROM clientes


-- Quantos pontos já foram subtraídos dos clientes?
SELECT SUM(QtdePontos) AS total_subt FROM transacoes WHERE qtdePontos < 0


-- Quantos clientes tem Twitch?
SELECT SUM(flTwitch) AS total_twitch FROM clientes


--  Qual a média de saldo em carteira?
SELECT ROUND(AVG(qtdePontos), 2) AS media_pts FROM clientes



-- Tempo de Foco


-- 1. Lista de transações com apenas 1 ponto;
SELECT * FROM transacoes WHERE QtdePontos = 1;


-- 2. Lista de pedidos realizados no fim de semana
SELECT IdTransacao FROM transacoes WHERE strftime('%w', DATE(DtCriacao)) IN ('0','6');


-- 3. Lista de clientes com 0 (zero) pontos
SELECT * FROM clientes WHERE qtdePontos = 0


-- 4. Lista de clientes com 100 a 200 pontos (inclusive ambos)
SELECT * FROM clientes WHERE qtdePontos BETWEEN 100 AND 200;


-- 5. Lista de produtos com nome que começa com “Venda de”
SELECT * FROM produtos WHERE DescNomeProduto LIKE 'Venda de%';


-- 6. Lista de produtos com nome que termina com “Lover”
SELECT * FROM produtos WHERE DescNomeProduto LIKE '%Lover';


-- 7. Lista de produtos que são “chapéu”
SELECT * FROM produtos WHERE DescCategoriaProduto LIKE '%chapeu%';


-- 8. Lista de transações com o produto “Resgatar Ponei”
-- SELECT * FROM produtos WHERE DescNomeProduto LIKE '%Ponei%' (Descobrir o id correspondente)
SELECT * FROM transacao_produto WHERE IdProduto = 15;


-- 9. Listar todas as transações adicionando uma coluna nova sinalizando 
-- “alto”, “médio” e “baixo” para o valor dos pontos [<10 ; <500; >=500]
SELECT *,
    CASE
        WHEN QtdePontos < 10 THEN 'baixo'
        WHEN QtdePontos < 500 THEN 'médio'
        ELSE 'alto'
    END AS categoria
FROM transacoes;



-- Tempo de foco (Group By)


-- 1. Quantos clientes tem email cadastrado?
SELECT SUM(flEmail) AS qtd_email FROM clientes 


-- 2. Qual cliente juntou mais pontos positivos em 2025-05?
SELECT IdCliente, SUM(QtdePontos) AS Total_pts

FROM transacoes 

WHERE DtCriacao >= '2025-05-01' AND DtCriacao <= '2025-05-31'

GROUP BY IdCliente
ORDER BY Total_pts DESC
LIMIT 1


-- 3. Qual cliente fez mais transações no ano de 2024?






-- 4. Quantos produtos são de rpg?
-- 5. Qual o valor médio de pontos positivos por dia?
-- 6. Qual dia da semana quem mais pedidos em 2025?
-- 7. Qual o produto mais transacionado?
-- 8. Qual o produto com mais pontos transacionados?




