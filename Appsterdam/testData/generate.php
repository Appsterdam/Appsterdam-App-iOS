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

$people = array(
                array(
                      "name" => "Mike Lee",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/11/Mike-lee-min.png?resize=600%2C600&ssl=1",
                      "function" => "Mayor of Appsterdam"
                ),
                array(
                      "name" => "Martinus Meiborg",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Martinus_Meiborg.jpeg?w=450&ssl=1",
                      "function" => "Board member"
                ),
                array(
                      "name" => "Tom van Arman",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Tom_van_Arman.jpeg?resize=700%2C700&ssl=1",
                      "function" => "Board member"
                ),
                array(
                      "name" => "Samuel Goodwin",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Samuel_Goodwin.jpeg?w=397&ssl=1",
                      "function" => "Board member"
                ),
                array(
                      "name" => "Jacqueline de Gruijter",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Jacqueline_de_Gruijter.jpeg?resize=700%2C700&ssl=1",
                      "function" => "Board member"
                ),
                array(
                      "name" => "Maike Warner",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Maike_Warner.png?w=640&ssl=1",
                      "function" => "Coffee Coding organizer"
                ),
                array(
                      "name" => "Dániel Varga",
                      "function" => "Coffee Coding organizer"
                ),
                array(
                      "name" => "Wesley de Groot",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Wesley_de_Groot.jpeg?w=328&ssl=1",
                      "function" => "Weekend Fun organizer"
                ),
                array(
                      "name" => "Jake Ruston",
                      "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Jake_Ruston.jpeg?w=689&ssl=1",
                      "function" => "Weekend Fun organizer"
                )
);

file_put_contents("test-people.json", json_encode($people));
file_put_contents("test-events.json", json_encode($events));
?>
