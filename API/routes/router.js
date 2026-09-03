const express = require('express');
const bcrypt = require('bcrypt');
const usuariosSchema = require('../models/modelsUsuario');

const router = express.Router();

router.get('/getAll', async (req, res) => {
    try {
        const data = await usuariosSchema.find().sort({ points: -1 }).limit(5);
        res.status(200).json(data);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post('/getOne', async (req, res) => {
    try {
        const { email } = req.body;

        const usuarioDB = await usuariosSchema.findOne({ email });
        if (!usuarioDB) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        res.status(200).json(usuarioDB);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


router.post('/new', async (req, res) => {
    try {
  
      const data = new usuariosSchema({
        username: req.body.username,
        email: req.body.email,
        password: req.body.password,
        points: req.body.points || 0
      });
  
      const dataToSave = await data.save();
      res.status(200).json(dataToSave);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
});


router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        const usuarioDB = await usuariosSchema.findOne({ email, password });
        if (!usuarioDB) {
            return res.status(404).json({ message: "Usuario o contraseña incorrectos" });
        }

        res.status(200).json(usuarioDB);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});




router.delete('/delete', async (req, res) => {
    try {
        const { dni } = req.body;
        const data = await usuariosSchema.deleteOne({ dni });
        if (data.deletedCount === 0) {
            return res.status(404).json({ message: "Documento no encontrado" });
        }
        res.status(200).json({ message: `Documento con dni: ${dni} eliminado` });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.post('/updatePoints', async (req, res) => {
    try {
        const { email, points } = req.body;

        const updatedUser = await usuariosSchema.findOneAndUpdate(
            { email },
            { points },
            { new: true }
        );

        if (!updatedUser) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        res.status(200).json(updatedUser);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});


router.post('/getOneEmail', async (req, res) => {
    try {
      const { email } = req.body;
      const usuarioDB = await usuariosSchema.findOne({ email });
      if (!usuarioDB) {
        return res.status(404).json({ message: "Documento no encontrado" });
      }
      res.status(200).json(usuarioDB);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  });

module.exports = router;