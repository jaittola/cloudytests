
const express = require('express');
const app = express();
const pages = require('./lib/pages.js');

const port = 8000;

pages.setup(app);
app.get("/", pages.index);
app.listen(8000, () => console.log(`Listening to port ${port}`));
