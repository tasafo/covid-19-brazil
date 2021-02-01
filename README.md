# Covid-19 Brazil

## Pré-requisitos
- [Ruby 3](http://www.ruby-lang.org)
- [Yarn](https://yarnpkg.com/getting-started/install)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Ambiente de desenvolvimento

### Configuração

Em um terminal, execute:

```bash
bundle install

yarn install

rails db:mongoid:create_indexes

rails db:seed
```

### Execução

Em um terminal, para subir containers MongoDB e Redis, execute:

```bash
docker-compose up
```

Em outro terminal, execute:

```bash
rails server
```

No navegador, abra o endereço:

```
http://localhost:3000
```

### Importar caso.csv para carga inicial de dados
<https://data.brasil.io/dataset/covid19/_meta/list.html>

Copie o link do arquivo `caso.csv.gz` e execute o comando:

```bash
URL=https://data.brasil.io/dataset/covid19/caso.csv.gz rails db:import:caso_csv
```
