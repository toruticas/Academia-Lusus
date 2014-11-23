CREATE DATABASE rede_social_tematica;
USE rede_social_tematica;

CREATE TABLE usuario(
    cpf INT NOT NULL
  , rg VARCHAR(32) NOT NULL
  , nome VARCHAR(64) NOT NULL
  , categoria CHAR(7) NOT NULL
  , CONSTRAINT pk_usuario PRIMARY KEY(cpf)
  , CONSTRAINT uk_usuario UNIQUE(rg)
  , CONSTRAINT ck_usuario CHECK (upper(categoria) IN ('ADMIN', 'JUIZ', 'EMPRESA', 'ALUNO'))
);

CREATE TABLE amigo(
    usuario_a INT NOT NULL
  , usuario_b INT NOT NULL
  , CONSTRAINT pk_amigo PRIMARY KEY(usuario_a, usuario_b)
  , CONSTRAINT fk_amigo_usuario_a FOREIGN KEY(usuario_a) REFERENCES usuario(cpf)
  , CONSTRAINT fk_amigo_usuario_b FOREIGN KEY(usuario_b) REFERENCES usuario(cpf)
);

CREATE TABLE juiz(
    cpf INT NOT NULL
  , registro_federacao VARCHAR(32) NOT NULL
  , CONSTRAINT pk_juiz PRIMARY KEY(cpf)
  , CONSTRAINT fk_juiz FOREIGN KEY(cpf) REFERENCES usuario(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT uk_juiz UNIQUE(registro_federacao)
);

CREATE TABLE admin(
    cpf INT NOT NULL
  , CONSTRAINT pk_admin FOREIGN KEY(cpf) REFERENCES usuario(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT uk_admin PRIMARY KEY(cpf)
);

CREATE TABLE empresa(
    cpf INT NOT NULL
  , cnpj INT NOT NULL
  , CONSTRAINT pk_juiz PRIMARY KEY(cpf)
  , CONSTRAINT fk_empresa FOREIGN KEY(cpf) REFERENCES usuario(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT uk_empresa UNIQUE(cnpj)
);

CREATE TABLE aluno(
    cpf INT NOT NULL
  , ra VARCHAR(32) NOT NULL
  , faculdade VARCHAR(32) NOT NULL
  , contato VARCHAR(32) NOT NULL
  , curso VARCHAR(32) NOT NULL
  , CONSTRAINT pk_aluno PRIMARY KEY(cpf)
  , CONSTRAINT fk_aluno FOREIGN KEY(cpf) REFERENCES usuario(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT uk_aluno UNIQUE(ra, faculdade)
);

CREATE TABLE modalidade(
    nome VARCHAR(32) NOT NULL
  , descricao TEXT
  , restricoes TEXT
  , CONSTRAINT pk_modalidade PRIMARY KEY(nome)
);

CREATE TABLE diretor_modalidade(
    cpf INT NOT NULL
  , modalidade VARCHAR(32) NOT NULL
  , CONSTRAINT pk_diretor_modalidade PRIMARY KEY(cpf)
  , CONSTRAINT fk_diretor_modalidade_usuario FOREIGN KEY(cpf) REFERENCES aluno(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_diretor_modalidade_modalide FOREIGN KEY(modalidade) REFERENCES modalidade(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE diretor_evento(
    cpf INT NOT NULL
  , CONSTRAINT pk_diretor_evento PRIMARY KEY(cpf)
  , CONSTRAINT fk_diretor_evento FOREIGN KEY(cpf) REFERENCES aluno(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE atleta(
    cpf INT NOT NULL
  , ano_ingresso INT(4) NOT NULL
  , CONSTRAINT pk_atleta PRIMARY KEY(cpf)
  , CONSTRAINT fk_atleta FOREIGN KEY(cpf) REFERENCES aluno(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE presidente(
    cpf INT NOT NULL
  , ano_ini INT NOT NULL
  , ano_fim INT NOT NULL
  , CONSTRAINT pk_presidente PRIMARY KEY(cpf)
  , CONSTRAINT fk_presidente FOREIGN KEY(cpf) REFERENCES aluno(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE evento(
    id INT NOT NULL AUTO_INCREMENT
  , nome VARCHAR(64) NOT NULL
  , presidente INT
  , diretor_evento INT
  , data_ini DATE NOT NULL
  , data_fim DATE NOT NULL
  , local VARCHAR(64) NOT NULL
  , descricao TEXT
  , CONSTRAINT pk_evento PRIMARY KEY(id)
  , CONSTRAINT fk_evento_presidente FOREIGN KEY(presidente) REFERENCES presidente(cpf) ON DELETE SET NULL ON UPDATE SET NULL
  , CONSTRAINT fk_evento_diretor_evento FOREIGN KEY(diretor_evento) REFERENCES diretor_evento(cpf) ON DELETE SET NULL ON UPDATE CASCADE
  , CONSTRAINT uk_evento UNIQUE(nome, presidente, diretor_evento)
);

CREATE TABLE topico_evento(
    id INT NOT NULL AUTO_INCREMENT
  , usuario INT
  , evento INT NOT NULL
  , datetime TIMESTAMP NOT NULL
  , titulo VARCHAR(64) NOT NULL
  , corpo TEXT NOT NULL
  , CONSTRAINT pk_topico_evento PRIMARY KEY(id)
  , CONSTRAINT fk_topico_evento_usuario FOREIGN KEY(usuario) REFERENCES usuario(cpf) ON DELETE SET NULL ON UPDATE SET NULL
  , CONSTRAINT fk_topico_evento_evento FOREIGN KEY(evento) REFERENCES evento(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT uk_topico_evento UNIQUE(evento, datetime, usuario)
);

CREATE TABLE grupo(
    id INT NOT NULL AUTO_INCREMENT
  , presidente INT NOT NULL
  , diretor_modalidade INT
  , nome VARCHAR(64) NOT NULL
  , nro_integrantes INT NOT NULL
  , tipo CHAR(7) NOT NULL
  , CONSTRAINT pk_grupo PRIMARY KEY(id)
  , CONSTRAINT fk_grupo_presidente FOREIGN KEY(presidente) REFERENCES presidente(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_grupo_diretor_modalidade FOREIGN KEY(diretor_modalidade) REFERENCES diretor_modalidade(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT ck_grupo CHECK(upper(tipo) IN ('SECRETO', 'FECHADO', 'PUBLICO'))
);

CREATE TABLE topico_grupo(
    id INT NOT NULL AUTO_INCREMENT
  , usuario INT NOT NULL
  , grupo INT NOT NULL
  , datetime TIMESTAMP NOT NULL
  , titulo VARCHAR(64) NOT NULL
  , corpo TEXT NOT NULL
  , CONSTRAINT pk_topico_grupo PRIMARY KEY(id)
  , CONSTRAINT fk_topico_grupo_usuario FOREIGN KEY(usuario) REFERENCES usuario(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_topico_grupo_evento FOREIGN KEY(grupo) REFERENCES grupo(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT uk_topico_grupo UNIQUE(grupo, datetime, usuario)
);

CREATE TABLE comanda(
    presidente INT NOT NULL
  , aluno INT NOT NULL
  , CONSTRAINT pk_comanda PRIMARY KEY(presidente, aluno)
  , CONSTRAINT fk_comanda_presidente FOREIGN KEY(presidente) REFERENCES presidente(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_comanda_aluno FOREIGN KEY(aluno) REFERENCES aluno(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE doc_extra(
    atleta INT NOT NULL
  , nome VARCHAR(32) NOT NULL
  , arquivo VARCHAR(64) NOT NULL
  , CONSTRAINT pk_doc_extra PRIMARY KEY(atleta, nome)
  , CONSTRAINT fk_doc_extra FOREIGN KEY(atleta) REFERENCES atleta(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE participa_evento(
    empresa INT NOT NULL
  , evento INT NOT NULL
  , CONSTRAINT pk_participa_evento PRIMARY KEY(empresa, evento)
  , CONSTRAINT fk_participa_evento_empresa FOREIGN KEY(empresa) REFERENCES empresa(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_participa_evento_evento FOREIGN KEY(evento) REFERENCES evento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE participa_modalidade(
    atleta INT NOT NULL
  , modalidade VARCHAR(32) NOT NULL
  , CONSTRAINT pk_participa_modalidade PRIMARY KEY(atleta, modalidade)
  , CONSTRAINT fk_participa_modalidade_atleta FOREIGN KEY(atleta) REFERENCES atleta(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_participa_modalidade_modalidade FOREIGN KEY(modalidade) REFERENCES modalidade(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE arbitra_modalidade(
    juiz INT NOT NULL
  , modalidade VARCHAR(32) NOT NULL
  , CONSTRAINT pk_arbitra_modalidade PRIMARY KEY(juiz, modalidade)
  , CONSTRAINT fk_arbitra_modalidade_juiz FOREIGN KEY(juiz) REFERENCES juiz(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_arbitra_modalidade_modalidade FOREIGN KEY(modalidade) REFERENCES modalidade(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE modalidade_evento(
    evento INT NOT NULL
  , modalidade VARCHAR(32) NOT NULL
  , CONSTRAINT pk_modalidade_evento PRIMARY KEY(evento, modalidade)
  , CONSTRAINT fk_modalidade_evento_evento FOREIGN KEY(evento) REFERENCES evento(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_modalidade_evento_modalidade FOREIGN KEY(modalidade) REFERENCES modalidade(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE participacao(
    id INT NOT NULL AUTO_INCREMENT
  , evento INT NOT NULL
  , usuario INT NOT NULL
  , CONSTRAINT pk_participacao PRIMARY KEY(id)
  , CONSTRAINT fk_participacao_evento FOREIGN KEY(evento) REFERENCES evento(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_participacao_usuario FOREIGN KEY(usuario) REFERENCES usuario(cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE vigencia(
    id INT NOT NULL
  , nome VARCHAR(64) NOT NULL
  , ano_criacao INT(4) NOT NULL
  , CONSTRAINT pk_vigencia PRIMARY KEY(id)
  , CONSTRAINT uk_vigencia UNIQUE(nome, ano_criacao)
);

CREATE TABLE ano_utilizado(
    vigencia INT NOT NULL
  , ano INT(4) NOT NULL
  , CONSTRAINT pk_ano_utilizado PRIMARY KEY(vigencia, ano)
  , CONSTRAINT fk_ano_utilizado FOREIGN KEY(vigencia) REFERENCES vigencia(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tipo_vigencia(
    vigencia INT NOT NULL
  , tipo VARCHAR(11) NOT NULL
  , CONSTRAINT pk_tipo_vigencia PRIMARY KEY(vigencia,tipo)
  , CONSTRAINT fk_tipo_vigencia FOREIGN KEY(vigencia) REFERENCES vigencia(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT ck_tipo_vigencia CHECK( upper(tipo) IN ('ESTATUTO','REGIMENTO', 'CONTRATO', 'REGULAMENTO') )
);

CREATE TABLE gerencia_vigencia(
    id INT NOT NULL
  , vigencia INT NOT NULL
  , evento INT NOT NULL
  , CONSTRAINT pk_gerencia_vigencia PRIMARY KEY(id)
  , CONSTRAINT fk_gerencia_vigecial_vigencia FOREIGN KEY(vigencia) REFERENCES vigencia(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_gerencia_vigecial_evento  FOREIGN KEY(evento) REFERENCES evento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE organiza(
    grupo INT NOT NULL
  , gerencia_vigencia INT NOT NULL
  , CONSTRAINT pk_organiza PRIMARY KEY(grupo, gerencia_vigencia)
  , CONSTRAINT fk_organiza_grupo FOREIGN KEY(grupo) REFERENCES grupo(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_organzia_gerencia_vigencia FOREIGN KEY(gerencia_vigencia) REFERENCES gerencia_vigencia(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE participa_grupo(
    usuario INT NOT NULL
  , grupo INT NOT NULL
  , CONSTRAINT pk_participa_grupo PRIMARY KEY(usuario, grupo)
  , CONSTRAINT fk_participa_grupo_usuario FOREIGN KEY(usuario) REFERENCES usuario(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_participa_grupo_grupo FOREIGN KEY(grupo) REFERENCES grupo(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE credencia(
    id INT NOT NULL
  , atleta INT NOT NULL
  , participacao INT NOT NULL
  , CONSTRAINT pk_credencia PRIMARY KEY(id)
  , CONSTRAINT fk_credencia_atleta FOREIGN KEY(atleta) REFERENCES atleta(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_credencia_participacao FOREIGN KEY(participacao) REFERENCES participacao(id) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT uk_credencia UNIQUE(atleta, participacao)
);

CREATE TABLE documentos(
    credencia INT NOT NULL
  , atleta INT NOT NULL
  , nome VARCHAR(65) NOT NULL
  , CONSTRAINT pk_documentos PRIMARY KEY(credencia, atleta, nome)
  , CONSTRAINT fk_documentos_atleta FOREIGN KEY(atleta) REFERENCES atleta(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_documentos_credencia FOREIGN KEY(credencia) REFERENCES credencia(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE gerencia_grupo(
    presidente INT NOT NULL
  , diretor_modalidade INT NOT NULL
  , grupo INT NOT NULL
  , CONSTRAINT pk_gerencia_grupo PRIMARY KEY(presidente, diretor_modalidade, grupo)
  , CONSTRAINT fk_gerencia_grupo_presidente FOREIGN KEY(presidente) REFERENCES presidente(cpf) ON DELETE CASCADE ON UPDATE CASCADE
  , CONSTRAINT fk_gerencia_grupo_diretor_modalidade FOREIGN KEY(diretor_modalidade) REFERENCES diretor_modalidade(cpf)
  , CONSTRAINT fk_gerencia_grupo_grupo FOREIGN KEY(grupo) REFERENCES grupo(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE msg_grupo(
    usuario INT NOT NULL
  , grupo INT NOT NULL
  , datetime TIMESTAMP NOT NULL
  , corpo TEXT NOT NULL
  , CONSTRAINT pk_msg_grupo PRIMARY KEY(usuario, grupo, datetime)
  , CONSTRAINT fk_msg_grupo FOREIGN KEY(usuario, grupo) REFERENCES participa_grupo(usuario, grupo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE msg_evento(
    participacao INT NOT NULL
  , datetime TIMESTAMP NOT NULL
  , corpo TEXT NOT NULL
  , CONSTRAINT pk_msg_evento PRIMARY KEY(participacao, datetime)
  , CONSTRAINT fk_msg_evento FOREIGN KEY(participacao) REFERENCES participacao(id) ON DELETE CASCADE ON UPDATE CASCADE
);

--TABELA USUARIO
INSERT INTO usuario VALUES (0, 0, 'Adm0', 'ADMIN');
INSERT INTO usuario VALUES (1, 1, 'Adm1', 'ADMIN');
INSERT INTO usuario VALUES (2, 2, 'Aluno2', 'ALUNO');
INSERT INTO usuario VALUES (3, 3, 'Aluno3', 'ALUNO');
INSERT INTO usuario VALUES (4, 4, 'Aluno4', 'ALUNO');
INSERT INTO usuario VALUES (5, 5, 'Aluno5', 'ALUNO');
INSERT INTO usuario VALUES (6, 6, 'Aluno6', 'ALUNO');
INSERT INTO usuario VALUES (7, 7, 'Aluno7', 'ALUNO');
INSERT INTO usuario VALUES (8, 8, 'Aluno8', 'ALUNO');
INSERT INTO usuario VALUES (9, 9, 'Aluno9', 'ALUNO');
INSERT INTO usuario VALUES (10, 10, 'Juiz10', 'JUIZ');
INSERT INTO usuario VALUES (11, 11, 'Juiz11', 'JUIZ');
INSERT INTO usuario VALUES (12, 12, 'Empresa12', 'EMPRESA');
INSERT INTO usuario VALUES (13, 13, 'Empresa13', 'EMPRESA');

--TABELA ALUNO
INSERT INTO aluno VALUES (2, 2,'USP','email2','BCC');
INSERT INTO aluno VALUES (3, 3,'Federal','email3','Antropologia');
INSERT INTO aluno VALUES (4, 4,'Federal','email4','Ciencias do meio ambiente');
INSERT INTO aluno VALUES (5, 5,'USP','email5','Engenharia Eletrica');
INSERT INTO aluno VALUES (6, 6,'USP','email6','Engenharia Civil');
INSERT INTO aluno VALUES (7, 7,'Federal','email7','Filosofia');
INSERT INTO aluno VALUES (8, 8,'USP','email8','Engenharia de Produção');
INSERT INTO aluno VALUES (9, 9,'Federal','email9','Educação Especial');

--TABELA PRESIDENTE
INSERT INTO presidente VALUES (2, 2013, 2014);
INSERT INTO presidente VALUES (3, 2013, 2014);

--TABELA MODALIDADE
INSERT INTO modalidade VALUES ('XADREZ', 'Estrategia do grego Strategia', 'nenhuma');
INSERT INTO modalidade VALUES ('JIU-JITSU', 'Oss!', 'nenhuma');

--TABELA DIRETOR DE MODALIDADE
INSERT INTO diretor_modalidade VALUES (5, 'XADREZ');
INSERT INTO diretor_modalidade VALUES (4, 'JIU-JITSU');

--TABELA ATLETA
INSERT INTO atleta VALUES (6, 2010);
INSERT INTO atleta VALUES (7, 2011);

--TABELA DIRETOR DE EVENTO
INSERT INTO diretor_evento VALUES (8);
INSERT INTO diretor_evento VALUES (9);

--TABELA EVENTO
INSERT INTO evento VALUES (1, 'TUSCA 2014', 2, 8, STR_TO_DATE('2014-11-15', '%Y-%m-%d'), STR_TO_DATE('2014-11-18', '%Y-%m-%d'), 'Sao Carlos', 'O maior do Brasil'); 
INSERT INTO evento VALUES (2, 'Tusquinha 2014', 3, 9, '2014-04-15', '2014-04-16', 'Sao Carlos', 'Torneio entre bixos do CAASO e da Federal');

--TABELA PARTICIPACAO (EVENTO)
--presidente caaso
INSERT INTO participacao VALUES (1, 1, 2);
--presidente federal
INSERT INTO participacao VALUES (2, 1, 3);
--diretor jiu-jitsu federal
INSERT INTO participacao VALUES (3, 1, 4); 
--diretor xadrez caaso
INSERT INTO participacao VALUES (4, 1, 5); 
--atleta xadrez caaso
INSERT INTO participacao VALUES (5, 1, 6); 
--atleta jiu-jitsu federal
INSERT INTO participacao VALUES (6, 1, 7); 
--diretor de eventos caaso
INSERT INTO participacao VALUES (7, 1, 8);
--diretor de eventos federal
INSERT INTO participacao VALUES (8, 1, 9); 

--TABELA TOPICO EVENTO
INSERT INTO topico_evento VALUES (1, 2, 1, '2014-11-15', 'Que comece o TUSCA!', '**** FEDERAL!');
INSERT INTO topico_evento VALUES (2, 3, 2, '2014-11-15', 'Que comece o Tusquinha!', 'XCS');

--TABELA MENSAGEM EVENTO
INSERT INTO msg_evento VALUES (1, '2014-11-15', 'Vamoooo!');
INSERT INTO msg_evento VALUES (2, '2014-04-15', 'Boooora!');

--TABELA GRUPO
INSERT INTO grupo VALUES (1, 2, 5, 'XADREZ CAASO', 2, 'FECHADO');
INSERT INTO grupo VALUES (2, 3, 4, 'JIU-JITSU FEDERAL', 2, 'FECHADO');

--TABELA TOPICO GRUPO
INSERT INTO topico_grupo VALUES (1, 5, 1, '2014-10-15', 'CONTAGEM REGRESSIVA', 'Falta 1 mes para o TUSCA! XADREZ!');
INSERT INTO topico_grupo VALUES (2, 4, 2, '2014-10-15', 'CONTAGEM REGRESSIVA', 'Falta 1 mes para o TUSCA! JIU-JITSU!');

--TABELA PARTICIPA_GRUPO
INSERT INTO participa_grupo VALUES (2, 1);

INSERT INTO participa_grupo VALUES (5, 1);
INSERT INTO participa_grupo VALUES (6, 1);
INSERT INTO participa_grupo VALUES (3, 2);

INSERT INTO participa_grupo VALUES (4, 2);
INSERT INTO participa_grupo VALUES (7, 2);

--TABELA MENSAGEM GRUPO
INSERT INTO msg_grupo VALUES (2, 1, '2014-10-15', 'Boaaaa! RAÇA CAASO!');
INSERT INTO msg_grupo VALUES (3, 2, '2014-10-15', 'Boaaaa! VAMO FEDERAL!');

--TABELA JUIZ
INSERT INTO juiz VALUES (10, 10);
INSERT INTO juiz VALUES (11, 11);

--TABELA ADMIN
INSERT INTO admin VALUES (0);
INSERT INTO admin VALUES (1);

--TABELA EMPRESA
INSERT INTO empresa VALUES (12, 12);
INSERT INTO empresa VALUES (13, 13);

--TABELA COMANDA
INSERT INTO comanda VALUES (2, 5);
INSERT INTO comanda VALUES (3, 4);

--TABELA DOC_EXTRA
INSERT INTO doc_extra VALUES (6, 'Atestado de Aluno', 'atestadoAluno.pdf');
INSERT INTO doc_extra VALUES (7, 'Atestado de Matricula', 'atestadoMatricula.pdf');

--TABELA PARTICIPA_EVENTO
INSERT INTO participa_evento VALUES (12, 1);
INSERT INTO participa_evento VALUES (13, 1);

--TABELA PARTICIPA_MODALIDADE
INSERT INTO participa_modalidade VALUES (6, 'XADREZ');
INSERT INTO participa_modalidade VALUES (7, 'JIU-JITSU');

--TABELA ARBITRA_MODALIDADE
INSERT INTO arbitra_modalidade VALUES (10, 'XADREZ');
INSERT INTO arbitra_modalidade VALUES (11, 'JIU-JITSU');

--TABELA MODALIDADE_EVENTO
INSERT INTO modalidade_evento VALUES (1, 'XADREZ');
INSERT INTO modalidade_evento VALUES (1, 'JIU-JITSU');

--TABELA VIGENCIA
INSERT INTO vigencia VALUES (1, 'TUSCA', 2013);
INSERT INTO vigencia VALUES (2, 'Tusquinha', 2010);

--TABELA ANO_UTILIZADO
INSERT INTO ano_utilizado VALUES (1, 2014);
INSERT INTO ano_utilizado VALUES (1, 2013);
INSERT INTO ano_utilizado VALUES (2, 2014);

--TABELA TIPO_VIGENCIA
INSERT INTO tipo_vigencia VALUES (1, 'ESTATUTO');
INSERT INTO tipo_vigencia VALUES (1, 'CONTRATO');
INSERT INTO tipo_vigencia VALUES (1, 'REGULAMENTO');
INSERT INTO tipo_vigencia VALUES (2, 'REGULAMENTO');

--TABELA GERENCIA_VIGENCIA
INSERT INTO gerencia_vigencia VALUES (1, 1, 1);
INSERT INTO gerencia_vigencia VALUES (2, 2, 2);

--TABELA ORGANIZA
INSERT INTO organiza VALUES (1, 1);
INSERT INTO organiza VALUES (2, 1);

--TABELA CREDENCIA
INSERT INTO credencia VALUES (1, 6, 5);
INSERT INTO credencia VALUES (2, 7, 6);

--TABELA DOCUMENTOS
INSERT INTO documentos VALUES (1, 6, 'Atestado de Aluno');
INSERT INTO documentos VALUES (2, 7, 'Atesdado de Matricula');

--TABELA GERENCIA_GRUPO
INSERT INTO gerencia_grupo VALUES (2, 5, 1);
INSERT INTO gerencia_grupo VALUES (3, 4, 2);

--TABELA AMIGO
INSERT INTO amigo VALUES (2, 5);
INSERT INTO amigo VALUES (3, 4);

-- 1) Selecionar o nome, o ra e a faculdade de todos os atletas da modalidade xadrez que participaram do evento TUSCA de 2014.
-- Essa query poderia gerar inconsistência se fosse escrita de forma errada, problema que abordamos desde a primeira parte do projeto.
SELECT US.nome, AL.ra, AL.faculdade FROM usuario US
       INNER JOIN aluno AL ON US.cpf=AL.cpf
       INNER JOIN atleta AT ON AL.cpf = AT.cpf
       INNER JOIN participa_modalidade PM ON PM.atleta = AT.cpf
       INNER JOIN modalidade MO ON MO.nome = PM.modalidade
       INNER JOIN credencia CR ON CR.atleta = PM.atleta
       INNER JOIN participacao PA ON PA.id = CR.participacao
       INNER JOIN evento EV ON EV.id = PA.evento
       WHERE upper(MO.nome)='XADREZ' AND upper(EV.nome)='TUSCA 2014';

-- 2) Seleciona a quantidade de mensagens e de tópicos em cada grupo apresentado
SELECT G.nome, count(DISTINCT M.usuario, M.grupo, M.datetime) AS mensagens,
               count(DISTINCT T.id) AS topicos FROM grupo G
               LEFT JOIN msg_grupo M ON M.grupo = G.id
               LEFT JOIN topico_grupo T ON T.grupo = G.id
               GROUP BY G.id