# Pokebattle

## Sobre

## Como usar

A API atualmente permite criar uma batalha, listar todas batalhas e exibir uma batalha especifica utilizando o endpoint `api/battle`. Essas ações são feitas a partir dos verbos HTTP.

- Uma requisição POST no endpoint **cria uma nova batalha**. No corpo da requisição deve haver o nome do primeiro pokemon (**pokemon1**: string), o nome do segundo pokemon (**pokemon2**: string), e se a API deve retornar informações adicionais sobre os pokemons (**extra_info**: boolean).
- Uma requisição GET no endpoint **lista todas batalhas**. Não é necessário corpo na requisição.
- Uma requisição GET no endpoint passando um id no fim do caminho **exibe a batalha com o id informado**. Não é necessário corpo na requisição.

### Exemplos de uso

<details>

<summary>Criar batalha</summary>
POST em `/api/battle`

Corpo da requisição:
```json
{
  "pokemon1": "ditto",
  "pokemon2": "bulbasaur",
  "extra_info": false,
}
```

Corpo da resposta:
```json
{
  "id": 1,
  "pokemon1": "ditto",
  "pokemon2": "bulbasaur",
  "winner": "bulbasaur"
}
```
</details>

<details>
<summary>Listar batalhas</summary>

GET em `/api/battle`

Corpo da resposta:
```json
[
  {
    "id": 1,
    "pokemon1": {
      "name": "ditto",
      "stats": [...]
      ...
    },
    "pokemon2": {
      "name": "bulbasaur",
      "stats": [...]
      ...
    },
    "winner": "bulbasaur",
  },
  {
    "id": 2,
    "pokemon1": {
      "name": "charmander",
      "stats": [...],
      ...
    },
    "pokemon2": {
      "name": "gyarados",
      "stats": [...],
      ...
    },
    "winner": "charmander",
  }
]
```
</details>

<details>
<summary>Consultar batalha</summary>

GET em `/api/battle/1`

Corpo da resposta:
```json
{
  "id": 1,
  "pokemon1": {
    "name": "ditto",
    "stats": [...]
    ...
  },
  "pokemon2": {
    "name": "bulbasaur",
    "stats": [...]
    ...
  },
  "winner": "bulbasaur",
}
```
</details>

## Como funciona

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
