# Pokebattle

## Sobre

## Como usar




### Exemplos de uso

#### Criar batalha

#### Listar batalhas

#### Consultar batalha

## Como contribuir

### Iniciando a API

A aplicação espera que o PostgreSQL esteja rodando na porta 5432, com usuário `postgres` e senha `postgres`. Caso necessário, rode o seguinte comando para iniciar um container docker com o PostgreSQL configurado.

```console
docker run -d --name db --network host -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres postgres
```

Para iniciar a aplicação:
* Executar o comando `mix setup` para instalar e configurar dependencias
* Iniciar o servidor com `mix phx.server`

A aplicação estará rodando em [`localhost:4000`](http://localhost:4000).

### Estrutura de arquivos

- [`test/`](/test/):
  - [`pokebattle_web/`](/test/pokebattle_web/): Testes da API
    - [`controllers/battle_controller_test.exs`](/test/pokebattle_web/controllers/battle_controller_test.exs): Testes para o controller do endpoint `/api/battle`
  - [`support/`](/test/support/): Funções auxiliares de teste

- [`lib/`](/lib/):
  - [`pokebattle/`](/lib/pokebattle/): Pasta relacionada às regras de negócio
    - [`battle.ex`](/lib/pokebattle/battle.ex): Arquivo que contém a definição da tabela de batalhas no banco de dados, assim como a lógica para validação de um pokemon, escolha de pokemon vencedor e busca de informações do pokemon
  - [`pokebattle_web/`](/lib/pokebattle_web/): Pasta relacionada à web
    - [`router.ex`](/lib/pokebattle_web/router.ex): Arquivo que contém os caminhos dos endpoints da API e os relaciona com as funções do controller
    - [`controllers/battle_controller.ex`](/lib/pokebattle_web/controllers/battle_controller.ex): Arquivo que contém as funções que serão chamadas ao acessar o endpoint `/api/battle`

### Validação de nome dos pokemons

A validação é feita a partir de uma consulta à [PokeAPI](https://pokeapi.co/) no endpoint de pokemons, usando o nome do pokemon como parâmetro. Se a requisição retornar um código de status 404, significa que o nome não é válido. Caso retorne o código de status 200, o pokemon existe.

### Escolha de campeão

O pokemon campeão é escolhido aleatoriamente.

No futuro é possível comparar as informações de cada pokemon para decidir o campeão. Uma boa informação para comparar seria as estatísticas base (defesa, ataque, pontos de vida) 
