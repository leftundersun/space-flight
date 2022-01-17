'use strict';
module.exports = {
  up: (queryInterface, Sequelize) ->
    return queryInterface.createTable 'article_events', {
      articleId: {
        primaryKey: true
        type: Sequelize.INTEGER(11)
        allowNull: false
        references: {
          model: 'articles'
          key: 'id'
        }
      }
      eventId: {
        primaryKey: true
        type: Sequelize.STRING(50)
        allowNull: false
        references: {
          model: 'events'
          key: 'id'
        }
      }
    }
  down: (queryInterface, Sequelize) ->
    return queryInterface.dropTable('article_events')
}