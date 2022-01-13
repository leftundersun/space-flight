module.exports = (sequelize, Sequelize) ->
  sequelize.define "event", {
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
    underscored: true
    timestamps: false
  }
