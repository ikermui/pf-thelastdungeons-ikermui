const express = require('express');

const routerSave = express.Router();
const savaSchema = require('../models/modelsSave');

routerSave.get('/getAll', async (req, res) => {
    try {
        const data = await savaSchema.find();
        res.status(200).json(data);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

routerSave.get('/getSave/:email', async (req, res) => {
    try{
        const user = req.params.email;
        const save = await savaSchema.findOne({user });
        if (!save) {
            return res.status(404).json({ message: "Documento no encontrado" });
        }
      res.status(200).json(save);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

routerSave.patch('/saveGame/:email', async (req, res) => {
    try {
        const user = req.params.email;
        const updateData = req.body;

        const updatedSave = await savaSchema.findOneAndUpdate(
            { user },              
            { $set: 
                updateData,
                save_time: Date.now()
             }, 
            {
                new: true,        
                upsert: true      
            }
        );

        res.status(200).json(updatedSave);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

routerSave.delete('/deleteSave/:email', async (req, res) => {
    try {
        const user = req.params.email;
        const deletedSave = await savaSchema.findOneAndDelete({ user });
        if (!deletedSave) {
            return res.status(404).json({ message: "Documento no encontrado" });
        }
        res.status(200).json({ message: "Documento eliminado" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


module.exports = routerSave;