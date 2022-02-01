<?php

$events = array();
$events[] = array(
    'name' => 'Upcoming',
    'events' => array(
        array(
            'id' => '1',
            'name' => 'Weekly Meeten en Drinken',
            'description' => "What shall we drink\nSeven days long\nWhat shall we drink?\nWhat a thirst!\n\nThere's plenty for everyone\nSo we'll drink together\nSo just dip into the cask!\nYes, let's drink together\nNot alone!\n\nAnd then we shall work\nSeven days long!\nThen we shall work\nFor each other!\n\nThen there will be work for everyone\nSo we shall work together\nSeven days long!\nYes, we'll work together\nNot alone!\n\nBut first we have to fight\nNobody knows for how long!\nFirst we have to fight\nFor our interest!\n\nFor everybody's happiness\nSo we'll fight together\nTogether we're strong!\nYes, we'll fight together\nNot alone!",
            'price' => 0,
            'organizer' => 'Appsterdam',
            'location' => 'Bax',
            'address' => 'Ten Katestraat 119, 1053 CC Amsterdam, Netherlands',
            'date' => '20220101190000:20220101220000',
            'icon' => '🍺',
            'attendees' => 1,
            'latitude' => 0,
            'longitude' => 0
        ),
        array(
            'id' => '280861388',
            'name' => 'Weekend Fun: ARTIS',
            'description' => 'SOME USELESS DESCRIPTION 🐘🌍😄',
            'price' => 30,
            'organizer' => 'Appsterdam',
            'location' => 'ARTIS',
            'address' => 'Plantage Kerklaan 38-40, Amsterdam, Netherlands',
            'date' => '20220101190000:20220101220000',
            'icon' => '🐘',
            'attendees' => 1,
            'latitude' => 0,
            'longitude' => 0
        ),
        array(
            'id' => '3',
            'name' => 'Coffee Coding',
            'description' => 'WOOOOO',
            'price' => 0,
            'organizer' => 'Appsterdam',
            'location' => 'Coffee Room',
            'address' => 'Ten Katestraat 119, 1053 CC Amsterdam, Netherlands',
            'date' => '20220101190000:20220101220000',
            'icon' => 'note.text',
            'attendees' => 1,
            'latitude' => 0,
            'longitude' => 0
        )
    )
);

for ($i = 2022; $i >= 2012; $i--) {
    $events[] = array(
        'name' => sprintf("%s", $i),
        'events' => array(
            array(
                'id' => $i . '1',
                'name' => 'Past Event (' . $i . ', 1)',
                'description' => 'WOOOOO',
                'price' => 0,
                'organizer' => 'Appsterdam',
                'location' => 'Bax',
                'address' => 'Ten Katestraat 119, 1053 CC Amsterdam, Netherlands',
                'date' => '20220101190000:20220101220000',
                'icon' => 'star',
                'attendees' => 1,
                'latitude' => 0,
                'longitude' => 0
            ),
            array(
                'id' => $i . '2',
                'name' => 'Past Event (' . $i . ', 2)',
                'description' => 'WOOOOO',
                'price' => 0,
                'organizer' => 'Appsterdam',
                'location' => 'Bax',
                'address' => 'Ten Katestraat 119, 1053 CC Amsterdam, Netherlands',
                'date' => '20220101190000:20220101220000',
                'icon' => 'star',
                'attendees' => 1,
                'latitude' => 0,
                'longitude' => 0
            ),
            array(
                'id' => $i . '3',
                'name' => 'Past Event (' . $i . ', 2)',
                'description' => 'WOOOOO',
                'price' => 0,
                'organizer' => 'Appsterdam',
                'location' => 'Bax',
                'address' => 'Ten Katestraat 119, 1053 CC Amsterdam, Netherlands',
                'date' => '20220101190000:20220101220000',
                'icon' => 'star',
                'attendees' => 1,
                'latitude' => 0,
                'longitude' => 0
            ),
        )
    );
}

$people[] = array(
    'team' => 'Board',
    'members' => array(
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
        )
    )
);

$people[] = array(
    'team' => 'Coffee Coding',
    'members' => array(
        array(
            "name" => "Maike Warner",
            "picture" => "https://i0.wp.com/appsterdam.rs/wp-content/uploads/2021/12/Maike_Warner.png?w=640&ssl=1",
            "function" => "Coffee Coding organizer"
        ),
        array(
            "name" => "Dániel Varga",
            "function" => "Coffee Coding organizer"
        )
    )
);

$people[] = array(
    'team' => 'Weekend Fun',
    'members' => array(
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
    )
);

file_put_contents("people.json", json_encode($people, JSON_PRETTY_PRINT));
file_put_contents("events.json", json_encode($events, JSON_PRETTY_PRINT));
