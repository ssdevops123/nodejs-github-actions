const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send('Hello from Microservice!');
});

// Health Check Route for ALB
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'UP' });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Microservice running on port ${PORT}`);
});
