require('dotenv').config(); // Carga las variables de entorno

const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const app = express();
const usuariosSchema = require('./models/modelsUsuario');

app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

// Conexión a la base de datos
const mongoString = process.env.DATABASE_URL;
mongoose.connect(mongoString);

const database = mongoose.connection;
database.on('error', (error) => {
    console.log(error);
});
database.once('connected', () => {
    console.log('Database Connected');
});

// Rutas
const router = require('./routes/router');   // Rutas de usuarios


app.use('/user', router);
const routerSave = require('./routes/routerSave');   // Rutas de usuarios
app.use('/save', routerSave);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`);
});
