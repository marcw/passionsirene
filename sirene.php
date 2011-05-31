<?php

require_once __DIR__.'/config.php';
require_once __DIR__.'/vendor/twitteroauth/twitteroauth/twitteroauth.php';

$connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRET);

$styles = array(
  function() {
    $ahu  = str_repeat('A', rand(1, 15));
    $ahu .= str_repeat('H', rand(4, 15));
    $ahu .= str_repeat('U', rand(10, 35));

    return $ahu;
  },
);


$style = $styles[array_rand($styles)];
$tweet = '';
if ($style instanceof \Closure) {
  $tweet = $style();
} else {
  $tweet = $style;
}

$connection->post('statuses/update', array('status' => $tweet));
