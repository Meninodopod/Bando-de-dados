--apaga o banco de dados caso exista
DROP DATABASE IF EXISTS uvv;
--apaga o usuario caso exista
DROP USER IF EXISTS mikaelgomes;
--cria um usuario
CREATE USER mikaelgomes WITH createdb createrole encrypted password 'pod';
--cria um banco de dados
CREATE DATABASE uvv 
    WITH 
    OWNER = mikaelgomes
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = true;
    \c "dbname=uvv user=mikaelgomes password=pod"
--cria um schema     
CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION mikaelgomes;
ALTER USER mikaelgomes
SET SEARCH_PATH TO lojas, "$user", public;
--cria a tabela de produtos
CREATE TABLE lojas.produtos (
                produtos_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produtos_id PRIMARY KEY (produtos_id)
);
COMMENT ON COLUMN lojas.produtos.produtos_id IS 'ID do produto.';
COMMENT ON COLUMN lojas.produtos.nome IS 'Nome do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Preço do produto.';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Detalhes do produto.';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Tipo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Arquivo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'Charset da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Data da ultima atualização.';


CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
            
                CONSTRAINT lojas_id PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas.lojas IS 'Tabela de lojas.';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'ID da loja.';
COMMENT ON COLUMN lojas.lojas.nome IS 'Nome da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'Endereço web da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Endereço fisíco da loja.';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Latitude da loja.';
COMMENT ON COLUMN lojas.lojas.longitude IS 'Longitude da loja.';
COMMENT ON COLUMN lojas.lojas.logo IS 'Logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Tipo de logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Arquivo da logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Logo charset da loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Data da ultima atualização.';

--cria a tabela estoques
CREATE TABLE lojas.estoques (
                estoques_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produtos_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoques_id PRIMARY KEY (estoques_id)
);
COMMENT ON TABLE lojas.estoques IS 'Tabela de estoques.';
COMMENT ON COLUMN lojas.estoques.estoques_id IS 'ID do estoque.';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'ID da loja.';
COMMENT ON COLUMN lojas.estoques.produtos_id IS 'ID do produto.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade de produtos no estoque.';

--cria a tabela clientes
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE lojas.clientes IS 'Tabela de clientes.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'ID do cliente.';
COMMENT ON COLUMN lojas.clientes.email IS 'E-mail do cliente.';
COMMENT ON COLUMN lojas.clientes.nome IS 'Nomes dos clientes.';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'Telefone primário do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'Telefone secundário do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'Telefone terciário do cliente.';

--cria a tabela de envios
CREATE TABLE lojas.envios (
                envios_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envios_id PRIMARY KEY (envios_id)
);
COMMENT ON TABLE lojas.envios IS 'Tabela de envios.';
COMMENT ON COLUMN lojas.envios.envios_id IS 'ID do envio.';
COMMENT ON COLUMN lojas.envios.loja_id IS 'ID da loja.';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'ID do cliente.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereço de entrega.';
COMMENT ON COLUMN lojas.envios.status IS 'Status do envio.';


CREATE TABLE lojas.pedidos (
                pedidos_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_id PRIMARY KEY (pedidos_id)
);
COMMENT ON TABLE lojas.pedidos IS 'Tabela de pedidos.';
COMMENT ON COLUMN lojas.pedidos.pedidos_id IS 'ID dos pedidos dos clientes.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'ID do cliente.';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'Data e hora.';
COMMENT ON COLUMN lojas.pedidos.status IS 'Status do pedido.';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'ID da loja.';

--cria a tabela "pedidos_itens"
CREATE TABLE lojas.pedidos_itens (
                pedidos_id NUMERIC(38) NOT NULL,
                produtos_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envios_id NUMERIC(38),
                CONSTRAINT pedidos_id_produtos_id PRIMARY KEY (pedidos_id, produtos_id)
);
COMMENT ON TABLE lojas.pedidos_itens IS 'Tabela de pedidos e itens.';
COMMENT ON COLUMN lojas.pedidos_itens.pedidos_id IS 'ID do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.produtos_id IS 'ID do produto.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Número da linha do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'Preço do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'Quantidade de pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.envios_id IS 'ID do envio.';

--cria a foreing key da tabela estoques
ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produtos_id)
REFERENCES lojas.produtos (produtos_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--cria a foreing key da tabela pedidos itens 
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produtos_id)
REFERENCES lojas.produtos (produtos_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--cria a foreing key da tabela pedidos 
ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--cria a foreing key da tabela envios
ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--cria a foreing key da tabela envios
ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--cria a foreing da tabela pedidos 
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--cria a foreing da tabela envios
ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envios_id)
REFERENCES lojas.envios (envios_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--cria a foreing key da tabela pedidos itens
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedidos_id)
REFERENCES lojas.pedidos (pedidos_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--restrição para status do pedido
ALTER TABLE lojas.pedidos ADD CONSTRAINT status check (status in('completo', 'pago', 'cancelado', 'aberto', 'reembolsado', 'enviado'));
--restrição para status do envio
ALTER TABLE lojas.envios ADD CONSTRAINT status check (status in('criado', 'enviado', 'transito', 'entregue'));
--restrição para algum dos endereços estar preenchido
ALTER TABLE lojas.lojas ADD CONSTRAINT pelo_menos_um_endereco check(endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);
