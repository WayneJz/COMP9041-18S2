(function() {
    'use strict';
    const path = 'https://jsonplaceholder.typicode.com/posts';
    fetch(path)
        .then(response => response.json())
        .then(data => data.reduce((parent, post) => {
            const sublist = document.createElement('div');
            sublist.textContent(post["title"]);
            parent.appendChild(sublist);
            return parent;
        }, document.getElementById('output')));
 }());
