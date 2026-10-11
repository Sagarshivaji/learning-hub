const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

const PORT = process.env.PORT || 3000;
const DATA_FILE = path.join(__dirname, 'data.json');

app.use(cors());
app.use(express.static(path.join(__dirname, 'public')));

let items = [];

// Load data
if (fs.existsSync(DATA_FILE)) {
    try {
        const raw = fs.readFileSync(DATA_FILE, 'utf8');
        items = JSON.parse(raw);
    } catch (e) {
        console.error("Error reading data.json", e);
    }
}

function saveData() {
    fs.writeFileSync(DATA_FILE, JSON.stringify(items, null, 2));
}

io.on('connection', (socket) => {
    console.log('A user connected:', socket.id);

    // Send current items to the newly connected client
    socket.emit('init', items);

    // Handle adding an item
    socket.on('addItem', (item) => {
        // Prevent duplicate IDs just in case
        if (!items.find(i => i.id === item.id)) {
            items.unshift(item);
            saveData();
            // Broadcast to everyone else
            socket.broadcast.emit('itemAdded', item);
        }
    });

    // Handle toggling done state
    socket.on('toggleItem', (id) => {
        const item = items.find(i => i.id === id);
        if (item) {
            item.done = !item.done;
            saveData();
            // Broadcast to everyone else
            socket.broadcast.emit('itemUpdated', item);
        }
    });

    // Handle removing an item
    socket.on('removeItem', (id) => {
        items = items.filter(i => i.id !== id);
        saveData();
        // Broadcast to everyone else
        socket.broadcast.emit('itemRemoved', id);
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});

app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

server.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
