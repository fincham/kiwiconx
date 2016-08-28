/* stolen from https://stackoverflow.com/a/901144 */
function get_parameter_by_name(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function create_terminal() {
    var protocol;
    var socket_url;
    var container = document.getElementById('terminal-container')

    var term = new Terminal({
        cursorBlink: true
    });

    protocol = (location.protocol === 'https:') ? 'wss://' : 'ws://';
    socket_url = protocol + location.hostname + '/tty/' + get_parameter_by_name('host');
    console.log(socket_url);

    term.open(container);
    term.fit();

    socket = new WebSocket(socket_url);
    socket.onopen = function() {
        term.attach(socket);
        term._initialized = true;
    };
}

create_terminal();
