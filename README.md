# Covid-19 Brazil

## Pré-requisitos
- [Ruby 2.7.1](http://www.ruby-lang.org)
- [Yarn](https://yarnpkg.com/getting-started/install)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Ambiende de desenvolvimento

### Configuração

Em um terminal, execute:

```bash
bundle install

yarn install

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