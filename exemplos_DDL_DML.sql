-- #######################################################################
-- Aula sobre DDL e DML - Codigo para criar uma tabela e atualizar.

-- Deleta a tabela se ela existir
DROP TABLE IF EXISTS relatorio_diario;

-- Cria uma nova tabela para que não precise ficar atualizando a tabela original
CREATE TABLE IF NOT EXISTS relatorio_diario AS

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

-- Carregar tabela salva
SELECT *

FROM relatorio_diario



--##############################################################
-- Utilizando DELETE e INSERT
DELETE FROM relatorio_diario;

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

INSERT INTO relatorio_diario

SELECT 
	IdCliente, DATE(DtCriacao) AS data_engajamento, MAX(qtd_trans) AS qtd_maxima

FROM total_transacao

GROUP BY IdCliente;


-- Carregar tabela salva
SELECT *

FROM relatorio_diario


--##################################################################
-- Utilizando UPDATE para alterar dados da tabela
UPDATE relatorio_diario
SET qtd_maxima = 10
WHERE data_engajamento = '2025-08-29' AND IdCliente = '000ff655-fa9f-4baa-a108-47f581ec52a1';


--##################################################################
-- Criando uma nova tabela 
-- DROP TABLE IF EXISTS clientes_teste;

CREATE TABLE clientes_teste (
	Idcliente varchar(250) PRIMARY KEY,
	qtdtransacoes INTEGER
);

SELECT *

FROM clientes_teste
-- Query para consultar os dados existentes e inserir na nova tabela
INSERT INTO clientes_teste

SELECT 
	IdCliente,
	COUNT(DISTINCT IdTransacao) AS qtdtransacoes
FROM transacoes

WHERE julianday('now') - julianday(DATE(DtCriacao)) < 150
GROUP BY IdCliente;