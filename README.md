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

export URL=https://data.brasil.io/dataset/covid19/caso.csv.gz

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

## Ambiente de produção

### Importar carga de dados
<https://data.brasil.io/dataset/covid19/_meta/list.html>

Execute os comandos:

```bash
rails db:mongoid:create_indexes

export URL=https://data.brasil.io/dataset/covid19/caso.csv.gz

rails db:import:caso_csv

rails db:seed
```
