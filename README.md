# Lucee + MySQL Example

Projeto mínimo em Lucee que acessa a tabela `mensagens` e exibe as mensagens e seus autores na página.

## Como usar

1. Execute `docker compose up -d`
2. Abra no navegador: http://localhost:1988

## Estrutura

- `docker-compose.yml` - ambiente Lucee + MySQL
- `db/init-db.sql` - cria a base `luceeapp` e a tabela `mensagens`
- `src/Application.cfc` - configura o datasource `mydb`
- `src/index.cfm` - consulta `mensagens` e as exibe

## Resultado esperado

A página deve mostrar:

```
**Autor 1** Mensagem 1
**Autor 2** Mensagem 2
**Autor 3** Mensagem 3
...
```
