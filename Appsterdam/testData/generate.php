<?php

$events = array();
$events['past'] = array();
$events['past'][] = array(
    'name' => 'Past Event',
    'description' => 'WOOOOO',
    'icon' => 'star',
    'attendees' => 1
);
$events['future'] = array();
$events['future'][] = array(
    'name' => 'future Event',
    'description' => 'WOOOOO',
    'icon' => 'star',
    'attendees' => 1
);

$people = array("Mike Lee", "Wesley de Groot", "Jake Ruston");

file_put_contents("test-people.json", json_encode($people));
file_put_contents("test-events.json", json_encode($events));
?>
