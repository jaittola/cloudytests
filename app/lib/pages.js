const express = require('express');
const path = require('path');

let server;

function setup(webserver) {
    server = webserver;
    server.use(express.static(path.join(__dirname, '..', 'web-ui')));
}

function index(req, res) {
    res.redirect('index.html');
}

module.exports = {
    setup: setup,
    index: index,
};
