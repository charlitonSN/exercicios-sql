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


--########### Tempo de Foco 1 ###########

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


--########### Tempo de Foco 2 (group by) ###########

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


--########### Tempo de Foco 3 ###########

-- 1. Quais clientes mais perderam pontos por Lover?
SELECT t1.IdCliente, SUM(t1.QtdePontos) AS qtd_pts

FROM transacoes t1
LEFT JOIN transacao_produto t2 ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos t3 ON t2.IdProduto = t3.IdProduto

WHERE DescCategoriaProduto = 'lovers'

GROUP BY t1.IdCliente
ORDER BY qtd_pts ASC
LIMIT 5;


-- 2. Quais clientes assinaram a lista de presença no dia 2025/08/25?
SELECT DISTINCT t1.IdCliente, DATE(t1.DtCriacao) AS dia, t3.DescCategoriaProduto

FROM transacoes t1
LEFT JOIN transacao_produto t2 ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos t3 ON t2.IdProduto = t3.IdProduto

WHERE DescCategoriaProduto = 'present' AND DATE(t1.DtCriacao) = '2025-08-25'


-- 3. Do início ao fim do nosso curso (2025/08/25 a 2025/08/29), quantos clientes assinaram a lista de presença?
SELECT COUNT(DISTINCT t1.IdCliente) AS qtd_clientes

FROM transacoes t1
LEFT JOIN transacao_produto t2 ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos t3 ON t2.IdProduto = t3.IdProduto

WHERE DescCategoriaProduto = 'present' AND (DATE(t1.DtCriacao) >= '2025-08-25' AND DATE(t1.DtCriacao) <= '2025-08-29')


-- 4. Clientes mais antigos, tem mais frequência de transação?
SELECT
    CASE
        WHEN DATE(t1.DtCriacao) < '2024-10-01' THEN 'Cliente antigo'
		WHEN DATE(t1.DtCriacao) < '2025-05-01' THEN 'Cliente intermediário'
		WHEN DATE(t1.DtCriacao) < '2026-01-01' THEN 'Cliente recente'
        ELSE 'Cliente muito recente'
    END AS clientes_periodo,

    COUNT(DISTINCT t1.IdCliente) AS qtd_clientes,
    COUNT(t2.IdTransacao) AS qtd_transacoes,
    ROUND(1.0 * COUNT(t2.IdTransacao) / COUNT(DISTINCT t1.IdCliente), 2) AS media_transacoes

FROM clientes t1
LEFT JOIN transacoes t2 ON t1.IdCliente = t2.IdCliente
GROUP BY clientes_periodo;

-- Resposta do Teo:
SELECT
    t1.IdCliente,
    JULIANDAY('now') - JULIANDAY(DATE(t1.DtCriacao)) AS idade_base,
    COUNT(t2.IdTransacao)

FROM clientes AS t1

LEFT JOIN transacoes t2 ON t1.IdCliente = t2.IdCliente;
GROUP BY t1.IdCliente, idade_base


-- 5. Quantidade de transações Acumuladas ao longo do tempo?
WITH total_trans AS (
    SELECT
        DATE(DtCriacao) AS data_transacao,
        COUNT(IdTransacao) AS qtd_trans
    FROM transacoes
    GROUP BY data_transacao
)

SELECT
    data_transacao,
    SUM(qtd_trans) OVER (
        ORDER BY data_transacao
    ) AS trans_acumuladas
FROM total_trans
ORDER BY data_transacao;


-- 6. Quantidade de usuários cadastrados (absoluto e acumulado) ao longo do tempo?
WITH total_clientes AS (
	SELECT 
		DATE(DtCriacao) AS data_cadastro,
        COUNT(idCliente) AS qtd_absoluto
	FROM clientes
	GROUP BY data_cadastro
)

SELECT 
	*,
	SUM(qtd_absoluto) OVER (ORDER BY data_cadastro) AS qtd_acumulado

FROM total_clientes


-- 7. Qual o dia da semana mais ativo de cada usuário?
WITH total_trans AS (
    SELECT
        IdCliente,
        COUNT(DISTINCT IdTransacao) AS qtd_trans,
        STRFTIME('%w', DtCriacao) AS dias_semana
    FROM transacoes
    GROUP BY IdCliente, dias_semana
),
ranking AS (
    SELECT
        IdCliente,
        dias_semana,
        qtd_trans,
        ROW_NUMBER() OVER (
            PARTITION BY IdCliente
            ORDER BY qtd_trans DESC, dias_semana DESC
        ) AS ranking
    FROM total_trans
)
SELECT
    IdCliente,
    dias_semana,
    qtd_trans
FROM ranking
WHERE ranking = 1
ORDER BY IdCliente;


-- 8. Saldo de pontos acumulado de cada usuário
WITH cliente_dia AS (
	SELECT
    	IdCliente,
   		DATE(DtCriacao) AS data_trans,
    	SUM(QtdePontos) AS total_pts
	FROM transacoes
	GROUP BY IdCliente, data_trans
)
SELECT 
	*,
	SUM(total_pts) OVER (PARTITION BY IdCliente ORDER BY data_trans) AS saldo_acumulado
FROM cliente_dia;


-- 9. Dos clientes que começaram SQL no primeiro dia, quantos chegaram ao 5o dia?
SELECT 
	COUNT(DISTINCT t1.IdCliente) AS qtd_clientes
    
FROM transacoes t1

INNER JOIN (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DATE(DtCriacao) = '2025-08-25'
) t2
    ON t1.IdCliente = t2.IdCliente

WHERE DATE(t1.DtCriacao) = '2025-08-29';

-- resposta Teo
SELECT COUNT(DISTINCT IdCliente)

FROM transacoes

WHERE IdCliente IN (
					SELECT DISTINCT IdCliente
					FROM transacoes
					WHERE DATE(DtCriacao) = '2025-08-25')
AND DATE(DtCriacao) = '2025-08-29';


-- 10. Como foi a curva de Churn do Curso de SQL?
WITH tb_clientes_d1 AS (
	SELECT DISTINCT IdCliente
	FROM transacoes
	WHERE DATE(DtCriacao) >= '2025-08-25' AND DATE(DtCriacao) <= '2025-08-29'
)

SELECT 
	DATE(t2.DtCriacao) AS dtdia,
	COUNT(DISTINCT t1.IdCliente) qtd_clientes

FROM tb_clientes_d1 t1
LEFT JOIN transacoes t2 ON t1.IdCliente = t2.IdCliente

WHERE DATE(t2.DtCriacao) >= '2025-08-25' AND DATE(t2.DtCriacao) <= '2025-08-29'


GROUP BY dtdia


-- 11. Quem iniciou o curso no primeiro dia, em média assistiu quantas aulas? 
WITH iniciou AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DATE(DtCriacao) = '2025-08-25'
),

total_aulas AS (
	SELECT
    	IdCliente,
    	COUNT(DISTINCT DATE(DtCriacao)) AS aulas_frequentadas
	FROM transacoes
	WHERE IdCliente IN (SELECT IdCliente FROM iniciou)
 	 AND DATE(DtCriacao) BETWEEN '2025-08-25' AND '2025-08-29'
	GROUP BY IdCliente
)

SELECT ROUND(AVG(aulas_frequentadas), 2) AS media_aula

FROM total_aulas;


-- 12. Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?
WITH cadastro_janeiro AS (
	SELECT idCliente

	FROM clientes

	WHERE strftime('%Y-%m', DtCriacao) = '2025-01'
)

SELECT COUNT(DISTINCT t1.IdCliente) AS clientes_curso

FROM transacoes t1

INNER JOIN cadastro_janeiro t2
ON t1.IdCliente = t2.IdCliente

WHERE DATE(DtCriacao) BETWEEN '2025-08-25' AND '2025-08-29';


-- 13. Qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 01?
WITH inicio_sql AS (
	SELECT 
		DISTINCT IdCliente
	FROM transacoes
	WHERE DATE(DtCriacao) = '2025-08-25'
),

total_transacao AS (
	SELECT IdCliente, DtCriacao, COUNT(IdTransacao) AS qtd_trans

	FROM transacoes

	WHERE IdCliente IN (SELECT * FROM inicio_sql) 
	AND DATE(DtCriacao) BETWEEN '2025-08-25' AND '2025-08-29'

	GROUP BY IdCliente, DATE(DtCriacao)
)

SELECT 
	IdCliente, DATE(DtCriacao) AS data_engajamento, MAX(qtd_trans) AS qtd_maxima

FROM total_transacao

GROUP BY IdCliente;


-- Resposta utilizando windowns functions
WITH inicio_sql AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DATE(DtCriacao) = '2025-08-25'
),

total_transacao AS (
    SELECT
        IdCliente,
        DATE(DtCriacao) AS data_transacao,
        COUNT(IdTransacao) AS qtd_trans
    FROM transacoes
    WHERE IdCliente IN (SELECT IdCliente FROM inicio_sql)
      AND DATE(DtCriacao) BETWEEN '2025-08-25' AND '2025-08-29'
    GROUP BY IdCliente, DATE(DtCriacao)
),
ranking AS (
    SELECT
        IdCliente,
        data_transacao,
        qtd_trans,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtd_trans DESC) AS rk
    FROM total_transacao
)

SELECT
    IdCliente,
    data_transacao AS data_engajamento,
    qtd_trans AS qtd_maxima
FROM ranking
WHERE rk = 1
ORDER BY IdCliente;