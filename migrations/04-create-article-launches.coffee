'use strict';
module.exports = {
  up: (queryInterface, Sequelize) ->
    return queryInterface.createTable 'article_launches', {
      articleId: {
        primaryKey: true
        type: Sequelize.INTEGER(11)
        allowNull: false
        references: {
          model: 'articles'
          key: 'id'
        }
      }
      launchId: {
        primaryKey: true
        type: Sequelize.STRING(50)
        allowNull: false
        references: {
          model: 'launches'
          key: 'id'
        }
      }
    }
  down: (queryInterface, Sequelize) ->
    return queryInterface.dropTable('article_launches')
}