(function () {
    'use strict';
    const path = 'https://jsonplaceholder.typicode.com/users';
    fetch(path)
        .then(response => response.json())
        .then(data => data.reduce((parent, user) => {
            parent.append(user["name"] + ' ');
            return parent;
        }, document.getElementById('output')));
}());
