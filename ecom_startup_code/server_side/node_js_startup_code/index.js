const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require("cors");
const path = require("path");

const app = express();
const port = 5000;

// ====== Body Parsers ======
app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

mongoose.connect('mongodb+srv://Arif:LF2yoGiw8s46RqMw@cluster1.3bgem4y.mongodb.net/online_store?retryWrites=true&w=majority');

const db = mongoose.connection;
db.on('error', (error) => console.error('Database connection error:', error));
db.once('open', () => console.log('Connected to Database'));

// test model
const { Schema, model } = mongoose;
const userSchema = new Schema({
  name: String,
  age: Number,
  email: String
});
const User = model('User', userSchema);

app.delete('/:id', async (req, res) => {
  const id = req.params.id;
  await User.findByIdAndDelete(id);
  res.json('Delete successfully');
});

app.get('/', (req, res) => {
  res.send('Server is running and connected to MongoDB!');
});

// ====== IMPORT YOUR BOT.JS ======
app.use("/bot", require("./routes/bot"));  // <-- IMPORTANT

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
