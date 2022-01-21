# Space Flight News Articles API

## Visão geral
Essa é uma API em Node.js de artigos do Space Flight News.

### Linguagens e frameworks
*	**Node.js** 
*	**CoffeeScript** 
*	**MySQL** 
*	**Express.js** 
*	**Gulp.js** para compilar os arquivos .coffee para .js
*	**Axios**  para fazer requisições http
*	**Dotenv** para configurar rapidamente variáveis de ambiente
*	**Helmet.js** para maior segurança
*	**Moment.js** para mais fácil manipulação de datas
*	**morgan** para rápidos e enxutos logs no console de execução
*	**Node MySQL 2** para conectar a ORM ao banco de dados
*	**Node Cron** para agendar scripts para rodarem em determinado momento
*	**npm-run-all** para agilizar a execução dos passos para subir o sistema
*	**Sequelize ORM** para manipular o banco de dados
*	**winston** para log em arquivo para consulta futura

### Rodando pela primeira vez
Para rodar a api pela primeira vez, siga os seguintes passos na raiz do projeto:
* execute o commando `docker build --tag space_flight .` cara construir a imagem do sistema
* rode o sistema com o comando `docker-compose up`

>  This is a challenge by [Coodesh](https://coodesh.com/)