'use strict';
module.exports = {
  up: (queryInterface, Sequelize) ->
    return queryInterface.createTable 'launches', {
      id: {
        type: Sequelize.STRING(50)
        primaryKey: true
        allowNull: false
        autoIncrement: false
      }
      provider: {
        type: Sequelize.STRING(50)
        allowNull: false
      }
    }
  down: (queryInterface, Sequelize) ->
    return queryInterface.dropTable('launches')
}