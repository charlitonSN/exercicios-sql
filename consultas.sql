-- ######### Bora praticar 1 ##########

-- Selecione todos os clientes com email cadastrado
SELECT * FROM clientes WHERE flEmail = 1;


-- Selecione todas transações de 50 pontos (exatos)
SELECT * FROM clientes WHERE qtdePontos = 50;


-- Selecione todos clientes com mais de 500 pontos
SELECT * FROM clientes WHERE qtdePontos > 500;


-- Selecione produtos que contêm ‘churn’ no nome
SELECT * FROM produtos WHERE DescNomeProduto LIKE '%churn%';


-- ######### Bora praticar 2 ##########

-- Qual o saldo de pontos total do sistema?
SELECT SUM(qtdePontos) AS total_pts FROM clientes;


-- Quantos pontos já foram subtraídos dos clientes?
SELECT SUM(QtdePontos) AS total_subt FROM transacoes WHERE qtdePontos < 0;


-- Quantos clientes tem Twitch?
SELECT SUM(flTwitch) AS total_twitch FROM clientes;


--  Qual a média de saldo em carteira?
SELECT ROUND(AVG(qtdePontos), 2) AS media_pts FROM clientes;


-- ######### Bora praticar 3 ##########

-- Qual categoria tem mais produtos vendidos?
SELECT 
	t2.DescCategoriaProduto, 
	COUNT(t1.idTransacaoProduto) AS qtd_transacoes
	
FROM transacao_produto t1

LEFT JOIN produtos t2 ON t1.IdProduto = t2.IdProduto

GROUP BY t2.DescCategoriaProduto
ORDER BY qtd_transacoes DESC
LIMIT 1;


-- Em 2024, quantas transações de Lovers tivemos?
SELECT COUNT(idTransacaoProduto) AS qtd_trans, t3.DescCategoriaProduto

FROM transacao_produto t1

LEFT JOIN transacoes t2 ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos t3 ON t1.IdProduto = t3.IdProduto

WHERE strftime('%Y', DtCriacao) = '2024' AND t3.DescCategoriaProduto = 'lovers';


-- Qual mês tivemos mais lista de presença assinada
SELECT
    COUNT(DISTINCT t1.IdTransacao) AS qtd_trans,
    strftime('%Y-%m', t1.DtCriacao) AS ano_mes

FROM transacoes t1

LEFT JOIN transacao_produto t2 ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos t3 ON t2.IdProduto = t3.IdProduto

WHERE t3.DescCategoriaProduto = 'present'

GROUP BY ano_mes
ORDER BY qtd_trans DESC
LIMIT 1;


--  Qual o total de pontos trocados no Stream Elements em Junho de 2025?
SELECT SUM(t1.QtdePontos) AS pts_trocados
FROM transacoes t1
LEFT JOIN transacao_produto t2 ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos t3 ON t2.IdProduto = t3.IdProduto

WHERE t3.DescCategoriaProduto = 'streamelements' AND strftime('%Y-%m', t1.DtCriacao) = '2025-06'










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

WHERE (DtCriacao >= '2025-05-01' AND DtCriacao <= '2025-05-31') AND QtdePontos > 0

GROUP BY IdCliente
ORDER BY Total_pts DESC
LIMIT 1


-- 3. Qual cliente fez mais transações no ano de 2024?
SELECT IdCliente, COUNT(IdTransacao) AS qtd_trans

FROM transacoes

WHERE strftime('%Y', DtCriacao) = '2024'

GROUP BY IdCliente
ORDER BY qtd_trans DESC
LIMIT 1


-- 4. Quantos produtos são de rpg?
SELECT DescCategoriaProduto, COUNT(IdProduto) AS qtd_produto
FROM produtos
GROUP BY DescCategoriaProduto
HAVING DescCategoriaProduto = 'rpg'


-- 5. Qual o valor médio de pontos positivos por dia?
SELECT DATE(DtCriacao) AS data, ROUND(AVG(QtdePontos), 2) AS media_pts

FROM transacoes

WHERE QtdePontos > 0

GROUP BY DATE(DtCriacao)
ORDER BY DATE(DtCriacao) 


-- 6. Qual dia da semana tem mais pedidos em 2025?
SELECT strftime('%w', DtCriacao) AS dia_semana, COUNT(DtCriacao) AS qtd_pedidos

FROM transacoes

WHERE strftime('%Y', DtCriacao) = '2025'

GROUP BY dia_semana
ORDER BY qtd_pedidos DESC
LIMIT 1

-- 7. Qual o produto mais transacionado?
SELECT IdProduto, COUNT(IdTransacao) AS qtd_transacoes

FROM transacao_produto

GROUP BY IdProduto
ORDER BY qtd_transacoes DESC
LIMIT 1


-- 8. Qual o produto com mais pontos transacionados?
SELECT IdProduto, SUM(vlProduto) AS total_pts

FROM transacao_produto

GROUP BY IdProduto
ORDER BY total_pts DESC
LIMIT 1






