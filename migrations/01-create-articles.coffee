'use strict';
module.exports = {
  up: (queryInterface, Sequelize) ->
    return queryInterface.createTable 'articles', {
      id: {
        type: Sequelize.INTEGER(11)
        primaryKey: true
        allowNull: false
        autoIncrement: false
      }
      featured: {
        type: Sequelize.BOOLEAN
        allowNull: false
      }
      title: {
        type: Sequelize.TEXT
        allowNull: false
      }
      url: {
        type: Sequelize.TEXT
        allowNull: false
      }
      imageUrl: {
        type: Sequelize.TEXT
        allowNull: false
      }
      newsSite: {
        type: Sequelize.TEXT
        allowNull: false
      }
      summary: {
        type: Sequelize.TEXT
        allowNull: false
      }
      publishedAt: {
        type: Sequelize.STRING(50)
        allowNull: false
      }
    }
  down: (queryInterface, Sequelize) ->
    return queryInterface.dropTable('articles')
}