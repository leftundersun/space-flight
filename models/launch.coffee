module.exports = (sequelize, Sequelize) ->
  sequelize.define "launch", {
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
  }, {
    tableName: 'launches'
    underscored: true
    timestamps: false
  }