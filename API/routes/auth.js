const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const usuariosSchema = require('../models/modelsUsuario');
const bcrypt = require('bcrypt'); // Importa bcrypt

router.post('/login', async (req, res) => {
  const { email, contrasena } = req.body;

  try {
    // Buscar el usuario por email
    const usuarioDB = await usuariosSchema.findOne({ email });
    if (!usuarioDB) {
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    // Comparar la contraseña en texto plano con la contraseña cifrada almacenada
    const isPasswordValid = await bcrypt.compare(contrasena, usuarioDB.contrasena);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    // Crear la carga útil (payload) para el token
    const payload = {
      id: usuarioDB._id,
      email: usuarioDB.email,
      rol: usuarioDB.rol,
    };

    // Generar el token (con expiración de 1 hora)
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
