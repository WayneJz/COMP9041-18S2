// importing named exports we use brackets
import { createPostTile, uploadImage, createElement, checkStore } from './helpers.js';

// when importing 'default' exports, use below syntax
import API from './api.js';
import FRONTAPI from './api_front.js';

const api  = new API();
const frontapi = new FRONTAPI();
let allfeed = [];


// button initialization
function buttonInit(){
    const buttonId = ['login', 'register', 'upload', 'follow', 'update', 'follow_option'];
    for (let i = 0; i < buttonId.length; i ++){
        document.getElementById(buttonId[i]).style.display = 'none';
    }
}


// login function
const login = document.getElementById('login_button_1');
login.onclick = function(){
    buttonInit();
    document.getElementById('login').style.display = 'block';
    tologin();
}


// register function
const register = document.getElementById('register_button_1');
register.onclick = function(){
    buttonInit();
    document.getElementById('register').style.display = 'block';
    toregister();
}


// upload function
const upload = document.getElementById('upload_button_1');
upload.onclick = function(){
    buttonInit();
    document.getElementById('upload').style.display = 'block';
    toupload();
}


// follow function
const follow = document.getElementById('follow_button_1');
follow.onclick = function(){
    buttonInit();
    document.getElementById('follow').style.display = 'block';
    tofollow();
}


// update function
const update = document.getElementById('update_button_1');
update.onclick = function(){
    buttonInit();
    document.getElementById('update').style.display = 'block';
    toupdate();
}


// my post function
const mypost = document.getElementById('profile_button_1');
mypost.onclick = function(){
    buttonInit();
    userpost(checkStore('username'));
}


// signout function
const signout = document.getElementById('signout_button_1');
signout.onclick = function(){
    buttonInit();
    window.localStorage.clear();
    location.reload();
}


// login function - to login
function tologin(){
    const login_2 = document.getElementById('login_button_2');
    login_2.onclick = function(){
        const username = document.getElementById('luname').value;
        const password = document.getElementById('lpass').value;
    
        if (!username || !password){
            window.alert('Empty username or password!');
            return false;
        }
        const user = {
            "username" : username,
            "password" : password
        };
        const headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        };
        const method = 'POST'; 
        const path = 'auth/login';

        api.makeAPIRequest(path, {
            method, headers,
            body: JSON.stringify(user),
        })
        .then(function (res){
            if (res["token"]){
                window.alert('You are successfully logged in');
                window.localStorage.setItem('username', username);
                window.localStorage.setItem('token', res['token']);
                location.reload();
            }
            else{
                window.alert(res["message"]);
            }
        });
    }
}


// register function - to register
function toregister(){
    const register_2 = document.getElementById('register_button_2');
    register_2.onclick = async function() {
        const username = document.getElementById('runame').value;
        const password = document.getElementById('rpass').value;
        const email = document.getElementById('remail').value;
        const name = document.getElementById('rname').value;

        if (!username || !password || !email || !name){
            window.alert('Any part must not left empty!');
            return false;
        }
        const user = {
            "username" : username,
            "password" : password,
            "email": email,
            "name": name
        };
        const headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        };
        const method = 'POST'; 
        const path = 'auth/signup';

        await api.makeAPIRequest(path, {
            method, headers,
            body: JSON.stringify(user),
        })
        .then(function (res){
            if (res["token"]){
                window.alert('You are successfully registered');
                window.localStorage.setItem('username', username);
                window.localStorage.setItem('token', res['token']);
                location.reload();
            }
            else{
                window.alert(res["message"]);
            }
        });
    }
}


// upload function - to upload - ONLY FOR BACKEND
function toupload(){
    const uploader = document.getElementById('uploadfile');
    uploader.addEventListener('change', (event) => {
        const [ file ] = event.target.files;
        const validFileTypes = [ 'image/jpeg', 'image/png', 'image/jpg' ]
        const valid = validFileTypes.find(type => type === file.type);
        if (! valid){
            window.alert("You must upload an image file (jpg/jpeg/png) !");
            return false;
        }
        const upload_2 = document.getElementById('upload_button_2');
        upload_2.onclick = function () {
            const description = document.getElementById('filedes').value;
            if (! description){
                window.alert("The description must not left empty!");
                return false;
            }
            const reader = new FileReader();
            reader.readAsDataURL(file);

            reader.onload = (e) => {
                const payload = {
                    "description_text": description,
                    "src" : (e.target.result.split(','))[1]
                }
                const path = 'post';
                const headers = {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'Authorization' : 'Token ' + checkStore('token')
                };
                const method = 'POST';
                api.makeAPIRequest(path, {
                    method, headers,
                    body: JSON.stringify(payload)
                }).then(function () {
                    window.alert('You have successfully uploaded!');
                    location.reload();
                });
            };
        }
    });
}


// follow function - to follow - ONLY FOR BACKEND
function tofollow(){
    const follow_2 = document.getElementById('follow_button_2');
    follow_2.onclick = function() {
        const username = document.getElementById('funame').value;
        if (! username){
            window.alert("The username must not left empty!");
            return false;
        }
        const path = 'user/?username='+ username;
        const headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization' : 'Token ' + checkStore('token'),
        };
        const method = 'GET';
        api.makeAPIRequest(path, {
            method, headers
        }).then(function (res) {
            buttonInit();
            document.getElementById('follow_option').style.display = 'block';
            document.getElementById('follow_option').innerHTML = '';

            if ('username' in res){
                const info = createElement('b', username + ' exists !\xa0\xa0\xa0');
                const follow = createElement('li', 'Follow', { class:'nav-item', id: "follow_button_3", style: "cursor:pointer" });
                const unfollow = createElement('li', 'Unfollow', { class:'nav-item', id: "follow_button_4", style: "cursor:pointer" });
                document.getElementById('follow_option').appendChild(info);                
                document.getElementById('follow_option').appendChild(follow);
                document.getElementById('follow_option').appendChild(unfollow);
                followOpt(username);              
            }
            else{
                const info = createElement('b', username + ' does not exist !\xa0\xa0\xa0');
                document.getElementById('follow_option').appendChild(info);
            }
        });
    }
}


// follow - follow/unfollow option - ONLY FOR BACKEND
function followOpt(username){
    const follow = document.getElementById('follow_button_3');
    const unfollow = document.getElementById('follow_button_4');
    
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token'),
    };
    const method = 'PUT';

    follow.onclick = async function() {
        const path = 'user/follow?username='+ username;
        await api.makeAPIRequest(path, {
            method, headers
        }).then(function (res) {
            buttonInit();
            document.getElementById('follow_option').style.display = 'block';
            document.getElementById('follow_option').innerHTML = '';
            const info = createElement('b', res.message);
            document.getElementById('follow_option').appendChild(info);
            location.reload();     
        });
    }

    unfollow.onclick = async function() {
        const path = 'user/unfollow?username='+ username;
        await api.makeAPIRequest(path, {
            method, headers
        }).then(function (res) {
            buttonInit();
            document.getElementById('follow_option').style.display = 'block';
            document.getElementById('follow_option').innerHTML = '';
            const info = createElement('b', res.message);
            document.getElementById('follow_option').appendChild(info);
            location.reload(); 
        });
    }
}


// update function - to update name/email/password -  ONLY FOR BACKEND
function toupdate(){
    const update_2 = document.getElementById('update_button_2');
    update_2.onclick = async function() {
        const email = document.getElementById('upemail').value;
        const password = document.getElementById('uppass').value;
        const name = document.getElementById('upname').value;

        if (!email && !password && !name){
            window.alert('At least one parameter must be given!');
            return false;
        }
        const user = {
            "email": email,
            "name": name,
            "password" : password
        };
        const headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization' : 'Token ' + checkStore('token')
        };
        const method = 'PUT'; 
        const path = 'user';

        await api.makeAPIRequest(path, {
            method, headers,
            body: JSON.stringify(user),
        })
        .then(function (){
            location.reload(); 
        });
    }
}


// main switch
if (checkStore('token')){
    fbswitch();
    userprofile(1);
    userfetch();

    // infinite scroll implementation
    // only enabled for feed
    document.addEventListener("scroll", () => {
        const lastfeed = document.getElementById('large-feed').lastChild;
        if (checkStore('mode') === 'feed'){
            const lastfeedPos = lastfeed.offsetTop + lastfeed.clientHeight;
            const pagePos = window.pageYOffset + window.innerHeight;

            if(pagePos > lastfeedPos - 20) {
                userfetch();
            }
        }
    }, false);

}
else{
    frontfeed();
    fbswitch(1);
}


// function - frontend-backend switch
// switch after user logged in
function fbswitch(option = 2){
    if (option == 1){
        document.getElementById('upload_button_1').style.display = 'none';
        document.getElementById('follow_button_1').style.display = 'none';
        document.getElementById('update_button_1').style.display = 'none';
        document.getElementById('profile_button_1').style.display = 'none';
        document.getElementById('signout_button_1').style.display = 'none';
        document.getElementById('imglikes').style.display = 'none';
        document.getElementById('imgfollowed').style.display = 'none';
        document.getElementById('imgfollowing').style.display = 'none';
        document.getElementById('imgpost').style.display = 'none';
        document.getElementById('following_count').style.display = 'none';
        document.getElementById('profile_username').innerHTML = 'Please log in or register, here are some example images:';
    }
    else{
        document.getElementById('upload_button_1').style.display = 'inline';
        document.getElementById('follow_button_1').style.display = 'inline';
        document.getElementById('update_button_1').style.display = 'inline';
        document.getElementById('profile_button_1').style.display = 'inline';
        document.getElementById('signout_button_1').style.display = 'inline';
        document.getElementById('imglikes').style.display = 'inline';
        document.getElementById('imgfollowed').style.display = 'inline';
        document.getElementById('imgfollowing').style.display = 'inline';
        document.getElementById('imgpost').style.display = 'inline';
    }
}


// user profile function
// option 1: indicates user's feed
// option 2: indicates user's post (my post)
// option 3: indicates someone's post
async function userprofile(option, username = checkStore('username')){
    const path = 'user/?username=' + username;
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    const method = 'GET';
    await api.makeAPIRequest(path, {
        method, headers,
    })
    .then(function (res){
        const username = res.username;
        const followedcount = res.followed_num;
        let postcount = 0;
        let followingcount = 0;
        let posts = [];
        let following = [];
        for (let i = 0; i < res.posts.length; i ++){
            if (res.posts[i] !== 0){
                postcount += 1;
                posts.push(res.posts[i]);
            }
        }
        for (let j = 0; j < res.following.length; j ++){
            if (res.following[j] !== 0){
                followingcount += 1;
                following.push(res.following[j]);
            }
        }
        document.getElementById('following_count').style.display = 'none';
        if (username === checkStore('username') && option === 1){
            document.getElementById('profile_username').innerHTML = 'Welcome back ' + username + ' !\xa0\xa0\xa0';
            document.getElementById('return_feed').innerHTML = '';
        }
        else {
            if (username === checkStore('username')){
                followName(following);
            }
            document.getElementById('profile_username').innerHTML = 'The profile of ' + username + ' \xa0\xa0\xa0';
            const return_feed = document.getElementById('return_feed');
            return_feed.innerHTML = 'Click here to return ' + checkStore('username') + '\'s feed';
            return_feed.style.cssFloat = "right";
            return_feed.style.textDecoration = "underline";
            return_feed.style.cursor = "pointer";
            return_feed.addEventListener('click', () => {
                document.getElementById('large-feed').innerHTML = '';
                allfeed = [];
                userprofile(1); 
                userfetch();
            }, false);
        }
        likeCount(posts);
        document.getElementById('profile_followed').innerHTML = 'Followed: ' + followedcount + '\xa0';
        document.getElementById('profile_following').innerHTML = 'Following: ' + followingcount + '\xa0';
        document.getElementById('profile_post').innerHTML = 'Post: ' + postcount;
    });
}


// total likes count - USED BY userprofile
async function likeCount(posts){
    let totalLikes = 0;
    for (let i = 0; i < posts.length; i ++){
        const path = 'post/?id=' + posts[i];
        const headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization' : 'Token ' + checkStore('token')
        };
        const method = 'GET';
        await api.makeAPIRequest(path, {
            method, headers,
        })
        .then(function (res){
            let numLikes = 0;
            for (let i = 0; i < res.meta.likes.length; i ++){
                if (res.meta.likes[i] !== 0){
                    numLikes += 1;
                }
            }
            totalLikes += numLikes;
        });
    }
    document.getElementById('profile_likes').innerHTML = 'Likes Received: ' + totalLikes + '\xa0';
}


// following list - USED BY userprofile
async function followName(following){
    let followingName = [];
    for (let i = 0; i < following.length; i ++){
        const path = 'user/?id=' + following[i];
        const headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization' : 'Token ' + checkStore('token')
        };
        const method = 'GET';
        await api.makeAPIRequest(path, {
            method, headers,
        })
        .then(function (res){
            followingName.push(res.username);
        });
    }
    const names = followingName.join(',\xa0\xa0');
    document.getElementById('following_count').style.display = 'block';
    document.getElementById('following_count').innerHTML = 'You are following:\xa0\xa0' + names;
}


// user feed function
// conflict with userpost, so detele userpost first then display
async function userfetch(){
    window.localStorage.setItem('mode', 'feed');
    const path = 'user/feed?p=' + allfeed.length + '&n=' + '10';
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    const method = 'GET';
    await api.makeAPIRequest(path, {
        method, headers,
    })
    .then(function (res){
        if (res.posts.length > 0){
            for (let i = 0; i < res.posts.length; i ++){
                if (! allfeed.includes(res.posts[i].id.toString())){
                    document.getElementById('large-feed').appendChild(createfeedTile(res.posts[i]));
                    allfeed.push(res.posts[i].id.toString());
                }
            }
        }
        else{
            return false;
        }
    });
}


// user post function - display all posts belong to the user
// conflict with userfetch, so detele userfetch first then display
async function userpost(username){
    window.localStorage.setItem('mode', 'profile');
    const path = 'user/?username=' + username;
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    const method = 'GET';
    await api.makeAPIRequest(path, {
        method, headers,
    })
    .then(function (res){
        document.getElementById('large-feed').innerHTML = '';
        userprofile(3, username);
        if (res.posts[0] === 0){
            window.alert('This user has no post to display');
            return false;
        }
        for (let i = 0; i < res.posts.length; i ++){
            getpost(res.posts[i]);
        }
    });
}


// get post function - USED BY userpost
async function getpost(id){
    const path = 'post/?id=' + id;
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    const method = 'GET';
    await api.makeAPIRequest(path, {
        method, headers,
    }).then(function (post){
        document.getElementById('large-feed').appendChild(createfeedTile(post));
    });
}


// time convert function
function timeConvert(rawTime){
    const unixTime = new Date(rawTime * 1000);
    return unixTime.toLocaleString('en-AU');
}


// like calculator
function likeCalculator(post){
    let numLikes = 0;
    for (let i = 0; i < post.meta.likes.length; i ++){
        if (post.meta.likes[i] !== 0){
            numLikes += 1;
        }
    }
    return numLikes;
}


// feed implement function - ONLY FOR BACKEND JSON 
function createfeedTile(post) {
    const section = createElement('section', null, { class: 'post', id: post.id });
    const timeFormat = "Posted on " + timeConvert(post.meta.published);

    const author = createElement('h1', post.meta.author, { class: 'post-title', style: 'cursor:pointer', id: 'post-author' + post.id });
    author.addEventListener('click', () => userpost(post.meta.author));
    section.appendChild(author);

    section.appendChild(createElement('h5', post.meta.description_text, { class: 'post-description', id: 'post-description' + post.id }));
    section.appendChild(createElement('h5', timeFormat, { class: 'post-time' }));

    section.appendChild(createElement('img', null, 
    { src: 'data:image/png;base64,' + post.src, alt: post.meta.description_text, class: 'post-image', id: 'post-image' + post.id }));

    const likeicon = createElement('img', null, 
        { src: '/src/likes.png', alt: 'Likes', class: 'post-button', style: "cursor:pointer" });
    likeicon.addEventListener('click', () => tolike(post.id));
    section.appendChild(likeicon);
    
    section.appendChild(createElement('img', null, 
        { src: '/src/comments.jpg', alt: 'Comments', class: 'post-button', style: "cursor:pointer" }));

    if (checkStore('username') === post.meta.author){
        const deleteIcon = createElement('img', null, 
            { src: '/src/trashbin.png', alt: 'Delete', class: 'post-button', style: "cursor:pointer" });
        deleteIcon.addEventListener('click', () => liveUpdate(post.id, 2));
        section.appendChild(deleteIcon);

        const updateIcon = createElement('img', null, 
            { src: '/src/update.png', alt: 'Update', class: 'post-button', style: "cursor:pointer" });
        updateIcon.addEventListener('click', () => {
            const updateWindow = document.getElementById("updatefile" + post.id);
            if (updateWindow.style.display === 'none'){
                updateWindow.style.display = 'inline-block';
            }
            else{
                updateWindow.style.display = 'none';
            }
        });
        section.appendChild(updateIcon);
    }

    section.appendChild(createElement('h5', null, { class: "post-pad" }));
    section.appendChild(createElement('h5', likeCalculator(post), { class: "post-num", id: "likes-num" + post.id }));
    section.appendChild(createElement('h5', post.comments.length, { class: "post-num", id: "comment-num" + post.id }));
    section.appendChild(createElement('h5', null, { class: "post-pad" }));

    if (checkStore('username') === post.meta.author){
        const frame = createElement('li', null, { class: "post-update", id: "updatefile" + post.id });
        const updateImg = createElement('input', null, { type: "file" });
        updateImg.addEventListener('change', (event) => postUpdate(event, post.id));
        frame.appendChild(updateImg);

        const updateDes = createElement('input', null, { type: "text", size: "35", placeholder: "Description", id: "update-des" + post.id });
        updateDes.addEventListener('keydown', (event) => {
            if (event.key === 'Enter'){
                const payload = {
                    "description_text": updateDes.value
                };
                toPostUpdate(payload, post.id);
                updateDes.value = '';
            }
        });
        frame.appendChild(updateDes);
        section.appendChild(frame);
    }

    const commentinput = createElement('input', null, { class: "comment-input" , placeholder: "Leave some comments", id: "comment-input" + post.id });
    commentinput.addEventListener('keydown', (event) => {
        if (event.key === 'Enter'){
            tocomment(post.id, commentinput.value);
        }
    });
    section.appendChild(commentinput);
    post.comments = sortByKey(post.comments, 'published');
    for (let i = 0; i < post.comments.length; i++){
        section.appendChild(createElement('h5', post.comments[i].comment + '----------' + post.comments[i].author + ' ' + timeConvert(post.comments[i].published), { class: 'post-comments' }));
    }
    return section;
}


// like implementation function
function tolike(id){
    const path = 'post/like?id=' + id;
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    const method = 'PUT';
    api.makeAPIRequest(path, {
        method, headers,
    }).then(() => {
        liveUpdate(id);
    });
}


// comment implementation function
function tocomment(id, comment){
    const path = 'post/comment?id=' + id;
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    const commentbody = {
        'author': checkStore('token'),
        'published': (new Date()).getTime(),
        'comment': comment
    };
    const method = 'PUT';
    api.makeAPIRequest(path, {
        method, headers,
        body: JSON.stringify(commentbody)
    }).then(() => {
        liveUpdate(id);
        document.getElementById('comment-input' + id).value = '';
    });
}


// update post function
function postUpdate(event, id){
    const [ file ] = event.target.files;
    const validFileTypes = [ 'image/jpeg', 'image/png', 'image/jpg' ]
    const valid = validFileTypes.find(type => type === file.type);
    if (! valid){
        window.alert("You must upload an image file (jpg/jpeg/png) !");
        return false;
    }
    const update = document.getElementById('update-des' + id);
    update.addEventListener('keydown', (event) => {
        if (event.key === 'Enter'){
            const description = document.getElementById('update-des' + id).value;
            const reader = new FileReader();
            reader.readAsDataURL(file);
        
            reader.onload = (e) => {
                const payload = {
                    "description_text": description,
                    "src" : (e.target.result.split(','))[1]
                };
                return toPostUpdate(payload, id);
            }
        }
    });
}


// update post function - to post update
async function toPostUpdate(payload, id){
    const path = 'post/?id=' + id;
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    const method = 'PUT';
    await api.makeAPIRequest(path, {
        method, headers,
        body: JSON.stringify(payload)
    }).then(() => {
        liveUpdate(id);
    });
}


// sort JSON by key - function referenced from stackoverflow.com/questions/8175093
function sortByKey(array, key) {
    return array.sort(function(a, b) {
        var x = a[key]; 
        var y = b[key];
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    });
}


// live update function
// option 1: live update likes/comments/picture/description for particular post id
// option 2: delete the post
async function liveUpdate(id, option = 1){
    const path = 'post/?id=' + id;
    const headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization' : 'Token ' + checkStore('token')
    };
    if (option === 2){
        if (! window.confirm('Do you really want to delete the post?')){
            return false;
        }
        document.getElementById(id).innerHTML = '';
        const method = 'DELETE';
        await api.makeAPIRequest(path, {
            method, headers,
        });
        return true;
    }
    const method = 'GET';
    await api.makeAPIRequest(path, {
        method, headers,
    }).then(function (post){
        document.getElementById('post-description' + id).innerHTML = post.meta.description_text;
        document.getElementById('post-image' + id).setAttribute("src", 'data:image/png;base64,' + post.src);
        document.getElementById('post-image' + id).setAttribute("alt", post.meta.description_text);
        document.getElementById('likes-num' + id).innerHTML = likeCalculator(post);
        const previousCommentNum = document.getElementById('comment-num' + id).innerHTML;
        const section = document.getElementById(id);
        post.comments = sortByKey(post.comments, 'published');
        for (let i = previousCommentNum; i < post.comments.length; i++){
            section.appendChild(createElement('h5', post.comments[i].comment + '----------' + post.comments[i].author + ' ' + timeConvert(post.comments[i].published), { class: 'post-comments' }));
        }
        document.getElementById('comment-num' + id).innerHTML = post.comments.length;
    });
}


// frontfeed function - if haven't signed in, by default displays the frontend data
function frontfeed(){
    const feed = frontapi.getFeed();
    feed
    .then(posts => {
        posts.reduce((parent, post) => {
            parent.appendChild(createPostTile(post));
            return parent;
        }, document.getElementById('large-feed'))
    });  
}



// Written by Zhou JIANG, z5146092
