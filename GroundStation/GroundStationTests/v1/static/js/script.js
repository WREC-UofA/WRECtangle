const socket = io();

socket.on('update', function(data) {
    document.getElementById('status-text').textContent = data.status;
    document.getElementById('time-on').textContent = data.time_on;
    const bubble = document.getElementById('status-bubble');
    if (data.status === 'OK') {
        bubble.className = 'bubble green';
    } else {
        bubble.className = 'bubble red';
    }
});