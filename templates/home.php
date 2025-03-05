<?php

$request_uri = $_SERVER['REQUEST_URI'];
$allowedPaths = ['/', '/articles'];

if (in_array($request_uri, $allowedPaths)) {
    include '../templates/base/header.html';
    if ($request_uri === '/') {
        include '../templates/home.html';
    } else {
        if ($request_uri === '/articles') {
            include '../templates/articles.html';
        }
    }
    include '../templates/base/footer.html';
} else {
    http_response_code(404);
    echo '<h1>404 Not Found</h1>';
    echo '<a href="/">Go to home page</a>';
}
