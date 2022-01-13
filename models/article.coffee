module.exports = (sequelize, Sequelize) ->
  sequelize.define "article", {
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
  }, {
    underscored: true,
    timestamps:false,
  }
