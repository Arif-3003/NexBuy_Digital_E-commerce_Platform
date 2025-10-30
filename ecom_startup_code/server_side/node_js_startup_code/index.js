const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
const port = 5000;

app.use(bodyParser.json());

mongoose.connect('mongodb+srv://Arif:LF2yoGiw8s46RqMw@cluster1.3bgem4y.mongodb.net/online_store?retryWrites=true&w=majority');

const db = mongoose.connection;
db.on('error', (error) => console.error('Database connection error:', error));
db.once('open', () => console.log('Connected to Database'));

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

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
