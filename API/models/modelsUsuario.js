const mongoose = require("mongoose");

const usuariosSchema = new mongoose.Schema({
  username: {
    required: true, // Campo obligatorio
    type: String,   // Tipo de dato: String
  },
  email: {
    required: true, // Campo obligatorio
    type: String,   // Tipo de dato: String
  },
  password: {
    required: true, // Campo obligatorio
    type: String,   // Tipo de dato: String
  },
  points: {
    required: true, // Campo obligatorio
    type: Number,   // Tipo de dato: String
  }
});

module.exports = mongoose.model("usuarios", usuariosSchema);
