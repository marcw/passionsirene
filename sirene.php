<?php

require_once __DIR__.'/config.php';
require_once __DIR__.'/vendor/twitteroauth/twitteroauth/twitteroauth.php';

$connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRET);

$original = function() {
    $ahu  = str_repeat('A', rand(1, 15));
    $ahu .= str_repeat('H', rand(4, 15));
    $ahu .= str_repeat('U', rand(10, 35));

    return $ahu;
};

$styles = array(
  $original,
  $original,
  $original,
  function() {
    $wowo = '';
    for ($i = 0; $i < 4; $i++) {
      $wowo .= str_repeat('W', rand(1, 3));
      $wowo .= str_repeat('O', rand(1, 7));
      $wowo .= str_repeat('H', rand(1, 3));
      $wowo .= str_repeat('O', rand(3, 6));
    }

    return $wowo;
  }
);


$style = $styles[array_rand($styles)];
$tweet = '';
if ($style instanceof \Closure) {
  $tweet = $style();
} else {
  $tweet = $style;
}

$connection->post('statuses/update', array('status' => $tweet));
