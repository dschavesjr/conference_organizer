# Conference Organizer

<h3>Configuração para rodar a aplicação localmente (Desenvolvimento e Teste)</h3>

Tenha certeza de ter instalado:
* Ruby 3.0.2
* Postgresql 12+
* Node 16+
* Yarn

Execute na pasta do projeto: <b>bundle install</b>

Configure o arquivo <b>config/database.yml</b> com usuário e senha do banco de dados (BD)

Crie os seguintes bancos de dados: <b>conference_organizer_development</b> e <b>conference_organizer_test</b>
Caso o usuário possua permissão de criação, poderá ser feito executando: <b>rails db:create</b> 

Execute: <b>rails db:migrate</b>

Execute: <b>rails s</b>
  
<h3>Usando e testando a aplicação</h3>

No navegador, acesse: http://localhost:3000/palestras

Os arquivos para carga de dados aceitos pela API devem possuir um formato json esperado:
```
  [
    {
      "nome":"Nome da Palestra", 
      "tempo": 30
    },
    {
      "nome":"Nome da Palestra 2", 
      "tempo":45
    }
  ]
```

> Um <b>exemplo de arquivo</b> esperado encontra-se localizado na <b>pasta raiz</b> "palestras.json"

<h3>Rodando os testes automatizados</h3>
Execute: <b>rspec</b>
Ou
Execute: <b>rspec spec/path</b> (alterando "path" para o caminho completo do arquivo) para rodar um teste específico.

<h3>Considerações Finais e Possíveis Melhorias Futuras</h3>

Toda atividade foi mais focada na construção do algoritmo de organização.
Em uma melhoria futura, consideraria implementar na API dois endpoints, um para receber (POST) o arquivo e realizar a gravação das palestras e outro (GET) para responder com o evento organizado. Desta forma, a API ao lidar com diferentes situações no recebimento de arquivo poderia entregar diferentes respostas (arquivo inválido, quantidade de registros gravados, se a gravação foi completa ou parcial, etc). Todavia como a task pedia explicitamente que a resposta do endpoint já fosse o evento organizado, essa foi a maneira tratada na aplicação. 

Uma outra melhoria futura é nos testes automatizados, que só foi implementado o "caminho feliz" dos dois principais pontos de atenção da app: API e algoritimo de organização.

